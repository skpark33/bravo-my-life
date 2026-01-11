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
        // Y = score. (1->1, 7->7)
        spots.add(FlSpot(year.toDouble(), data.score!.toDouble()));
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
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: LineChart(
                      LineChartData(
                        minX: lifeData.birthYear.toDouble(),
                        maxX: minYear + 100.0,
                        minY: 1,
                        maxY: 7,
                        lineTouchData: LineTouchData(
                          enabled: false, // Disable touch interaction to just show permanent labels
                          touchTooltipData: LineTouchTooltipData(
                             getTooltipColor: (touchedSpot) => Colors.transparent,
                             tooltipPadding: EdgeInsets.zero,
                             tooltipMargin: 4,
                             getTooltipItems: (touchedSpots) {
                               return touchedSpots.map((spot) {
                                 final year = spot.x.toInt();
                                 final yearData = lifeData.years[year];
                                 if (yearData != null && yearData.events.isNotEmpty) {
                                   String title = yearData.events.first.title;
                                   
                                   final isEven = year % 2 == 0;
                                   if (isEven) {
                                     // Add significant spacing to push the label much higher
                                     // Using spaces to ensure lines aren't trimmed
                                     title = "$title\n \n \n \n \n \n \n ";
                                   }
                                   
                                   return LineTooltipItem(
                                     title,
                                     const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                   );
                                 }
                                 return null;
                               }).toList();
                             },
                          ),
                        ),
                        showingTooltipIndicators: spots.where((spot) {
                          final year = spot.x.toInt();
                          final yearData = lifeData.years[year];
                          return yearData != null && yearData.events.isNotEmpty;
                        }).map((spot) => ShowingTooltipIndicators([
                          LineBarSpot(
                            LineChartBarData(spots: spots),
                            spots.indexOf(spot),
                            spot,
                          ),
                        ])).toList(),
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
                                // Value is directly expectation score
                                int score = value.toInt();
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
                  );
                },
              ),
      ),
    );
  }
}
