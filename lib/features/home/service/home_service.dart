import 'package:bike_app/shared/functions/int_to_month.dart';
import 'package:bike_app/shared/models/fuel_tracker_model.dart';
import 'package:bike_app/shared/models/maintanence_tracker_model.dart';
import 'package:bike_app/shared/models/monthly_fuel.dart';
import 'package:bike_app/shared/models/upgrade_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeServiceProvider = ChangeNotifierProvider((ref) => HomeService());

class HomeService with ChangeNotifier {
  double overallAverage = 0;
  int overallDistance = 0;
  double overallLitres = 0;
  int estimatedNextFill = 0;
  int spentThisMonth = 0;
  int distanceTravelledThisMonth = 0;
  String mostRecentMaintanenceDate = '';
  String mostRecentUpgradeHistory = '';
  DateTime lastFuelDate = DateTime(1943);
  List<FuelTrackerModel> fuelHistoryList = [];
  List<MaintanenceTrackerModel> maintanceHistoryList = [];
  List<UpgradeModel> upgradeHistoryList = [];
  List<MonthlyFuel> monthlyFuelList = [];

  void notify() {
    notifyListeners();
  }

  void sortLocalMaintanenceData() {
    if (maintanceHistoryList.isEmpty) {
      return;
    }
    maintanceHistoryList
        .sort((a, b) => a.maintenenceTime.compareTo(b.maintenenceTime));
    mostRecentMaintanenceDate = maintanceHistoryList.last.maintenenceType;
  }

  void sortLocalUpgradeHistoryList() {
    if (upgradeHistoryList.isEmpty) {
      return;
    }
    upgradeHistoryList.sort((a, b) => a.time.compareTo(b.time));
    mostRecentUpgradeHistory = upgradeHistoryList.last.upgradeType;
  }

  void updateMonthlyFuel(FuelTrackerModel fuelData) {
    estimatedNextFill =
        (fuelData.meterReading + overallAverage * fuelData.litres).toInt();
    for (var item in monthlyFuelList) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(item.sortTime);
      if (fuelData.fillDate.month == date.month &&
          fuelData.fillDate.year == date.year) {
        item.addToMonthlyFuel(fuelData);
        overallAverage = overallDistance / overallLitres;
        if (fuelData.fillDate.year == DateTime.now().year &&
            fuelData.fillDate.month == DateTime.now().month) {
          spentThisMonth += fuelData.price;
          distanceTravelledThisMonth +=
              fuelData.meterReading - item.monthStartReading;
        }
        return;
      }
      if (item == monthlyFuelList.last) {
        item.updateAverageAndKmTravelled(fuelData);
        overallAverage = overallDistance / overallLitres;
      }
    }
    lastFuelDate = fuelData.fillDate;
    monthlyFuelList.add(
      MonthlyFuel(
        sortTime: DateTime(
          fuelData.fillDate.year,
          fuelData.fillDate.month,
        ).millisecondsSinceEpoch,
        month: intToMonth(fuelData.fillDate.month),
        price: fuelData.price,
        litres: fuelData.litres,
        monthStartReading: fuelData.meterReading,
        kmTravelled: 0,
        average: 0,
      ),
    );
  }

  void addToLocalFuelHistory(FuelTrackerModel fuelData) {
    fuelHistoryList.add(fuelData);
  }

  void addToLocalMaintanenceHistory(MaintanenceTrackerModel maintanenceData) {
    maintanceHistoryList.add(maintanenceData);
    sortLocalMaintanenceData();
  }

  void addToUpgradeHistoryList(UpgradeModel upgradeData) {
    upgradeHistoryList.add(upgradeData);
    sortLocalUpgradeHistoryList();
  }

  void gettingMonthlyFuelDataFromFuelHistory() {
    if (fuelHistoryList.isEmpty) {
      return;
    }
    fuelHistoryList.sort((a, b) => a.fillDate.compareTo(b.fillDate));
    int month = fuelHistoryList[0].fillDate.month;
    int year = fuelHistoryList[0].fillDate.year;
    overallAverage = 0;
    double price = 0, litres = 0;
    int startReading = fuelHistoryList[0].meterReading;
    if (fuelHistoryList.length == 1) {
      spentThisMonth = fuelHistoryList[0].price;
      estimatedNextFill = fuelHistoryList[0].meterReading;
      return;
    }

    for (var item in fuelHistoryList) {
      if (item.fillDate.month != month) {
        int kmTravelled = item.meterReading - startReading;
        overallDistance += kmTravelled;
        overallLitres += litres;

        final temp = MonthlyFuel(
          sortTime: DateTime(year, month).millisecondsSinceEpoch,
          month: intToMonth(month),
          price: price.toInt(),
          litres: litres,
          kmTravelled: kmTravelled,
          average: kmTravelled / litres,
          monthStartReading: startReading,
        );
        monthlyFuelList.add(temp);
        month = item.fillDate.month;
        year = item.fillDate.year;
        price = 0;
        litres = 0;
        startReading = item.meterReading;
        lastFuelDate = item.fillDate;
      }
      price += item.price;
      litres += item.litres;
      if (item == fuelHistoryList.last) {
        int kmTravelled = item.meterReading - startReading;
        overallLitres += litres - item.litres;
        overallDistance += kmTravelled;
        overallAverage = overallDistance / overallLitres;
        estimatedNextFill =
            (item.meterReading + overallAverage * item.litres).toInt();
        monthlyFuelList.add(
          MonthlyFuel(
            sortTime: DateTime(year, month).millisecondsSinceEpoch,
            month: intToMonth(month),
            price: price.toInt(),
            litres: litres,
            monthStartReading: item.meterReading,
            kmTravelled: kmTravelled,
            average: litres - item.litres == 0
                ? 0
                : kmTravelled / (litres - item.litres),
          ),
        );
        if (year == DateTime.now().year && month == DateTime.now().month) {
          spentThisMonth = price.toInt();
          distanceTravelledThisMonth = item.meterReading - startReading;
        } else {
          spentThisMonth = 0;
        }
      }
    }
  }
}
