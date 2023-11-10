class UpgradeModel {
  UpgradeModel({
    required this.price,
    required this.time,
    required this.upgradeType,
  });

  factory UpgradeModel.fromMap(Map map) {
    return UpgradeModel(
      price: map['price'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      upgradeType: map['upgrade_type'],
    );
  }

  int? price;
  DateTime time;
  String upgradeType;

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'time': time.millisecondsSinceEpoch,
      'upgrade_type': upgradeType,
    };
  }
}
