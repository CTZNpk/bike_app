class MaintanenceTrackerModel {
  MaintanenceTrackerModel({
    required this.maintenenceTime,
    required this.price,
    required this.meterReading,
    required this.maintenenceType,
  });

  factory MaintanenceTrackerModel.fromMap(Map map) {
    return MaintanenceTrackerModel(
      maintenenceTime:
          DateTime.fromMillisecondsSinceEpoch(map['maintanence_time']),
      price: map['price'],
      meterReading: map['meter_reading'],
      maintenenceType: map['maintanence_type'],
    );
  }

  DateTime maintenenceTime;
  String maintenenceType;
  int price;
  int meterReading;

  Map<String, dynamic> toMap() {
    return {
      'maintanence_time': maintenenceTime.millisecondsSinceEpoch,
      'maintanence_type': maintenenceType,
      'price': price,
      'meter_reading': meterReading,
    };
  }
}
