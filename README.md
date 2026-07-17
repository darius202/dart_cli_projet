# Task Manager CLI

Application de gestion de tâches en Dart.

## Installation

dart pub get

## Lancer

dart run

## Lancer les tests

dart test

## Fonctionnalités

- Ajouter une tâche
- Lister les tâches
- Trier par priorité
- Trier par date
- Marquer comme terminée
- Supprimer
- Persistance JSON

## Architecture

- Classes abstraites
- Héritage
- Interface
- Génériques
- Exceptions personnalisées
- Tests unitaires


# Task Manager CLI

## Description

**Task Manager CLI** est une application de gestion de tâches développée en **Dart pur (sans Flutter)**.

L'objectif de ce projet est de mettre en pratique les concepts fondamentaux du langage Dart, notamment la programmation orientée objet, les classes abstraites, l'héritage, les interfaces, les génériques, la gestion des exceptions et les tests unitaires.

L'application fonctionne entièrement en ligne de commande (CLI) et permet à un utilisateur de gérer ses tâches avec une sauvegarde persistante des données dans un fichier JSON local.

---

# Fonctionnalités

L'application propose les fonctionnalités suivantes :

## Gestion des tâches

- Ajouter une nouvelle tâche
- Afficher la liste des tâches
- Trier les tâches par priorité
- Trier les tâches par date limite
- Marquer une tâche comme terminée
- Supprimer une tâche

Lors de la création d'une tâche, l'utilisateur peut définir :

- Un titre
- Une priorité :
  - `low`
  - `medium`
  - `high`
- Une date limite optionnelle

---

# Technologies utilisées

- **Dart**
- **Dart CLI**
- **Package test** pour les tests unitaires
- **JSON** pour la persistance des données

---

# Prérequis

Avant d'utiliser l'application, il faut installer :

- Dart SDK version 3.x ou supérieure

Vérifier que Dart est correctement installé :

```bash
dart --version

git clone https://github.com/darius202/dart_cli_projet.git
