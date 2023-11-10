import 'package:bike_app/features/home/repository/home_repository.dart';
import 'package:bike_app/shared/models/fuel_tracker_model.dart';
import 'package:bike_app/shared/models/maintanence_tracker_model.dart';
import 'package:bike_app/shared/models/upgrade_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = Provider((ref) {
  final homeRepository = ref.read(homeRepositoryProvider);
  return HomeController(homeRepository: homeRepository);
});

class HomeController {
  HomeController({required this.homeRepository});

  final HomeRepository homeRepository;

  Future getDataFromFirebase() async {
    await homeRepository.getFuelDataFromFirebase();
    await homeRepository.getUpgradeDataFromFirebase();
    await homeRepository.getMaintanenceDataFromFirebase();
  }

  Future storeFuelData(FuelTrackerModel fuelData) async {
    await homeRepository.storeFuelDataToFirebase(fuelData);
  }

  Future storeMaintanenceData(MaintanenceTrackerModel maintanenceData) async {
    await homeRepository.storeMaintanenceToFirebase(maintanenceData);
  }

  Future storeUpgradeData(UpgradeModel upgradeData) async {
    await homeRepository.storeUpgradeToFirebase(upgradeData);
  }
}
