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
        case 7: return Colors.green[900]!;
        case 6: return Colors.green[600]!;
        case 5: return Colors.green[300]!;
        case 4: return Colors.purple[100]!;
        case 3: return Colors.red[200]!;
        case 2: return Colors.red[500]!;
        case 1: return Colors.red[900]!;
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
      if (lifeYear!.score == 7 || lifeYear!.score == 1) {
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

    final isCurrentYear = year == DateTime.now().year;

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
          border: isCurrentYear 
              ? Border.all(color: Colors.blue[700]!, width: 3) 
              : isSamjaeColumn 
                  ? Border.all(color: Colors.amber[700]!, width: 2) // Dark yellow, slightly thicker than hairline
                  : Border.all(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year
            Text(
              '$year',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // Age
            Text(
              '($age)',
              style: TextStyle(
                fontSize: 14,
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
               // On Windows, show event title text
               if (Platform.isWindows)
                 ...lifeYear!.events.take(3).map((event) => Padding(
                   padding: const EdgeInsets.only(bottom: 2.0),
                   child: Text(
                     event.title,
                     style: TextStyle(fontSize: 14, color: textColor), // Match Year Color
                     overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                   ),
                 ))
               else
                 ...[Icon(Icons.event, size: 12, color: textColor)], // Also match icon color for consistency
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
