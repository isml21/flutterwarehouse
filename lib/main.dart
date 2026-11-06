import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/box_catalog/presentation/box_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase Backend
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: BoxManagementApp(),
    ),
  );
}

class BoxManagementApp extends ConsumerWidget {
  const BoxManagementApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MyWarehouse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}

/// Authentication Gate: Decides whether to show LoginScreen or BoxListScreen
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateStreamProvider);

    return authStateAsync.when(
      data: (authState) {
        final session = authState.session;
        if (session != null) {
          return const BoxListScreen();
        } else {
          return const LoginScreen();
        }
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.accent),
              SizedBox(height: 16),
              Text(
                'Memeriksa status otentikasi...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) {
        // Fallback to checking cached current user
        final currentUser = ref.watch(currentUserProvider);
        if (currentUser != null) {
          return const BoxListScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
