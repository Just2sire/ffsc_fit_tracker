# FitTracker — Guide de prise en main

> Ce document est destiné à tous les développeurs qui rejoignent le projet. Lisez-le **intégralement** avant d'écrire la moindre ligne de code.

---

## Table des matières

1. [Architecture du projet](#1-architecture-du-projet)
2. [Installation & lancement](#2-installation--lancement)
3. [Système de design — règles d'or](#3-système-de-design--règles-dor)
4. [Widgets préconfigurés](#4-widgets-préconfigurés)
5. [Navigation & routing](#5-navigation--routing)
6. [State management — Riverpod](#6-state-management--riverpod)
7. [Services partagés](#7-services-partagés)
8. [Extensions disponibles](#8-extensions-disponibles)
9. [Logger](#9-logger)
10. [Code generation](#10-code-generation)
11. [Conventions & règles à respecter](#11-conventions--règles-à-respecter)

---

## 1. Architecture du projet

```
lib/
├── core/
│   ├── configs/        → Logger, configurations globales
│   ├── constants/      → Chemins d'assets, canaux de notification
│   ├── extensions/     → Extensions sur BuildContext, String, Color, etc.
│   ├── routing/        → GoRouter, clés de navigation, transitions, routes
│   └── theme/          → Couleurs, espacements, typographie, ThemeData
├── features/           → Un dossier par feature (home/, exercises/, etc.)
│   └── <feature>/
│       ├── data/       → Repositories, datasources, modèles
│       └── presentation/
│           ├── pages/
│           ├── providers/
│           └── widgets/
└── shared/
    ├── data/services/  → Services réutilisables (DB, storage, notifications)
    └── presentation/
        ├── providers/  → Providers Riverpod partagés
        └── widgets/    → Widgets réutilisables (AppScaffold, AppTopBar…)
```

**Chaque feature est autonome.** Ne pas faire d'import croisé entre features — passer par `shared/` si quelque chose doit être partagé.

---

## 2. Installation & lancement

```bash
# 1. Récupérer les dépendances
flutter pub get

# 2. Générer le code (Riverpod + Drift)
dart run build_runner build --delete-conflicting-outputs

# 3. Lancer l'app
flutter run
```

> Après tout ajout d'une annotation `@riverpod` ou d'une table Drift, relancer la génération de code.

---

## 3. Système de design — règles d'or

### 3.1 Couleurs — ne jamais utiliser directement `AppColors`

`AppColors` contient la palette brute. Elle **n'est pas utilisée directement** dans les widgets. Toujours passer par le `ColorScheme` Material ou le `BuildContext`.

```dart
// ✅ Correct
final color = context.colorScheme.primary;
final bg    = context.colorScheme.surface;
final error = context.colorScheme.error;

// ✅ Correct aussi (via Theme)
final color = Theme.of(context).colorScheme.secondary;

// ❌ Interdit — couplage direct à la palette brute
final color = AppColors.primary;
```

**Correspondances importantes du ColorScheme :**

| Besoin | ColorScheme key |
|---|---|
| Couleur principale (lime) | `primary` |
| Texte sur couleur principale | `onPrimary` |
| Fond de page | `surface` |
| Fond de carte | `surfaceContainerLow` |
| Texte principal | `onSurface` |
| Texte secondaire | `onSurfaceVariant` |
| Erreur | `error` |
| Contour/Divider | `outlineVariant` |

### 3.2 Typographie — passer par `TextTheme`

```dart
// ✅ Correct
Text('Titre', style: context.textTheme.headlineMedium)
Text('Corps', style: context.textTheme.bodyLarge)

// ❌ Interdit — style codé en dur
Text('Titre', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
```

**Référence de la hiérarchie typographique :**

| Style | Usage |
|---|---|
| `displayLarge/Medium/Small` | Chiffres hero, très grandes accroches |
| `headlineLarge/Medium/Small` | Titres de page, sections |
| `titleLarge/Medium/Small` | Titres de carte, sous-sections |
| `bodyLarge/Medium/Small` | Texte courant, descriptions |
| `labelLarge/Medium/Small` | Boutons, chips, labels de formulaire |

### 3.3 Espacements — utiliser `AppSpacing`

Tous les espacements sont définis sur une grille de **4 px**. Ne jamais écrire de valeur magique.

```dart
// ✅ Correct
Padding(padding: AppSpacing.allMd)           // 12px partout
SizedBox(height: AppSpacing.gapVLg)          // gap vertical 16px
SizedBox(width: AppSpacing.gapHSm)           // gap horizontal 8px
Container(padding: AppSpacing.cardPadding)   // padding standard de carte
BorderRadius.circular(AppSpacing.radiusLg)  // 12px

// ❌ Interdit
Padding(padding: EdgeInsets.all(14))
SizedBox(height: 20)
```

**Tokens d'espacement clés :**

| Token | Valeur | Usage typique |
|---|---|---|
| `AppSpacing.xs` | 4 px | Micro-espaces |
| `AppSpacing.sm` | 8 px | Espaces internes serrés |
| `AppSpacing.md` | 12 px | Espaces internes standard |
| `AppSpacing.lg` | 16 px | Marges entre éléments |
| `AppSpacing.xl` | 20 px | Espaces confortables |
| `AppSpacing.xxl` | 24 px | Sections |
| `AppSpacing.xxxl` | 32 px | Grandes sections |
| `AppSpacing.screenPadding` | — | Padding latéral d'écran |
| `AppSpacing.cardPadding` | — | Padding interne de carte |
| `AppSpacing.buttonPadding` | — | Padding interne de bouton |

**Gaps prêts à l'emploi :**

```dart
AppSpacing.gapVXs   // SizedBox(height: 4)
AppSpacing.gapVSm   // SizedBox(height: 8)
AppSpacing.gapVMd   // SizedBox(height: 12)
AppSpacing.gapVLg   // SizedBox(height: 16)
AppSpacing.gapVXl   // SizedBox(height: 20)
AppSpacing.gapVXxl  // SizedBox(height: 24)

AppSpacing.gapHSm   // SizedBox(width: 8)
AppSpacing.gapHMd   // SizedBox(width: 12)
AppSpacing.gapHLg   // SizedBox(width: 16)
```

### 3.4 Mode sombre — ne pas hardcoder les couleurs

Le thème gère automatiquement light/dark. Utilisez toujours le `ColorScheme` — les bonnes couleurs sont appliquées selon le mode.

```dart
// Vérifier le mode courant si besoin
final isDark = context.isDarkMode;
```

---

## 4. Widgets préconfigurés

### 4.1 `AppScaffold` — écran de base

**Toujours utiliser `AppScaffold` à la place de `Scaffold` nu.**

```dart
import 'package:fit_tracker/shared/presentation/widgets/app_scaffold.dart';

// Écran simple
AppScaffold(
  body: MyPageContent(),
)

// Écran avec AppBar
AppScaffold(
  appBar: AppTopBar(title: 'Profil'),
  body: MyContent(),
)

// Écran scrollable
AppScaffold(
  scrollable: true,
  body: Column(children: [...]),
)

// Écran avec pull-to-refresh (implique scrollable)
AppScaffold(
  onRefresh: () async { /* reload data */ },
  body: MyList(),
)

// Contrôle du padding (par défaut: AppSpacing.screenPadding)
AppScaffold(
  padding: EdgeInsets.zero,  // utile pour les listes plein-écran
  body: MyListView(),
)

// Écran avec bottom nav (le contenu passe derrière)
AppScaffold(
  extendBody: true,
  bottomSafeArea: false,
  body: MyContent(),
)

// Avec FAB
AppScaffold(
  floatingActionButton: FloatingActionButton(onPressed: _add, child: Icon(Icons.add)),
  body: MyContent(),
)

// Avec fond décoratif
AppScaffold(
  backgroundBuilder: (child) => Stack(children: [MyBackground(), child]),
  body: MyContent(),
)

// Bloquer le retour arrière
AppScaffold(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) { /* gérer */ },
  body: MyContent(),
)
```

**Paramètres importants :**

| Paramètre | Défaut | Description |
|---|---|---|
| `padding` | `AppSpacing.screenPadding` | Padding interne du body |
| `scrollable` | `false` | Rend le body scrollable |
| `onRefresh` | `null` | Active pull-to-refresh (implique scrollable) |
| `bottomSafeArea` | `true` | Ajoute la SafeArea en bas |
| `extendBody` | `false` | Le body passe derrière la bottom nav |
| `resizeToAvoidBottomInset` | `false` | Rétrécit quand le clavier apparaît |
| `statusBarColor` | scaffold bg | Couleur derrière la status bar |

---

### 4.2 `AppTopBar` — barre de titre

```dart
import 'package:fit_tracker/shared/presentation/widgets/app_topbar.dart';

// Simple
AppTopBar(title: 'Mes exercices')

// Avec sous-titre
AppTopBar(
  title: 'Historique',
  subtitle: 'Vos 30 derniers jours',
)

// Avec bouton retour automatique
AppTopBar(
  title: 'Détail',
  showLeading: true,  // pop automatique au tap
)

// Avec actions
AppTopBar(
  title: 'Profil',
  actions: [
    IconButton(icon: Icon(Icons.settings), onPressed: _openSettings),
  ],
)

// Titre centré
AppTopBar(
  title: 'FitTracker',
  centerTitle: true,
)
```

---

### 4.3 `AppTextFormField` — champ de formulaire

```dart
import 'package:fit_tracker/shared/presentation/widgets/app_text_form_field.dart';

// Champ basique
AppTextFormField(
  label: 'Email',
  hint: 'nom@exemple.com',
  keyboardType: TextInputType.emailAddress,
)

// Champ mot de passe
AppTextFormField(
  label: 'Mot de passe',
  obscureText: true,
  suffixIcon: Icon(Icons.visibility),
  onSuffixTap: _toggleVisibility,
)

// Avec validation
AppTextFormField(
  label: 'Prénom',
  required: true,
  validator: (v) => v!.isBlank ? 'Requis' : null,
)

// Champ désactivé
AppTextFormField(
  label: 'Email',
  enabled: false,
  text: user.email,
)
```

---

### 4.4 `AppDivider` — séparateur

```dart
import 'package:fit_tracker/shared/presentation/widgets/app_divider.dart';

// Séparateur simple
AppDivider()

// Avec label centré
AppDivider(label: 'ou')

// Avec widget custom
AppDivider(child: Icon(Icons.fitness_center))

// Personnalisé
AppDivider(
  color: context.colorScheme.outlineVariant,
  thickness: AppSpacing.borderBase,
  textPosition: 30,  // le label est à 30% depuis la gauche
)
```

---

## 5. Navigation & routing

### 5.1 Extensions de navigation — toujours les utiliser

Ne jamais construire les routes manuellement. Les extensions de `BuildContext` exposent des méthodes prêtes à l'emploi.

```dart
// Aller vers une route nommée
context.goHome()
context.goExercises()
context.goHistory()
context.goProfile()
context.goOnboarding()
context.goRoot()

// Retour
context.popScreen()         // pop simple
context.popScreen('result') // pop avec résultat typé

// Navigation avec résultat attendu
final result = await context.pushWithResult<bool>('/some-route');

// Aller vers une route en vidant la pile
context.goAndClearStack('/home');
```

### 5.2 Ajouter une route

1. Ajouter le chemin dans `lib/core/routing/app_routes.dart` :

```dart
static const String myNewScreen = '/my-new-screen';
```

2. Ajouter la route dans `lib/core/routing/app_router.dart` :

```dart
GoRoute(
  path: AppRoutes.myNewScreen,
  pageBuilder: (context, state) => AppTransitions.pushedScreen(
    state: state,
    child: const MyNewScreen(),
  ),
),
```

3. Ajouter la méthode d'extension dans `lib/core/extensions/navigation_extensions.dart` :

```dart
void goMyNewScreen(BuildContext context) =>
    GoRouter.of(this).go(AppRoutes.myNewScreen);
```

### 5.3 Transitions disponibles

```dart
AppTransitions.fade(state: state, child: widget)
AppTransitions.slide(state: state, child: widget)
AppTransitions.fadeSlide(state: state, child: widget)
AppTransitions.pushedScreen(state: state, child: widget)  // ← pour les détails
AppTransitions.scale(state: state, child: widget)
AppTransitions.none(state: state, child: widget)
```

**Convention :**
- Tabs du shell → `fade`
- Écrans de détail → `pushedScreen`
- Dialogs custom → `fadeScale`

### 5.4 Navigation depuis l'extérieur du widget tree

Pour naviguer depuis un handler de notification ou un callback background, utiliser la clé globale :

```dart
import 'package:fit_tracker/core/routing/app_navigator_key.dart';

AppNavigatorKey.key.currentContext?.goHome();
```

---

## 6. State management — Riverpod

### 6.1 Règles de base

- Toujours utiliser l'annotation `@riverpod` et laisser `build_runner` générer le code.
- Passer `ref` via le constructeur, jamais en global.
- Les providers `keepAlive` sont pour les services qui vivent toute la session (DB, storage, notifications).
- Les providers de feature sont éphémères par défaut.

### 6.2 Providers partagés disponibles

```dart
// Accès au stockage local
final prefs = ref.watch(sharedPreferencesProvider);
final storage = ref.watch(localStorageServiceProvider);

// Base de données
final db = ref.watch(appDatabaseProvider);
final dbService = ref.watch(databaseServiceProvider);

// Notifications
final notifications = ref.watch(notificationServiceProvider);

// Thème
final themeMode = ref.watch(appThemeModeProvider);
ref.read(appThemeModeProvider.notifier).toggleTheme();
```

### 6.3 Créer un provider dans une feature

```dart
// features/exercises/presentation/providers/exercises_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercises_provider.g.dart';

@riverpod
class ExercisesList extends _$ExercisesList {
  @override
  Future<List<Exercise>> build() async {
    final db = ref.watch(appDatabaseProvider);
    return db.getAllExercises();
  }

  Future<void> refresh() => ref.refresh(exercisesListProvider.future);
}
```

Puis lancer `dart run build_runner build --delete-conflicting-outputs`.

---

## 7. Services partagés

### 7.1 `LocalStorageService` — préférences utilisateur

```dart
final storage = ref.watch(localStorageServiceProvider);

// Lecture
final isDone = await storage.isOnboardingCompleted;
final theme  = await storage.themeMode;       // 'light' | 'dark' | 'system'
final weight = await storage.weightUnit;      // 'kg' | 'lbs'

// Écriture
await storage.setOnboardingCompleted(true);
await storage.setThemeMode('dark');
await storage.setWeightUnit('kg');

// Générique
await storage.write<String>(StorageKeys.themeMode, 'dark');
final val = await storage.read<String>(StorageKeys.themeMode);
```

### 7.2 `NotificationService` — notifications locales

```dart
final notif = ref.watch(notificationServiceProvider);

// Demander la permission (à faire au premier lancement)
final granted = await notif.requestPermission();

// Notification immédiate
await notif.show(
  id: NotificationIds.welcome,
  title: 'Bienvenue !',
  body: 'Votre séance vous attend.',
  channel: NotificationChannels.general,
);

// Notification planifiée
await notif.schedule(
  id: NotificationIds.reminder(1),
  title: 'Rappel séance',
  body: 'Il est temps de s\'entraîner.',
  scheduledDate: DateTime.now().add(Duration(hours: 1)),
  channel: NotificationChannels.reminders,
);

// Annuler
await notif.cancel(id);
await notif.cancelAll();
```

**Canaux disponibles :**

| Constante | Importance | Usage |
|---|---|---|
| `NotificationChannels.general` | Default | Info générales |
| `NotificationChannels.reminders` | High | Rappels de séance |
| `NotificationChannels.alerts` | Max | Alertes critiques |

### 7.3 `DatabaseService` — base de données Drift

```dart
final dbService = ref.watch(databaseServiceProvider);

// Transaction atomique
await dbService.transaction(() async {
  await db.insertExercise(exercise);
  await db.insertSet(set);
});

// Vérifier la santé de la DB
final isOk = await dbService.checkHealth();

// Info schema (debug)
final info = await dbService.getDatabaseInfo();
Log.d(info.toString());
```

**Ajouter une table Drift :**

1. Définir la table dans `lib/shared/data/services/app_database.dart`
2. Ajouter la table à `@DriftDatabase(tables: [...])`
3. Relancer `build_runner`

---

## 8. Extensions disponibles

### 8.1 `BuildContext` extensions

```dart
// Thème
context.theme            // ThemeData
context.colorScheme      // ColorScheme
context.textTheme        // TextTheme
context.isDarkMode       // bool
context.scaffoldBackgroundColor

// Dimensions
context.screenSize       // Size
context.screenWidth      // double
context.screenHeight     // double
context.isMobile         // bool (< 600)
context.isTablet         // bool (600-1024)
context.isDesktop        // bool (> 1024)
context.isPortrait
context.isLandscape

// SafeArea
context.padding          // EdgeInsets (insets système)
context.viewInsets       // (clavier, etc.)

// Navigation
context.pop()
context.canPop           // bool

// Feedback
context.showSnackBar('Message')
context.showError('Erreur !')
context.showSuccess('Succès !')
context.showInfo('Info')
await context.showConfirmDialog(title: 'Supprimer ?', message: 'Irréversible')
await context.showInfoDialog(title: 'Info', message: '...')
```

### 8.2 `String` extensions

```dart
// Validation
'test@mail.com'.isEmail    // true
'http://...'.isUrl         // true
'0612'.isPhone             // true
'123'.isNumeric            // true
'abc'.isAlphabetic         // true
''.isBlank                 // true
'hello'.isNotBlank         // true

// Transformation
'hello world'.capitalize          // 'Hello world'
'hello world'.capitalizeWords     // 'Hello World'
'hello world'.camelCase           // 'helloWorld'
'helloWorld'.snakeCase            // 'hello_world'
'hello world'.kebabCase           // 'hello-world'

// Troncature
'Long text'.truncate(5)           // 'Long...'
'Long text'.truncateWords(1)      // 'Long...'

// Masquage
'test@mail.com'.maskEmail()       // 'te**@mail.com'
'0612345678'.maskPhone()          // '06****5678'

// Parsing
'42'.toInt()                      // 42
'3.14'.toDouble()                 // 3.14
'2024-01-01'.toDateTime()         // DateTime

// Encodage
'hello'.toBase64()
'aGVsbG8='.fromBase64()
'#D7FC00'.toColor()               // Color
```

### 8.3 `Responsive` extensions

```dart
// Taille selon le device
context.responsiveSize(mobile: 16, tablet: 18, desktop: 20)

// Padding responsive
context.responsivePadding    // EdgeInsets adaptatif

// Colonnes de grille
context.gridColumns          // 1 mobile | 2 tablet | 4 desktop

// Hauteur de list item
context.listItemHeight       // 56 mobile | 64 tablet | 72 desktop

// Padding clavier
context.keyboardPadding      // EdgeInsets.only(bottom: viewInsets.bottom)
```

### 8.4 `Color` extension

```dart
AppColors.primary.addOpacity(0.5)  // Color avec 50% d'opacité
```

---

## 9. Logger

Toujours utiliser `Log` (alias de `AppLogger`) — ne jamais utiliser `print()`.

```dart
import 'package:fit_tracker/core/configs/logger.dart';

// Niveaux de base
Log.d('Debug message')
Log.i('Info message')
Log.w('Warning message')
Log.e('Error message')
Log.s('Success message')

// Types spécialisés
Log.json(myMap)                          // Affiche un JSON formaté
Log.list(['item1', 'item2'])             // Affiche une liste
Log.method('fetchExercises', params: {'id': 1})
Log.route('/exercises/1', method: 'PUSH')
Log.request('GET', 'https://api.example.com/exercises')
Log.response(200, body: responseBody)

// Performance
Log.startTimer('fetchData')
// ... code à mesurer ...
Log.stopTimer('fetchData')

// Section de debug
Log.section('INITIALISATION')
```

---

## 10. Code generation

Le projet utilise la génération de code pour **Riverpod** et **Drift**.

```bash
# Génération unique
dart run build_runner build --delete-conflicting-outputs

# Mode watch (en dev, génère à chaque sauvegarde)
dart run build_runner watch --delete-conflicting-outputs
```

**Fichiers générés (ne jamais éditer manuellement) :**
- `*.g.dart` — tous les fichiers `g.dart`

**Quand relancer :**
- Après avoir ajouté/modifié une annotation `@riverpod`
- Après avoir ajouté/modifié une table ou requête Drift
- Après un `flutter pub get` qui change une dépendance codegen

---

## 11. Conventions & règles à respecter

### Structure des features

Chaque feature suit la même structure :

```
features/
└── <feature_name>/
    ├── data/
    │   ├── datasources/      → API calls, DB queries
    │   ├── models/           → DTOs, entités Drift
    │   └── repositories/     → Abstraction des datasources
    └── presentation/
        ├── pages/            → Écrans (un fichier par écran)
        ├── providers/        → Providers Riverpod de la feature
        └── widgets/          → Widgets propres à cette feature
```

### Règles générales

| Règle | Raison |
|---|---|
| `AppScaffold` au lieu de `Scaffold` | Gestion système UI, SafeArea, padding homogène |
| `context.colorScheme.*` au lieu de `AppColors.*` | Respect du thème light/dark |
| `AppSpacing.*` au lieu de valeurs en dur | Cohérence de la grille 4px |
| `context.textTheme.*` au lieu de `TextStyle()` custom | Cohérence typographique |
| Extensions de navigation au lieu de `GoRouter.of(context).go(...)` | Centralisation, pas de strings en dur |
| `Log.*` au lieu de `print()` | Logs filtrables par niveau, formatés |
| Annoter avec `@riverpod` + `build_runner` | Pas de providers manuels |
| Pas d'import croisé entre features | Isolation des modules |

### Checklist avant de soumettre une PR

- [ ] Aucun `print()` dans le code
- [ ] Aucun `Scaffold` nu (utiliser `AppScaffold`)
- [ ] Aucune couleur en dur (`Color(0xFF...)` ou `AppColors.*` dans les widgets)
- [ ] Aucune valeur d'espacement en dur (`SizedBox(height: 16)` → `AppSpacing.gapVLg`)
- [ ] Les fichiers `*.g.dart` sont à jour (`build_runner` lancé)
- [ ] Les routes passent par les extensions de navigation
- [ ] Les logs utilisent `Log.*`

---

*Dernière mise à jour : septembre 2026*
