import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/models/monthly_fuel.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  static const routeName = '/monthly-expense-screen';
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  late List<MonthlyFuel> fuelList;
  List<double> data = [];
  int totalSpent = 0;

  @override
  void initState() {
    fuelList = ref.read(homeServiceProvider).monthlyFuelList;
    for (var i = 0; i < fuelList.length; i++) {
      if (i >= fuelList.length - 12) {
        data.add(fuelList[i].price.toDouble());
      }
      totalSpent += fuelList[i].price;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Expense History'),
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
                data: data,
              ),
            ),
          ),
          const VerticalSpacing(height: 40),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Total Spent On Fuel',
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
          const VerticalSpacing(height: 40),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Spend History',
              style: TextStyle(
                color: myTheme.colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              reverse: true,
              itemCount: fuelList.length,
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
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                fuelList[index].month,
                                style: TextStyle(
                                  color: myTheme.colorScheme.onSurface,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpacing(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Spent : Rs.${fuelList[index].price.toInt()}',
                                style: TextStyle(
                                  color: myTheme.colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Distance : ${fuelList[index].kmTravelled.toInt()} km',
                                style: TextStyle(
                                  color: myTheme.colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpacing(height: 15),
                          Text(
                            'Mileage : ',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: 24,
                              width: size.width * 0.80,
                              child: FAProgressBar(
                                currentValue: fuelList[index].average,
                                maxValue: 80,
                                direction: Axis.horizontal,
                                progressColor: myTheme.colorScheme.primary,
                                backgroundColor:
                                    myTheme.colorScheme.secondaryContainer,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${fuelList[index].average.toStringAsPrecision(4)} km/litre',
                              style: TextStyle(
                                color: myTheme.colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
