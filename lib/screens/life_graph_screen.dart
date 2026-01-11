import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/life_data_provider.dart';

class LifeGraphScreen extends StatelessWidget {
  const LifeGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lifeData = context.watch<LifeDataProvider>().lifeData;

    if (lifeData == null) return const SizedBox();

    // Prepare data
    // Map score 1(Best)-7(Worst) to Y 7-1.
    final List<FlSpot> spots = [];
    int minYear = lifeData.birthYear;
    int maxYear = lifeData.birthYear;

    lifeData.years.forEach((year, data) {
      if (data.score != null) {
        // Y = 8 - score. (1->7, 7->1)
        spots.add(FlSpot(year.toDouble(), (8 - data.score!).toDouble()));
        if (year > maxYear) maxYear = year;
      }
    });

    spots.sort((a, b) => a.x.compareTo(b.x));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.lifeGraph)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: spots.isEmpty
            ? Center(child: Text("No rated years yet."))
            : LineChart(
                LineChartData(
                  minX: lifeData.birthYear.toDouble(),
                  maxX: minYear + 100.0,
                  minY: 1,
                  maxY: 7,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true, 
                        color: Colors.blue.withOpacity(0.1)
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10, // Every 10 years
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(value.toInt().toString()),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // Map back to labels?
                          // Value 7 -> Best (1)
                          // Value 1 -> Worst (7)
                          int score = 8 - value.toInt();
                          return Text(score.toString());
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
      ),
    );
  }
}
