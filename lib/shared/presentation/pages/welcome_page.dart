import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../core/constants/app_assets.dart";
import "../../../core/extensions/build_context_extensions.dart";
import "../../../core/extensions/navigation_extensions.dart";
import "../../../core/theme/app_colors.dart";
import "../../../core/theme/app_spacing.dart";
import "../providers/local_storage_providers.dart";

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storage = ref.read(localStorageServiceProvider);
      if (storage.isOnboardingCompleted && mounted) context.goHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.fitness, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.heroOverlayGradient,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: AppSpacing.insetLg,
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      spacing: AppSpacing.md,
                      children: [
                        Container(
                          padding: AppSpacing.insetMd,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppSpacing.roundedMd,
                          ),
                          child: const Icon(
                            LucideIcons.dumbbell,
                            color: AppColors.onPrimary,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        Text(
                          "FitTracker",
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.paleMint,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: AppSpacing.lg,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Entraîne-toi.\nProgresse.\nRépète.",
                          style: textTheme.displaySmall?.copyWith(
                            color: AppColors.paleMint,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          "Suis tes séances, explore des centaines d'exercices "
                          "et visualise ta progression au fil du temps.",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.paleMint70,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _discoverApp,
                            iconAlignment: .end,
                            icon: const Icon(LucideIcons.arrowRight),
                            label: const Text("Commencer"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _discoverApp() {
    final storage = ref.read(localStorageServiceProvider);
    unawaited(storage.setOnboardingCompleted());
    context.goHome();
  }
}
