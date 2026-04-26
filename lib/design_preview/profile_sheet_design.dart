import 'package:agpeya/design_preview/design_tokens.dart';
import 'package:flutter/material.dart';

class ProfileSheetDesign extends StatelessWidget {
  const ProfileSheetDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DesignTokens.ivory,
        appBar: AppBar(title: Text('Profile Sheet Preview', style: DesignTokens.ui(16))),
        body: Center(
          child: FilledButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const _Sheet(),
              );
            },
            child: Text('فتح التصميم', style: DesignTokens.ar()),
          ),
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: DesignTokens.gold, width: 2)),
                      child: const CircleAvatar(radius: 38, child: Text('م.ج')),
                    ),
                    const Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 12, child: Icon(Icons.camera_alt, size: 14))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _field('مينا جرجس', Icons.person),
              const SizedBox(height: 8),
              _field('@mina_georg', Icons.alternate_email, suffix: const Icon(Icons.check_circle, color: Colors.green)),
              const SizedBox(height: 8),
              _field('كنيسة مارجرجس', Icons.church),
              const SizedBox(height: 8),
              _field('الإسكندرية', Icons.location_on_outlined),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('اللغة', style: DesignTokens.ar()),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: const <Widget>[_Lang('AR', true), SizedBox(width: 8), _Lang('EN', false)]),
              ),
              SwitchListTile(value: true, onChanged: (_) {}, title: Text('الوضع الداكن', style: DesignTokens.ar())),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: DesignTokens.gold, minimumSize: const Size.fromHeight(48)),
                child: Text('حفظ التغييرات', style: DesignTokens.ar(15, Colors.white)),
              ),
              const SizedBox(height: 12),
              Row(children: const <Widget>[Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('أو')), Expanded(child: Divider())]),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata), label: const Text('Google')),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
              ),
              const SizedBox(height: 8),
              Text('سجّل دخولك لحفظ تقدمك على أجهزة أخرى', textAlign: TextAlign.center, style: DesignTokens.ar(12, Colors.grey.shade700)),
            ],
          ),
        );
      },
    );
  }

  Widget _field(String hint, IconData icon, {Widget? suffix}) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _Lang extends StatelessWidget {
  const _Lang(this.text, this.selected);
  final String text;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? DesignTokens.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: DesignTokens.gold),
      ),
      child: Text(text, style: DesignTokens.ui(12, selected ? Colors.white : DesignTokens.gold)),
    );
  }
}
