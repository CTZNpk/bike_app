import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/functions/int_to_month.dart';
import 'package:bike_app/shared/models/fuel_tracker_model.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FuelHistory extends ConsumerStatefulWidget {
  static const routeName = '/fuel-history';
  const FuelHistory({super.key});

  @override
  ConsumerState<FuelHistory> createState() => _FuelHistoryState();
}

class _FuelHistoryState extends ConsumerState<FuelHistory> {
  late List<FuelTrackerModel> fuelHistory;

  @override
  void initState() {
    fuelHistory = ref.read(homeServiceProvider).fuelHistoryList;
    fuelHistory = fuelHistory.reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel History'),
      ),
      body: ListView.builder(
        itemCount: fuelHistory.length,
        reverse: false,
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
                          '${fuelHistory[index].fillDate.day} ${intToMonth(fuelHistory[index].fillDate.month)} ${fuelHistory[index].fillDate.year}',
                          style: TextStyle(
                            color: myTheme.colorScheme.onSurface,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpacing(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Price :  Rs.${fuelHistory[index].price}',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Litres :  ${fuelHistory[index].litres}',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpacing(height: 8),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Meter Reading : ${fuelHistory[index].meterReading} km',
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

        /* children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
          )
        ], */
      ),
    );
  }
}
