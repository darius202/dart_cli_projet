# Task Manager CLI

## Description

**Task Manager CLI** est une application de gestion de tâches développée en **Dart pur** (sans Flutter), réalisée dans le cadre de la formation FlutterFire.

L'objectif de ce projet est de mettre en pratique les concepts fondamentaux du langage Dart orienté objet : classes abstraites, héritage, interfaces, génériques, gestion des exceptions personnalisées et tests unitaires.

L'application fonctionne entièrement en ligne de commande et permet à un utilisateur de gérer ses tâches avec une sauvegarde persistante dans un fichier JSON local.

## Fonctionnalités

- Ajouter une nouvelle tâche (titre, priorité, date limite optionnelle)
- Lister toutes les tâches
- Trier les tâches par priorité
- Trier les tâches par date limite
- Marquer une tâche comme terminée
- Supprimer une tâche
- Persistance des données dans `data/tasks.json`

Priorités disponibles : `low`, `medium`, `high`, ou `urgent` (crée une `UrgentTask` à priorité haute imposée).

## Prérequis

- Dart SDK >= 3.0.0 (`dart --version` pour vérifier l'installation)

## Installation

```bash
git clone https://github.com/darius202/dart_cli_projet.git
cd dart_cli_projet
dart pub get
```

## Lancer l'application

```bash
dart run
```

Un menu interactif s'affiche et propose les actions suivantes :

```
1. Ajouter une tâche
2. Lister les tâches
3. Lister par priorité
4. Lister par date
5. Marquer une tâche terminée
6. Supprimer une tâche
0. Quitter
```

Les données sont automatiquement chargées et sauvegardées dans `data/tasks.json` à chaque modification ; elles sont donc conservées entre deux exécutions de l'application.

## Lancer les tests

```bash
dart test
```

## Qualité de code

```bash
dart analyze
dart format --output=none --set-exit-if-changed .
```

Ces mêmes vérifications, ainsi que la suite de tests, sont exécutées automatiquement par la CI GitHub Actions (`.github/workflows/ci.yml`) à chaque push et pull request sur `main`.

## Architecture

```
lib/
├── cli/                 # Boucle d'interaction en ligne de commande (TaskCLI)
├── enums/               # Enumération Priority
├── exceptions/          # Exceptions personnalisées (TaskException et sous-types)
├── interfaces/          # Contrats (JsonSerializable, RepositoryInterface<T>)
├── models/              # BaseTask (abstraite) -> Task / UrgentTask
├── repositories/        # Persistance JSON polymorphe (TaskRepository)
└── services/            # Logique métier (TaskService)
```

Concepts Dart mis en pratique :

- **Classe abstraite** : `BaseTask` définit le contrat commun à toute tâche (`title`, `priority`, `dueDate`, `completed`, `markAsCompleted()`, `describe()`).
- **Héritage** : `Task` et `UrgentTask` étendent toutes les deux directement `BaseTask`. `UrgentTask` impose `Priority.high` dans son constructeur et redéfinit `describe()` (polymorphisme : `TaskCLI.listTasks` appelle `describe()` sans savoir s'il a affaire à un `Task` ou un `UrgentTask`).
- **Interfaces** : `Task` et `UrgentTask` implémentent chacune explicitement `JsonSerializable` (sérialisation propre à chaque type concret) ; `TaskRepository` implémente `RepositoryInterface<BaseTask>` (persistance générique).
- **Génériques** : `RepositoryInterface<T>` définit un contrat réutilisable pour n'importe quel type sérialisable ; `TaskRepository` l'instancie avec `BaseTask`.
- **Exceptions personnalisées** : hiérarchie `TaskException` → `TaskNotFoundException`, `InvalidIndexException`, `InvalidPriorityException`, `InvalidDateException`. Chaque point de saisie ou de recherche invalide dans `TaskService`/`TaskCLI` lève le sous-type approprié, capturé de façon uniforme par `TaskCLI` (`on TaskException catch (e)`) pour afficher un message clair sans jamais faire planter l'application.
- **Tests unitaires** : modèles (`Task`, `UrgentTask`), service (cas nominaux, tri, cas d'erreur) et persistance réelle du `TaskRepository` sur disque (y compris le typage polymorphe à la relecture).

### Pourquoi ces choix

- **Repository + Service** : `TaskRepository` isole entièrement la lecture/écriture du fichier JSON derrière `RepositoryInterface<BaseTask>`. `TaskService` ne connaît que ce contrat, pas le détail du stockage. Cela permet de tester `TaskService` avec un `FakeRepository` en mémoire (voir `test/task_service_test.dart`) sans toucher au disque, tout en gardant un test dédié pour la vraie persistance (`test/task_repository_test.dart`).
- **`addItems` vs `saveAll`** : le contrat expose deux opérations distinctes et sans ambiguïté — `addItems` *ajoute* les éléments fournis aux données déjà persistées (utilisé par `TaskService.add`), `saveAll` *remplace* l'intégralité du contenu par la liste fournie (utilisé par `complete`/`delete`, qui doivent réécrire l'état complet après une mutation en mémoire).
- **`Task` et `UrgentTask` comme sœurs sous `BaseTask`** : chacune implémente son propre `toJson`/`fromJson` (via un champ `type` discriminant dans le JSON), ce qui permet à `TaskRepository.getAll()` de reconstruire le bon type concret à la lecture — démonstration explicite du polymorphisme plutôt qu'une simple spécialisation en chaîne.

### Limites connues et pistes d'amélioration

- Pas de verrouillage de fichier : deux instances de l'application lancées en parallèle peuvent se marcher dessus lors de l'écriture. Non problématique pour un usage CLI mono-utilisateur, mais à traiter avant un usage concurrent.
- La saisie utilisateur se fait via une boucle `stdin.readLineSync()` maison. Une prochaine itération pourrait s'appuyer sur le package [`args`](https://pub.dev/packages/args) pour supporter des commandes non interactives (`dart run -- add --title ... --priority high`).
- La persistance JSON réécrit le fichier entier à chaque opération ; suffisant ici, mais à revoir (ex. base SQLite) si le volume de tâches devenait important.

## Dépannage

- **`FormatException` au démarrage** : le fichier `data/tasks.json` a été modifié/corrompu manuellement. Supprimez-le (ou videz-le en `[]`) ; il sera recréé automatiquement au prochain lancement.
- **`dart pub get` échoue** : vérifiez que la version du SDK Dart installée satisfait la contrainte `>=3.0.0 <4.0.0` du `pubspec.yaml`.
- **Un index de tâche est refusé avec "Cette tâche n'existe pas"** : listez les tâches (option `2`) pour retrouver l'index courant, la liste change après chaque suppression.
