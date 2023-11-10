import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/functions/int_to_month.dart';
import 'package:bike_app/shared/models/maintanence_tracker_model.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaintenenceTrackerScreen extends ConsumerStatefulWidget {
  static const routeName = '/maintanence-tracker-screen';
  const MaintenenceTrackerScreen({
    super.key,
  });

  @override
  ConsumerState<MaintenenceTrackerScreen> createState() =>
      _MaintenenceTrackerScreenState();
}

class _MaintenenceTrackerScreenState
    extends ConsumerState<MaintenenceTrackerScreen> {
  late List<MaintanenceTrackerModel> maintanenceList;
  int totalSpent = 0;

  @override
  void initState() {
    maintanenceList = ref.read(homeServiceProvider).maintanceHistoryList;
    for (var items in maintanenceList) {
      totalSpent += items.price;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenence History'),
      ),
      body: ListView(
        children: [
          const VerticalSpacing(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Total Spent On Maintenece',
              style: TextStyle(
                color: myTheme.colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ),
          const VerticalSpacing(height: 8),
          Center(
            child: Text(
              'Rs. $totalSpent',
              style: TextStyle(
                color: myTheme.colorScheme.onSurface,
                fontSize: 22,
              ),
            ),
          ),
          const VerticalSpacing(height: 20),
          ListView.builder(
              shrinkWrap: true,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maintanenceList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                '${maintanenceList[index].maintenenceTime.day} ${intToMonth(maintanenceList[index].maintenenceTime.month)} ${maintanenceList[index].maintenenceTime.year}',
                                style: TextStyle(
                                  color: myTheme.colorScheme.onSurface,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpacing(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              maintanenceList[index].maintenenceType,
                              style: TextStyle(
                                color: myTheme.colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const VerticalSpacing(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Price :  Rs.${maintanenceList[index].price}',
                              style: TextStyle(
                                color: myTheme.colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const VerticalSpacing(height: 8),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Meter Reading : ${maintanenceList[index].meterReading} km',
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
              })
        ],
      ),
    );
  }
}
