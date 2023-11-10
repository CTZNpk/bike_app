import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/models/monthly_fuel.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AverageHistoryScreen extends ConsumerStatefulWidget {
  static const routeName = '/average-history-screen';
  const AverageHistoryScreen({super.key});

  @override
  ConsumerState<AverageHistoryScreen> createState() =>
      _AverageHistoryScreenState();
}

class _AverageHistoryScreenState extends ConsumerState<AverageHistoryScreen> {
  late List<MonthlyFuel> averageList;
  List<double> averageGraph = [];

  @override
  void initState() {
    averageList = ref.read(homeServiceProvider).monthlyFuelList;
    for (var i = 0; i < averageList.length; i++) {
      if (i >= averageList.length - 12) {
        averageGraph.add(averageList[i].average);
      }
    }
    averageList = averageList.reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mileage History',
        ),
      ),
      body: ListView(
        children: [
          const VerticalSpacing(height: 20),
          Center(
            child: SizedBox(
              width: size.width * 0.8,
              height: 150,
              child: Sparkline(
                lineWidth: 4.0,
                pointsMode: PointsMode.all,
                pointSize: 8.0,
                data: averageGraph,
              ),
            ),
          ),
          const VerticalSpacing(height: 40),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: averageList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              averageList[index].month,
                              style: TextStyle(
                                color: myTheme.colorScheme.onSurface,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Mileage : ${averageList[index].average.toStringAsPrecision(4)} km/litre',
                              style: TextStyle(
                                color: myTheme.colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
