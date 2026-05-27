import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.white,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) {
          final user = profile.user;
          return ListView(
            children: [
              // Header
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (profile.isLoading)
                      const CircularProgressIndicator()
                    else ...[
                      Text(
                        user?.name ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user?.email ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _MenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () => context.push('/profile/edit'),
              ),
              _MenuItem(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: () => AppDialog.comingSoon(context, feature: 'Ganti Password'),
              ),
              _MenuItem(
                icon: Icons.card_travel_rounded,
                title: 'My Bookings',
                onTap: () => context.go('/bookings'),
              ),
              _MenuItem(
                icon: Icons.info_outline_rounded,
                title: 'About App',
                onTap: () => context.push('/profile/about'),
              ),
              const Divider(),
              _MenuItem(
                icon: Icons.logout_rounded,
                title: 'Logout',
                color: AppColors.error,
                onTap: () async {
                  final result = await AppDialog.show(
                    context,
                    type: AppDialogType.confirm,
                    title: 'Keluar Akun',
                    message: 'Apakah Anda yakin ingin keluar dari akun ini?',
                    primaryLabel: 'Ya, Keluar',
                    secondaryLabel: 'Batal',
                  );
                  if (result.confirmed && context.mounted) {
                    await context.read<AuthProvider>().logout();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.white,
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(title,
          style: TextStyle(color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textHint),
      onTap: onTap,
    );
  }
}
