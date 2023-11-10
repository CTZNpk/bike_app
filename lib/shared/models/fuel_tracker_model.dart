class FuelTrackerModel {
  FuelTrackerModel({
    required this.fillDate,
    required this.price,
    required this.meterReading,
    required this.litres,
  });

  factory FuelTrackerModel.fromMap(Map map) {
    return FuelTrackerModel(
      fillDate: DateTime.fromMillisecondsSinceEpoch(map['fill_date']),
      price: map['price'],
      meterReading: map['meter_reading'],
      litres: map['litres'],
    );
  }

  DateTime fillDate;
  int price;
  int meterReading;
  double litres;

  Map<String, dynamic> toMap() {
    return {
      'fill_date': fillDate.millisecondsSinceEpoch,
      'price': price,
      'meter_reading': meterReading,
      'litres': litres,
    };
  }
}
