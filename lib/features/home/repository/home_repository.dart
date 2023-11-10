import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/models/fuel_tracker_model.dart';
import 'package:bike_app/shared/models/maintanence_tracker_model.dart';
import 'package:bike_app/shared/models/upgrade_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(
    firebase: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    service: ref.read(homeServiceProvider),
  ),
);

class HomeRepository {
  HomeRepository({
    required this.firebase,
    required this.auth,
    required this.service,
  });

  final FirebaseFirestore firebase;
  final FirebaseAuth auth;
  final HomeService service;

  Future getFuelDataFromFirebase() async {
    final fueldata = await firebase
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('fuel')
        .get();
    for (var items in fueldata.docs) {
      final data = items.data();
      service.addToLocalFuelHistory(FuelTrackerModel.fromMap(data));
    }
    service.gettingMonthlyFuelDataFromFuelHistory();
  }

  Future getUpgradeDataFromFirebase() async {
    final upgradeData = await firebase
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('upgrades')
        .get();
    for (var items in upgradeData.docs) {
      final data = items.data();
      service.addToUpgradeHistoryList(UpgradeModel.fromMap(data));
    }
    service.sortLocalUpgradeHistoryList();
  }

  Future getMaintanenceDataFromFirebase() async {
    final upgradeData = await firebase
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('maintanence')
        .get();
    for (var items in upgradeData.docs) {
      final data = items.data();
      service
          .addToLocalMaintanenceHistory(MaintanenceTrackerModel.fromMap(data));
    }
    service.sortLocalMaintanenceData();
    service.notify();
  }

  Future storeFuelDataToFirebase(FuelTrackerModel fuelData) async {
    await firebase
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('fuel')
        .doc(fuelData.fillDate.millisecondsSinceEpoch.toString())
        .set(fuelData.toMap());
    service.addToLocalFuelHistory(fuelData);
    service.updateMonthlyFuel(fuelData);
    service.notify();
  }

  Future storeUpgradeToFirebase(UpgradeModel upgradeData) async {
    await firebase
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('upgrades')
        .doc(upgradeData.time.millisecondsSinceEpoch.toString())
        .set(upgradeData.toMap());
    service.addToUpgradeHistoryList(upgradeData);
    service.sortLocalUpgradeHistoryList();
    service.notify();
  }

  Future storeMaintanenceToFirebase(
      MaintanenceTrackerModel maintanenceData) async {
    await firebase
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('maintanence')
        .doc(maintanenceData.maintenenceTime.millisecondsSinceEpoch.toString())
        .set(maintanenceData.toMap());
    service.addToLocalMaintanenceHistory(maintanenceData);
    service.sortLocalMaintanenceData();
    service.notify();
  }
}
