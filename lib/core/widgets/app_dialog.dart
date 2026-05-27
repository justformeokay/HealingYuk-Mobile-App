import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

/// Jenis dialog yang menentukan ikon, warna, dan tombol yang ditampilkan.
enum AppDialogType {
  /// Informasi umum — tombol "OK"
  info,

  /// Peringatan — tombol "OK"
  warning,

  /// Sukses — tombol "OK"
  success,

  /// Persetujuan — tombol "Setuju" saja
  agreement,

  /// Konfirmasi Ya/Tidak — dua tombol
  confirm,

  /// Input teks — satu field + tombol Kirim/Batal
  field,
}

// ─────────────────────────────────────────────────────────────────────────────
// Result
// ─────────────────────────────────────────────────────────────────────────────

class AppDialogResult {
  /// `true` jika user menekan tombol utama (OK / Ya / Setuju / Kirim)
  final bool confirmed;

  /// Isi field teks, hanya terisi pada [AppDialogType.field]
  final String? fieldValue;

  const AppDialogResult({required this.confirmed, this.fieldValue});
}

// ─────────────────────────────────────────────────────────────────────────────
// AppDialog — static helper
// ─────────────────────────────────────────────────────────────────────────────

class AppDialog {
  AppDialog._();

  /// Tampilkan dialog dan kembalikan [AppDialogResult].
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// final result = await AppDialog.show(
  ///   context,
  ///   type: AppDialogType.confirm,
  ///   title: 'Hapus Data',
  ///   message: 'Apakah Anda yakin ingin menghapus data ini?',
  /// );
  /// if (result.confirmed) { ... }
  /// ```
  static Future<AppDialogResult> show(
    BuildContext context, {
    required AppDialogType type,
    required String title,
    required String message,
    String? primaryLabel,
    String? secondaryLabel,
    String? fieldHint,
    String? fieldInitialValue,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<AppDialogResult>(
      context: context,
      barrierDismissible: barrierDismissible &&
          type != AppDialogType.agreement,
      barrierColor: Colors.black54,
      builder: (dialogCtx) => _AppDialogWidget(
        type: type,
        title: title,
        message: message,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
        fieldHint: fieldHint,
        fieldInitialValue: fieldInitialValue,
      ),
    );
    return result ?? const AppDialogResult(confirmed: false);
  }

  /// Shortcut — dialog "Fitur dalam pengembangan"
  static Future<void> comingSoon(BuildContext context, {String? feature}) {
    return show(
      context,
      type: AppDialogType.info,
      title: 'Segera Hadir',
      message: feature != null
          ? 'Fitur "$feature" sedang dalam pengembangan.\nNantikan update berikutnya!'
          : 'Fitur ini sedang dalam pengembangan.\nNantikan update berikutnya!',
      primaryLabel: 'Oke, Siap!',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal Widget
// ─────────────────────────────────────────────────────────────────────────────

class _AppDialogWidget extends StatefulWidget {
  final AppDialogType type;
  final String title;
  final String message;
  final String? primaryLabel;
  final String? secondaryLabel;
  final String? fieldHint;
  final String? fieldInitialValue;

  const _AppDialogWidget({
    required this.type,
    required this.title,
    required this.message,
    this.primaryLabel,
    this.secondaryLabel,
    this.fieldHint,
    this.fieldInitialValue,
  });

  @override
  State<_AppDialogWidget> createState() => _AppDialogWidgetState();
}

class _AppDialogWidgetState extends State<_AppDialogWidget>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _fieldCtrl;
  late final AnimationController _animCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _fieldCtrl =
        TextEditingController(text: widget.fieldInitialValue ?? '');
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeOutBack,
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _fieldCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Style helpers ──────────────────────────────────────────────────────────

  _DialogStyle get _style => switch (widget.type) {
        AppDialogType.info => const _DialogStyle(
            icon: Icons.info_rounded,
            iconColor: AppColors.info,
            bgColor: Color(0xFFE8F7FA),
          ),
        AppDialogType.warning => const _DialogStyle(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.warning,
            bgColor: Color(0xFFFFF8E1),
          ),
        AppDialogType.success => const _DialogStyle(
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.success,
            bgColor: Color(0xFFE8F5E9),
          ),
        AppDialogType.agreement => const _DialogStyle(
            icon: Icons.handshake_rounded,
            iconColor: AppColors.primary,
            bgColor: AppColors.surfaceVariant,
          ),
        AppDialogType.confirm => const _DialogStyle(
            icon: Icons.help_rounded,
            iconColor: AppColors.secondary,
            bgColor: Color(0xFFFFF3EE),
          ),
        AppDialogType.field => const _DialogStyle(
            icon: Icons.edit_rounded,
            iconColor: AppColors.primary,
            bgColor: AppColors.surfaceVariant,
          ),
      };

  String get _primaryLabel {
    if (widget.primaryLabel != null) return widget.primaryLabel!;
    return switch (widget.type) {
      AppDialogType.confirm => 'Ya',
      AppDialogType.agreement => 'Setuju',
      AppDialogType.field => 'Kirim',
      _ => 'OK',
    };
  }

  String get _secondaryLabel {
    if (widget.secondaryLabel != null) return widget.secondaryLabel!;
    return switch (widget.type) {
      AppDialogType.confirm => 'Tidak',
      AppDialogType.field => 'Batal',
      _ => 'Tutup',
    };
  }

  bool get _hasSecondaryButton =>
      widget.type == AppDialogType.confirm ||
      widget.type == AppDialogType.field;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _style;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon badge
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: style.bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  style.icon,
                  color: style.iconColor,
                  size: 36,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Message
              Text(
                widget.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              // Field input
              if (widget.type == AppDialogType.field) ...[
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _fieldCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: widget.fieldHint ?? 'Masukkan teks...',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Buttons
              _hasSecondaryButton
                  ? Row(
                      children: [
                        Expanded(child: _secondaryButton(context)),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                            child: _primaryButton(context, style)),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: _primaryButton(context, style),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(BuildContext context, _DialogStyle style) {
    return FilledButton(
      onPressed: () => Navigator.of(context).pop(
        AppDialogResult(
          confirmed: true,
          fieldValue: widget.type == AppDialogType.field
              ? _fieldCtrl.text.trim()
              : null,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: style.iconColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: Text(_primaryLabel,
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _secondaryButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context)
          .pop(const AppDialogResult(confirmed: false)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: Text(_secondaryLabel,
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal data class
// ─────────────────────────────────────────────────────────────────────────────

class _DialogStyle {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _DialogStyle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}
