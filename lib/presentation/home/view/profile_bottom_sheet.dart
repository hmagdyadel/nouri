import 'dart:async';

import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/data/repositories/auth_repository.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/locale/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  final FirebaseRemoteSource _remote = getIt<FirebaseRemoteSource>();
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _church = TextEditingController();
  final TextEditingController _city = TextEditingController();
  Timer? _debounce;
  bool _checking = false;
  bool? _available;
  String? _usernameError;
  bool _authLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final Map<String, dynamic> profile = await _remote.getCurrentProfile();
    if (!mounted) return;
    _name.text = (profile['name'] as String?) ?? '';
    _username.text = (profile['username'] as String?) ?? '';
    _church.text = (profile['churchName'] as String?) ?? '';
    _city.text = (profile['city'] as String?) ?? '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _username.dispose();
    _church.dispose();
    _city.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final String normalized = value.trim().toLowerCase();
      final RegExp regex = RegExp(r'^[a-z0-9_]{3,20}$');
      if (!regex.hasMatch(normalized)) {
        if (!mounted) return;
        setState(() {
          _available = null;
          _checking = false;
          _usernameError = AppLocalizations.of(context)!.username_invalid;
        });
        return;
      }
      setState(() {
        _checking = true;
        _usernameError = null;
      });
      final bool ok = await _remote.isUsernameAvailable(normalized);
      if (!mounted) return;
      setState(() {
        _checking = false;
        _available = ok;
        _usernameError = ok ? null : AppLocalizations.of(context)!.username_taken;
      });
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _remote.saveProfile(
        displayName: _name.text.trim(),
        username: _username.text.trim().toLowerCase(),
        church: _church.text.trim(),
        city: _city.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaveSuccess)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaveError)));
    }
  }

  Future<void> _signInGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _authLoading = true);
    final result = await _authRepository.signInWithGoogle();
    if (!mounted) return;
    setState(() => _authLoading = false);
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.migrate_logs_success))),
    );
    setState(() {});
  }

  Future<void> _signInApple() async {
    setState(() => _authLoading = true);
    final result = await _authRepository.signInWithApple();
    if (!mounted) return;
    setState(() => _authLoading = false);
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.migrate_logs_success))),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool signedIn = _authRepository.isSignedIn;
    final bool isArabic = context.watch<LocaleCubit>().state.locale.languageCode == 'ar';

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.52,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Column(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryGoldDark, width: 3),
                      ),
                      child: const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 36)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primaryGoldDark,
                        child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _field(l10n.display_name_hint, _name, Icons.person_outline),
                _field(
                  l10n.username_hint,
                  _username,
                  Icons.alternate_email_rounded,
                  onChanged: _onUsernameChanged,
                  suffix: _checking
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : (_available == true
                          ? const Icon(Icons.check, color: AppColors.sageGreen)
                          : (_usernameError != null ? const Icon(Icons.close, color: AppColors.copticRed) : null)),
                  errorText: _usernameError,
                ),
                _field(l10n.church_hint, _church, Icons.church_rounded),
                _field(l10n.city_hint, _city, Icons.location_on_outlined),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'اللغة / Language',
                        style: const TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    _langPill('AR', isArabic, () => context.read<LocaleCubit>().setArabic()),
                    const SizedBox(width: 8),
                    _langPill('EN', !isArabic, () => context.read<LocaleCubit>().setEnglish()),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.dark_mode_outlined, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('الوضع الليلي', style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary)),
                    ),
                    Switch(value: false, onChanged: (_) {}),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: <Color>[AppColors.primaryGoldDark, AppColors.primaryGoldLight]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: _save,
                      child: Text(
                        l10n.save_btn,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Expanded(child: Divider()),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('أو', style: TextStyle(fontFamily: 'Cairo')),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _authLoading ? null : _signInGoogle,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGoldDark),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 22),
                    label: Text('متابعة بـ Google', style: const TextStyle(fontFamily: 'Cairo')),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _authLoading ? null : _signInApple,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.apple, size: 20),
                    label: const Text('متابعة بـ Apple', style: TextStyle(fontFamily: 'Cairo')),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.signedInCrossDevice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                ),
                if (signedIn)
                  TextButton(
                    onPressed: () async {
                      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
                      await _authRepository.signOut();
                      messenger.showSnackBar(SnackBar(content: Text(l10n.logoutSuccess)));
                      if (!mounted) return;
                      setState(() {});
                    },
                    child: Text(l10n.sign_out),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    ValueChanged<String>? onChanged,
    Widget? suffix,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryGoldDark),
              suffixIcon: suffix,
              errorText: errorText,
              filled: true,
              fillColor: AppColors.backgroundIvory,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGoldDark.withValues(alpha: 0.3)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: AppColors.primaryGoldDark, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _langPill(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryGoldDark : AppColors.backgroundIvory,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textMuted,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
