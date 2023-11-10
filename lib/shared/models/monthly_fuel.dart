import 'package:bike_app/shared/models/fuel_tracker_model.dart';

class MonthlyFuel {
  MonthlyFuel({
    required this.sortTime,
    required this.month,
    required this.price,
    required this.litres,
    required this.monthStartReading,
    required this.kmTravelled,
    required this.average,
  });

  int sortTime;
  String month;
  int monthStartReading;
  int price;
  double litres;
  int kmTravelled;
  double average;

  void addToMonthlyFuel(FuelTrackerModel fuelHistory) {
    price += fuelHistory.price;
    litres += fuelHistory.litres;
    kmTravelled = fuelHistory.meterReading - monthStartReading;
    average = kmTravelled / litres;
  }

  void updateAverageAndKmTravelled(FuelTrackerModel fuelHistory) {
    kmTravelled = fuelHistory.meterReading - monthStartReading;
    average = kmTravelled / litres;
  }
}
