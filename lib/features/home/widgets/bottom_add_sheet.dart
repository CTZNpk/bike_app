import 'package:bike_app/features/home/controller/home_controller.dart';
import 'package:bike_app/features/home/service/home_service.dart';
import 'package:bike_app/shared/enums/entryType.dart';
import 'package:bike_app/shared/models/fuel_tracker_model.dart';
import 'package:bike_app/shared/models/maintanence_tracker_model.dart';
import 'package:bike_app/shared/models/upgrade_model.dart';
import 'package:bike_app/shared/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BottomAddRecord extends ConsumerStatefulWidget {
  const BottomAddRecord({super.key});

  @override
  ConsumerState<BottomAddRecord> createState() => _BottomAddRecordState();
}

class _BottomAddRecordState extends ConsumerState<BottomAddRecord> {
  final expenseInput = TextEditingController();
  final numberInput = TextEditingController();
  final meterReading = TextEditingController();
  final litresInput = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  EntryType entryType = EntryType.fuel;

  void openDatePicker() async {
    final DateTime now = DateTime.now();
    final chosenDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: entryType == EntryType.fuel
            ? ref.read(homeServiceProvider).lastFuelDate
            : DateTime(now.year - 1),
        lastDate: now);
    setState(() {
      selectedDate = chosenDate ?? DateTime.now();
    });
  }

  void onSaveExpense() async {
    if (entryType == EntryType.fuel) {
      if (numberInput.text.trim().isEmpty ||
          litresInput.text.trim().isEmpty ||
          meterReading.text.trim().isEmpty) {
        showSnackBar(context: context, content: 'Please Fill All The Values');
      } else {
        await ref.read(homeControllerProvider).storeFuelData(
              FuelTrackerModel(
                fillDate: selectedDate!,
                price: int.parse(numberInput.text.trim()),
                meterReading: int.parse(meterReading.text.trim()),
                litres: double.parse(litresInput.text.trim()),
              ),
            );
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else if (entryType == EntryType.upgrade) {
      if (expenseInput.text.trim().isEmpty || numberInput.text.trim().isEmpty) {
        showSnackBar(context: context, content: 'Please Fill All The Values');
      } else {
        await ref.read(homeControllerProvider).storeUpgradeData(
              UpgradeModel(
                price: int.parse(numberInput.text.trim()),
                time: selectedDate!,
                upgradeType: expenseInput.text.trim(),
              ),
            );
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else {
      if (expenseInput.text.trim().isEmpty ||
          numberInput.text.trim().isEmpty ||
          meterReading.text.trim().isEmpty) {
        showSnackBar(context: context, content: 'Please Fill All The Values');
      } else {
        await ref.read(homeControllerProvider).storeMaintanenceData(
              MaintanenceTrackerModel(
                maintenenceTime: selectedDate!,
                price: int.parse(numberInput.text.trim()),
                meterReading: int.parse(meterReading.text.trim()),
                maintenenceType: expenseInput.text.trim(),
              ),
            );
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Column(
        children: [
          const Text(
            "Add a New Record",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          entryType == EntryType.fuel
              ? const SizedBox.shrink()
              : TextField(
                  maxLength: 50,
                  controller: expenseInput,
                  decoration: const InputDecoration(
                    label: Text(
                      "Enter Details",
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: numberInput,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "Rs",
                    prefixStyle:
                        TextStyle(color: myTheme.colorScheme.onSurface),
                    label: const Text(
                      "Amount",
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              DropdownButton(
                  dropdownColor: myTheme.scaffoldBackgroundColor,
                  focusColor: Colors.transparent,
                  icon: const Icon(Icons.category),
                  value: entryType,
                  items: EntryType.values
                      .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase())))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      entryType = value!;
                    });
                  }),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          Row(
            children: [
              entryType == EntryType.fuel
                  ? Expanded(
                      child: TextField(
                        controller: litresInput,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text(
                            "Litres",
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                width: 10,
              ),
              entryType == EntryType.upgrade
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: TextField(
                        controller: meterReading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text(
                            "Meter Reading",
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                  onPressed: openDatePicker,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(DateFormat.yMd().format(selectedDate!))),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: onSaveExpense,
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
