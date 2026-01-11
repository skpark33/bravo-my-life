import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/life_data_provider.dart';
import 'life_grid_item.dart';

class LifeGrid extends StatelessWidget {
  const LifeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LifeDataProvider>(
      builder: (context, provider, child) {
        if (provider.lifeData == null) return const SizedBox();

        final offset = provider.gridStartOffset;
        final birthYear = provider.lifeData!.birthYear;
        // Total years to show: 100 years + 1 (birth year) = 101 items.
        // Plus offset.
        final totalItems = offset + 101; 

        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine item size or use aspect ratio
            // On mobile, force landscape for better view? Or just scroll.
            // Requirement: "horizontal items 12... need horizontal mode on phone or scrollbar".
            // We will stick to standard vertical scroll grid with 12 cols.
            // On narrow screens (mobile portrait), 12 cols is too small.
            // Requirement says "Mobile... horizontal mode...".
            // But we can just enforce min width per item and scroll horizontally?
            // "Grid's horizontal item count MUST be 12."
            
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12,
                childAspectRatio: 0.8, // Taller than wide
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                if (index < offset) {
                  return const SizedBox(); // Empty padding
                }
                
                final int yearIndex = index - offset;
                final int currentYear = birthYear + yearIndex;
                final lifeYear = provider.lifeData!.years[currentYear];
                
                // Column index 0-11
                final int colIndex = index % 12;

                return LifeGridItem(
                  year: currentYear,
                  age: yearIndex, // 0-based age (Korean age might be +1, but stick to international or 0-start for now unless specified. "1968년... example 1968" usually implies 0 or 1. Let's show Age. 0 or 1?)
                  // Requirement: "Year... Age 12".
                  // Let's use 만 나이 (International Age, starting 0).
                  lifeYear: lifeYear,
                  isSamjaeColumn: colIndex >= 9, // Last 3 columns (9, 10, 11)
                );
              },
            );
          },
        );
      },
    );
  }
}
