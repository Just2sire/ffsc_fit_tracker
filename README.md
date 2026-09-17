# FitTracker

Application mobile de suivi d'entraînement physique — conçue pour remplacer le carnet papier/Excel : programmes personnalisés, séances guidées avec suggestion de charge automatique, chronomètre de repos et historique.

Projet réalisé dans le cadre du **FlutterFire Summer Camp 2026** (Groupe 33).

## Équipe — Groupe 33

| Membre | Rôle |
|--------|------|
| KOSSI Desiré Komla — [Just2sire](https://github.com/Just2sire) | Chef de groupe |
| LEMBO Alan Yves Dieudonné — [LEMBO1102](https://github.com/LEMBO1102) | Contributeur |
| ADEYEMI Houzeifa — [Houzeifa622](https://github.com/Houzeifa622) | Contributeur |

## Stack technique

- **Flutter** / Dart
- **Riverpod** (`riverpod_generator`, codegen `@riverpod`) — state management
- **Drift** (SQLite) — persistance locale
- **go_router** — navigation déclarative
- **flutter_local_notifications** — notifications locales (fin de repos)
- **video_player** — démonstrations vidéo des exercices

## Fonctionnalités

- **Bibliothèque d'exercices** — recherche, filtres par groupe musculaire et équipement, fiche détail avec vidéo de démonstration
- **Programmes d'entraînement** — création de programmes multi-jours, éditeur d'exercices avec séries/répétitions/repos, réorganisation par glisser-déposer
- **Séance active** — machine à états (active / pause / terminée / abandonnée), reprise automatique après fermeture de l'app, suggestion de charge basée sur l'historique des performances (algorithme de progression SUCCESS/PARTIAL/FAILURE)
- **Chronomètre de repos** — décompte circulaire animé, ajustable (+15s/+30s), notification locale même en arrière-plan
- **Historique** — liste des séances terminées (nom du jour, date, durée)

## Architecture

Clean Architecture organisée par feature :

```
lib/
├── core/          # routing, thème, extensions, utilitaires partagés
├── shared/        # base de données Drift, widgets communs, services
└── features/
    ├── exercise_library/
    ├── programs/
    ├── active_session/
    └── home/
```

Chaque feature suit la même structure interne : `domain` (entités, contrats, use cases) → `data` (datasources, implémentations de repository) → `presentation` (pages, providers Riverpod, widgets). Les features ne s'importent jamais directement entre elles — la navigation (GoRouter) sert de médiateur neutre.

## Lancer le projet

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

La base de données SQLite est créée et peuplée automatiquement au premier lancement (seed des exercices depuis `assets/data/exercises.json`).

## État d'avancement

Le projet a été développé en suivant une feuille de route de 12 modules (voir `docs/fit_tracker_modules.md`, non versionné). À la clôture du bootcamp :

- ✅ Scaffolding, base de données, seed, bibliothèque d'exercices, programmes, logique de séance, UI de séance active, chronomètre & notifications
- 🟡 Historique des séances — version minimale (liste simple, sans vue calendrier ni détail par séance)
- ❌ Résumé de séance & records personnels, statistiques, dashboard, profil — non implémentés faute de temps

## Tests

Aucun test automatisé pour l'instant — validation faite manuellement sur appareil Android.
