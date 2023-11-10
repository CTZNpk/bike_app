import 'package:bike_app/features/auth/controller/auth_controller.dart';
import 'package:bike_app/features/average_history/screens/average_history_screen.dart';
import 'package:bike_app/features/distance_history/screens/distance_history_screen.dart';
import 'package:bike_app/features/expense_tracker/screens/expense_screen.dart';
import 'package:bike_app/features/fuel_history/screens/fuel_history_screen.dart';
import 'package:bike_app/features/home/controller/home_controller.dart';
import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/features/home/widgets/bottom_add_sheet.dart';
import 'package:bike_app/features/maintanence_tracker/screens/maintanence_screen.dart';
import 'package:bike_app/features/upgrade_tracker/screens/upgrade_screen.dart';
import 'package:bike_app/shared/functions/int_to_month.dart';
import 'package:bike_app/shared/loading/loading.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late double overallAverage;
  late int estimatedNextFill, spentThisMonth, distanceTravelledThisMonth;
  late String mostRecentMaintanence, mostRecentUpgrade;
  bool loading = true;

  void openBottomSheet() {
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return const BottomAddRecord();
        });
  }

  void signOut() {
    ref.watch(homeServiceProvider).removeListener(getData);
    ref.read(authControllerProvider).signOut();
  }

  void getData() {
    setState(() {
      loading = false;
      overallAverage = ref.read(homeServiceProvider).overallAverage;
      estimatedNextFill = ref.read(homeServiceProvider).estimatedNextFill;
      spentThisMonth = ref.read(homeServiceProvider).spentThisMonth;
      distanceTravelledThisMonth =
          ref.read(homeServiceProvider).distanceTravelledThisMonth;
      mostRecentMaintanence =
          ref.read(homeServiceProvider).mostRecentMaintanenceDate;
      mostRecentUpgrade =
          ref.read(homeServiceProvider).mostRecentUpgradeHistory;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(homeServiceProvider).addListener(getData);
    });
    ref.read(homeControllerProvider).getDataFromFirebase();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return loading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Bike Tracker'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: openBottomSheet,
                ),
                IconButton(
                  onPressed: signOut,
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            body: ListView(
              children: [
                const VerticalSpacing(height: 30),
                Center(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, AverageHistoryScreen.routeName),
                    child: CircularStepProgressIndicator(
                      height: 250,
                      width: 250,
                      currentStep: (overallAverage * 2).toInt(),
                      customStepSize: (_, __) => 20,
                      unselectedColor: myTheme.colorScheme.secondaryContainer,
                      selectedColor: myTheme.colorScheme.primary,
                      totalSteps: 160,
                      child: Center(
                        child: Text(
                          '${overallAverage.toStringAsPrecision(4)} km/litre',
                          style: TextStyle(
                            color: myTheme.colorScheme.onSurface,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpacing(height: 20),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, FuelHistory.routeName),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Estimated Next Fill',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const VerticalSpacing(height: 8),
                        Center(
                          child: Text(
                            '$estimatedNextFill km',
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
                const VerticalSpacing(height: 20),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, ExpenseScreen.routeName),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Fuel Expenditure in ${intToMonth(DateTime.now().month)}',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const VerticalSpacing(height: 8),
                        Center(
                          child: Text(
                            'Rs $spentThisMonth',
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
                const VerticalSpacing(height: 20),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, DistanceHistoryScreen.routeName),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Distance Travelled in ${intToMonth(DateTime.now().month)}',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const VerticalSpacing(height: 8),
                        Center(
                          child: Text(
                            '$distanceTravelledThisMonth km',
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
                const VerticalSpacing(height: 20),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, MaintenenceTrackerScreen.routeName),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Most Recent Maintenance : ',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const VerticalSpacing(height: 8),
                        Center(
                          child: Text(
                            mostRecentMaintanence == ''
                                ? 'Nill'
                                : mostRecentMaintanence,
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
                const VerticalSpacing(height: 20),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, UpgradeScreen.routeName),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Recent Upgrade : ',
                            style: TextStyle(
                              color: myTheme.colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const VerticalSpacing(height: 8),
                        Center(
                          child: Text(
                            mostRecentUpgrade == ''
                                ? 'Nill'
                                : mostRecentUpgrade,
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
                const VerticalSpacing(height: 30),
              ],
            ),
          );
  }
}
