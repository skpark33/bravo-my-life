import 'dart:io';
import 'package:flutter/material.dart';

import '../models/life_year.dart';
import 'year_detail_dialog.dart';

class LifeGridItem extends StatelessWidget {
  final int year;
  final int age;
  final LifeYear? lifeYear;
  final bool isSamjaeColumn;

  const LifeGridItem({
    super.key,
    required this.year,
    required this.age,
    required this.lifeYear,
    required this.isSamjaeColumn,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (lifeYear?.score != null) {
      switch (lifeYear!.score) {
        case 1: return Colors.green[900]!;
        case 2: return Colors.green[600]!;
        case 3: return Colors.green[300]!;
        case 4: return Colors.white;
        case 5: return Colors.red[200]!;
        case 6: return Colors.red[500]!;
        case 7: return Colors.red[900]!;
      }
    }
    
    // Default background
    // Requirement: "Last 3 columns... separate color separator".
    // Maybe we tint the background slightly for Samjae columns if no score
    if (isSamjaeColumn) {
      return Colors.grey[200]!;
    }
    return Colors.white;
  }

  Color _getTextColor() {
    if (lifeYear?.score != null) {
      if (lifeYear!.score == 1 || lifeYear!.score == 7) {
        return Colors.white;
      }
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(context);
    final textColor = _getTextColor();
    final hasEvents = lifeYear?.events.isNotEmpty ?? false;

    return InkWell(
      onTap: () {
        // Show dialog
        showDialog(
          context: context, 
          builder: (_) => YearDetailDialog(
            year: year,
            age: age,
            lifeYear: lifeYear ?? LifeYear(year: year), // Pass empty if null, but we usually ensure it's in the map
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year
            Text(
              '$year',
              style: TextStyle(
                fontSize: 10, 
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // Age
            Text(
              '($age)',
              style: TextStyle(
                fontSize: 8,
                color: textColor.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            // Event Indicator (or Photo)
             if (lifeYear?.photoPath != null)
               Expanded(
                 child: dynamicWrapper(),
               )
             else if (hasEvents)
               const Icon(Icons.event, size: 12, color: Colors.blue),
          ],
        ),
      ),
    );
  }
  
  Widget dynamicWrapper() {
      if (lifeYear?.photoPath != null) {
        return Image.file(File(lifeYear!.photoPath!), fit: BoxFit.cover);
      }
      return const Icon(Icons.photo, size: 12);
  }
}
