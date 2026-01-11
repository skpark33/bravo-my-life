import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/life_data_provider.dart';
import 'intro_screen.dart';
import 'home_screen.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LifeDataProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.lifeData == null) {
          return const IntroScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
