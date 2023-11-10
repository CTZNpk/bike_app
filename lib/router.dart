import 'package:bike_app/features/auth/screens/register_email_password.dart';
import 'package:bike_app/features/average_history/screens/average_history_screen.dart';
import 'package:bike_app/features/distance_history/screens/distance_history_screen.dart';
import 'package:bike_app/features/expense_tracker/screens/expense_screen.dart';
import 'package:bike_app/features/fuel_history/screens/fuel_history_screen.dart';
import 'package:bike_app/features/maintanence_tracker/screens/maintanence_screen.dart';
import 'package:bike_app/features/upgrade_tracker/screens/upgrade_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ExpenseScreen.routeName:
      return MaterialPageRoute(builder: (context) => const ExpenseScreen());
    case EmailAndPasswordRegister.routeName:
      return MaterialPageRoute(
          builder: (context) => const EmailAndPasswordRegister());
    case FuelHistory.routeName:
      return MaterialPageRoute(
        builder: (context) => const FuelHistory(),
      );
    case DistanceHistoryScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const DistanceHistoryScreen(),
      );
    case MaintenenceTrackerScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MaintenenceTrackerScreen(),
      );
    case UpgradeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UpgradeScreen(),
      );
    case AverageHistoryScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AverageHistoryScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('This Page Does not Exist'),
          ),
        ),
      );
  }
}
