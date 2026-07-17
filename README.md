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

Priorités disponibles : `low`, `medium`, `high`.

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
├── exceptions/          # Exceptions personnalisées (TaskException)
├── interfaces/          # Contrats (JsonSerializable, RepositoryInterface<T>)
├── models/              # BaseTask (abstraite) -> Task -> UrgentTask
├── repositories/        # Persistance JSON (TaskRepository)
└── services/            # Logique métier (TaskService)
```

Concepts Dart mis en pratique :

- **Classe abstraite** : `BaseTask` définit le contrat commun à toute tâche.
- **Héritage** : `Task` étend `BaseTask`, `UrgentTask` étend `Task` (priorité haute imposée).
- **Interfaces** : `JsonSerializable` (sérialisation) et `RepositoryInterface<T>` (persistance générique).
- **Génériques** : `RepositoryInterface<T>` / `TaskRepository implements RepositoryInterface<Task>`.
- **Exceptions personnalisées** : `TaskException`, levée par `TaskService` et interceptée par `TaskCLI` pour afficher un message clair sans faire planter l'application.
- **Tests unitaires** : modèles, service (cas nominaux et cas d'erreur) et persistance réelle du `TaskRepository` sur disque.
