import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/life_data_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.language),
            trailing: Consumer<LocaleProvider>(
              builder: (context, provider, _) {
                return DropdownButton<Locale>(
                  value: provider.locale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      provider.setLocale(newLocale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('ko'),
                      child: Text('한국어'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ja'),
                      child: Text('日本語'),
                    ),
                  ],
                );

              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.birthYear),
            // Show current birth year
            subtitle: Consumer<LifeDataProvider>(
              builder: (context, provider, _) { 
                return Text('${provider.lifeData?.birthYear ?? "?"}');
              }
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _BirthYearDialog(),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.dataManagement),
            subtitle: Text(l10n.resetDataSubtitle),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.resetData),
                    content: Text(l10n.resetDataWarning),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                      TextButton(
                        onPressed: () {
                          context.read<LifeDataProvider>().clearData();
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Close Settings
                        }, 
                        child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthYearDialog extends StatefulWidget {
  @override
  State<_BirthYearDialog> createState() => _BirthYearDialogState();
}

class _BirthYearDialogState extends State<_BirthYearDialog> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    final currentYear = context.read<LifeDataProvider>().lifeData?.birthYear;
    if (currentYear != null) {
      _controller.text = currentYear.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.birthYear),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: l10n.birthYear,
            hintText: '1968'
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
            onPressed: () {
                final year = int.tryParse(_controller.text);
                if (year != null && year >= 1900 && year <= 2100) {
                    context.read<LifeDataProvider>().changeBirthYear(year);
                    Navigator.pop(context);
                }
            },
            child: Text(l10n.save)
        )
      ],
    );
  }
}
