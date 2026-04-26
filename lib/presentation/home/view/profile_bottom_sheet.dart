import 'dart:async';

import 'package:agpeya/core/di/injection.dart';
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 34)),
              const SizedBox(height: 12),
              TextField(controller: _name, decoration: InputDecoration(hintText: l10n.display_name_hint)),
              const SizedBox(height: 8),
              TextField(
                controller: _username,
                onChanged: _onUsernameChanged,
                decoration: InputDecoration(
                  hintText: l10n.username_hint,
                  suffixIcon: _checking
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : _available == true
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                  errorText: _usernameError,
                ),
              ),
              const SizedBox(height: 8),
              TextField(controller: _church, decoration: InputDecoration(hintText: l10n.church_hint)),
              const SizedBox(height: 8),
              TextField(controller: _city, decoration: InputDecoration(hintText: l10n.city_hint)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: _save, child: Text(l10n.save_btn)),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settings_language),
                subtitle: Text(isArabic ? 'AR' : 'EN'),
                trailing: SegmentedButton<String>(
                  segments: <ButtonSegment<String>>[
                    ButtonSegment<String>(value: 'ar', label: Text(l10n.tab_arabic)),
                    ButtonSegment<String>(value: 'en', label: Text(l10n.tab_english)),
                  ],
                  selected: <String>{isArabic ? 'ar' : 'en'},
                  onSelectionChanged: (Set<String> selection) {
                    if (selection.first == 'ar') {
                      context.read<LocaleCubit>().setArabic();
                    } else {
                      context.read<LocaleCubit>().setEnglish();
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.signedInCrossDevice),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _authLoading ? null : _signInGoogle,
                icon: const Icon(Icons.g_mobiledata),
                label: Text(l10n.sign_in_google),
              ),
              OutlinedButton.icon(
                onPressed: _authLoading ? null : _signInApple,
                icon: const Icon(Icons.apple),
                label: Text(l10n.sign_in_apple),
              ),
              if (signedIn)
                ListTile(
                  leading: const Icon(Icons.verified, color: Colors.green),
                  title: Text(l10n.already_signed_in),
                  trailing: TextButton(
                    onPressed: () async {
                      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
                      await _authRepository.signOut();
                      messenger.showSnackBar(SnackBar(content: Text(l10n.logoutSuccess)));
                      if (!mounted) return;
                      setState(() {});
                    },
                    child: Text(l10n.sign_out),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
