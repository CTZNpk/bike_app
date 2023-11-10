import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/functions/int_to_month.dart';
import 'package:bike_app/shared/models/upgrade_model.dart';
import 'package:bike_app/shared/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpgradeScreen extends ConsumerStatefulWidget {
  static const routeName = '/upgrade-screen';
  const UpgradeScreen({
    super.key,
  });

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen> {
  late List<UpgradeModel> upgradesList;
  int totalSpent = 0;

  @override
  void initState() {
    upgradesList = ref.read(homeServiceProvider).upgradeHistoryList;
    for (var item in upgradesList) {
      totalSpent += item.price!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Tracker'),
      ),
      body: ListView(
        children: [
          const VerticalSpacing(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Total Spent On Upgrades',
              style: TextStyle(
                color: myTheme.colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ),
          const VerticalSpacing(height: 8),
          ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
              itemCount: upgradesList.length,
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
                                '${upgradesList[index].time.day} ${intToMonth(upgradesList[index].time.month)} - ${upgradesList[index].time.year}',
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
                              upgradesList[index].upgradeType,
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
                              'Price :  Rs.${upgradesList[index].price}',
                              style: TextStyle(
                                color: myTheme.colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const VerticalSpacing(height: 8),
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
