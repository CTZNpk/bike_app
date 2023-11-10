import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/models/monthly_fuel.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DistanceHistoryScreen extends ConsumerStatefulWidget {
  static const routeName = '/distance-history-screen';
  const DistanceHistoryScreen({
    super.key,
  });


  @override
  ConsumerState<DistanceHistoryScreen> createState() => _DistanceHistoryScreenState();
}

class _DistanceHistoryScreenState extends ConsumerState<DistanceHistoryScreen> {
  List<double> distanceGraph = [];
  late List<MonthlyFuel> distanceList;
  int totalDistanceTravelled = 0;

  @override
  void initState() {
    distanceList = ref.read(homeServiceProvider).monthlyFuelList;
    

    for (var i = 0; i < distanceList.length; i++) {
      if (i >= distanceList.length - 12) {
        distanceGraph.add(distanceList[i].kmTravelled.toDouble());
      }
      totalDistanceTravelled += distanceList[i].kmTravelled;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Distance History',
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
                data: distanceGraph,
              ),
            ),
          ),
          const VerticalSpacing(height: 40),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Total Distance Travelled',
              style: TextStyle(
                color: myTheme.colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ),
          const VerticalSpacing(height: 8),
          Center(
            child: Text(
              '$totalDistanceTravelled km',
              style: TextStyle(
                color: myTheme.colorScheme.onSurface,
                fontSize: 22,
              ),
            ),
          ),
          const VerticalSpacing(height: 12),
          ListView.builder(
            reverse: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: distanceList.length,
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
                              distanceList[index].month,
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
                              'Distance Travelled : ${distanceList[index].kmTravelled} km',
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
