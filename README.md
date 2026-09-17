# FitTracker

Application mobile de suivi d'entraînement physique — conçue pour remplacer le carnet papier/Excel : bibliothèque de plus de 1300 exercices, programmes personnalisés, séances guidées avec suggestion de charge automatique, chronomètre de repos et historique.

Projet réalisé dans le cadre du **FlutterFire Summer Camp 2026** (Groupe 33).

## Sommaire

- [Équipe](#équipe--groupe-33)
- [Stack technique](#stack-technique)
- [Fonctionnalités](#fonctionnalités)
- [Parcours utilisateur](#parcours-utilisateur)
- [Architecture](#architecture)
- [Modèle de données](#modèle-de-données)
- [Points techniques notables](#points-techniques-notables)
- [Lancer le projet](#lancer-le-projet)
- [État d'avancement](#état-davancement)
- [Limites connues](#limites-connues)

## Équipe — Groupe 33

| Membre | Rôle |
|--------|------|
| KOSSI Desiré Komla — [Just2sire](https://github.com/Just2sire) | Chef de groupe |
| LEMBO Alan Yves Dieudonné — [LEMBO1102](https://github.com/LEMBO1102) | Contributeur |
| ADEYEMI Houzeifa — [Houzeifa622](https://github.com/Houzeifa622) | Contributeur |

## Stack technique

| Domaine | Choix |
|---------|-------|
| Framework | Flutter (Dart SDK ^3.14) |
| State management | Riverpod 3 + `riverpod_generator` (providers `@riverpod` générés au build) |
| Persistance | Drift (SQLite) — 9 tables, DAOs générés |
| Navigation | go_router — `StatefulShellRoute.indexedStack` pour la bottom nav |
| Notifications | flutter_local_notifications + timezone (planification en arrière-plan) |
| Média | video_player (démonstrations d'exercices) |
| Autres | uuid (IDs), shared_preferences (flags de seed), path_provider |

## Fonctionnalités

### Bibliothèque d'exercices
Plus de 1300 exercices seedés au premier lancement, avec recherche en temps réel, filtres cumulables par groupe musculaire et équipement, et fiche détail incluant une vidéo de démonstration en boucle.

### Programmes d'entraînement
Création de programmes multi-jours (nom, objectif), ajout d'exercices par jour avec séries / répétitions cibles / temps de repos, réorganisation par glisser-déposer. Suppression en soft delete — l'historique des séances passées reste intact même après suppression d'un programme.

### Séance active
- Démarrage d'une séance depuis un jour de programme : pré-création automatique des séries à faire, poids pré-rempli par suggestion de charge.
- Machine à états stricte (`active → paused → active`, `active → completed`, `active → abandoned`) avec garde-fous côté repository — toute transition invalide lève une exception explicite.
- Auto-save : chaque série validée est écrite en base immédiatement (pas de buffer), avec heartbeat toutes les 30 secondes pendant qu'une séance est active.
- Reprise automatique après fermeture de l'application (une séance active/en pause est restaurée telle quelle au relancement).
- Gestion des exercices au poids du corps et au gilet lesté (poids = 0 valide, champ masqué pour le poids du corps).

### Chronomètre de repos
Overlay plein écran avec décompte circulaire animé (`CustomPainter`), déclenché automatiquement après chaque série validée. Ajustable en direct (+15s / +30s) sans réinitialiser l'animation. Vibration à T-5s, notification locale programmée qui se déclenche même si l'app est en arrière-plan.

### Historique
Liste des séances terminées (nom du jour, date, durée effective), triée de la plus récente à la plus ancienne, mise à jour en temps réel via un stream réactif sur la base de données.

## Parcours utilisateur

```
Accueil → Programmes → créer un programme (jours + exercices)
                     → ouvrir un programme → "Démarrer la séance"
                                            ↓
                              Séance active (par exercice) :
                              suggestion de charge → saisie série → validation
                                            ↓
                              Repos automatique (chrono + notification)
                                            ↓
                              Exercice suivant … → "Terminer la séance"
                                            ↓
                              Onglet Historique → séance visible
```

## Architecture

Clean Architecture organisée par feature, avec une séparation stricte des responsabilités :

```
lib/
├── core/                    # routing (GoRouter), thème, extensions, utilitaires partagés
│   ├── routing/
│   ├── theme/
│   ├── extensions/
│   └── utils/                # ProgressionEngine, SessionTimerCalculator...
├── shared/
│   ├── data/database/        # Drift : tables, DAOs, AppDatabase
│   ├── domain/enums/         # enums transverses (Equipment, MuscleGroup, SessionStatus...)
│   └── presentation/         # widgets communs (AppScaffold, AppTopbar), providers partagés
└── features/
    ├── exercise_library/
    ├── programs/
    ├── active_session/
    └── home/
```

Chaque feature suit la même structure interne :

```
feature/
├── domain/          # entités pures, contrat de repository (interface), use cases
├── data/            # datasource (appelle les DAOs Drift), implémentation du repository
└── presentation/
    ├── pages/        # écrans — StatelessWidget / ConsumerWidget, pas de logique métier
    ├── providers/     # providers Riverpod (@riverpod), notifiers avec la logique d'état
    └── widgets/       # sections d'écran, chacune en widget dédié (pas de fonctions `_buildX()`)
```

**Règle d'architecture clé** : les features ne s'importent jamais directement entre elles (ni providers, ni widgets). La navigation (GoRouter) sert de médiateur neutre — par exemple `programs` ne connaît pas `active_session`, il navigue simplement vers `/active-session?dayId=...`.

## Modèle de données

9 tables Drift (SQLite), toutes avec IDs en UUID v4 (`TextColumn`, jamais d'auto-increment) :

| Table | Rôle |
|-------|------|
| `exercises` | Catalogue d'exercices (soft delete) |
| `workout_programs` | Programmes d'entraînement (soft delete) |
| `workout_days` | Jours d'un programme (soft delete) |
| `program_exercises` | Exercices prescrits par jour (séries/reps/repos cibles) |
| `workout_sessions` | Séances (statut, timestamps, `pausedDuration`) — seule table à subir un vrai `DELETE` |
| `session_exercises` | Snapshot d'un exercice au moment de la séance (nom, équipement, muscle — figés même si l'exercice original est modifié) |
| `exercise_sets` | Séries individuelles (poids, reps, complétée ou non) |
| `personal_records` | Prévu pour les records personnels (M-09, non exploité) |
| `body_weights` | Prévu pour le suivi de poids corporel (non exploité) |

## Points techniques notables

**Algorithme de suggestion de charge** (`ProgressionEngine`) — analyse les 2 dernières séances sur un exercice :
- Aucun historique → pas de suggestion
- 1 séance → reprend le même poids ("Première référence")
- 2 succès consécutifs (toutes les séries atteignent le max de répétitions cible) → augmente le poids (+1 kg haltères ≤20kg, +2 kg au-delà, +2.5 kg barre haut du corps, +5 kg barre bas du corps)
- 2 échecs consécutifs (aucune série n'atteint le minimum) → réduit le poids de 5 %, arrondi au 0,5 kg le plus proche
- Cas mixte → même poids

**Calcul de durée de séance** (`SessionTimerCalculator`) — jamais de `Stopwatch` : la durée effective se recalcule à partir de `startedAt`, `pausedDuration` et `finishedAt` (ou `lastActiveAt` si en pause, pour figer l'affichage). Un flux Riverpod (`Stream.periodic`) rafraîchit l'affichage chaque seconde uniquement quand la séance est active.

**Réactivité de bout en bout** — les écrans de liste (programmes, historique) s'appuient sur des `Stream` Drift exposés en providers Riverpod : aucune invalidation manuelle après une mutation, l'UI se met à jour automatiquement.

## Lancer le projet

Prérequis : Flutter SDK compatible Dart `^3.14`, un appareil ou émulateur Android/iOS (l'app n'a pas été testée sur le web, Drift y nécessite une configuration WASM séparée).

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

La base de données SQLite est créée et peuplée automatiquement au premier lancement (seed de ~1300 exercices depuis `assets/data/exercises.json`, marqué comme fait via `shared_preferences` pour ne pas se répéter).

## État d'avancement

Le projet a été développé en suivant une feuille de route de 12 modules (`docs/fit_tracker_modules.md`, non versionné — document de planification interne).

| Statut | Modules |
|--------|---------|
| ✅ Terminé | Scaffolding, base de données, seed & assets, bibliothèque d'exercices, programmes, logique de séance, UI de séance active, chronomètre & notifications |
| 🟡 Partiel | Historique des séances — liste simple (nom, date, durée), sans vue calendrier ni détail par séance |
| ❌ Non fait | Résumé de séance & records personnels, statistiques & graphiques, dashboard, profil utilisateur |

## Limites connues

- Aucun test automatisé (`flutter test`) — validation faite manuellement sur appareil Android.
- Pas de récapitulatif après "Terminer la séance" (pas de calcul de volume, pas de détection de record personnel).
- `GetNextWorkoutDayUseCase` (suggestion automatique du prochain jour à faire) non implémenté — l'app démarre toujours le premier jour du programme.
- Pas de conversion d'unités (kg/lbs), pas d'export/import de données.
