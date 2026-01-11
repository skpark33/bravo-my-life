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
            title: const Text('Data Management'), // Localization needed
            subtitle: const Text('Reset all data and start over'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Data'),
                    content: const Text('Are you sure you want to delete all data? This cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                      TextButton(
                        onPressed: () {
                          context.read<LifeDataProvider>().clearData();
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Close Settings, back to Home (which will change to Intro)
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
