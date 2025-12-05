import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediplan/Widgets/Add_Medication_Screen/appBar.dart';
import 'package:mediplan/Widgets/Add_Medication_Screen/backgroundcolor.dart';
import 'package:mediplan/services/notification_service.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  String? selectedDoseCount;
  List<TimeOfDay?> doseTimes = [];
  String? dosageAmount;
  String? selectedMedicationType;
  final TextEditingController _nameController = TextEditingController();

  void _updateDoseCount(String count) {
    int num = int.parse(count);
    setState(() {
      selectedDoseCount = count;
      doseTimes = List.generate(num, (_) => null);
    });
  }

  Future<void> _pickTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        doseTimes[index] = picked;
      });
    }
  }

  Future<void> saveMedication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please login first")),
      );
      return;
    }

    final timesList =
    doseTimes.where((t) => t != null).map((t) => t!.format(context)).toList();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('medications')
          .add({
        'name': _nameController.text,
        'type': selectedMedicationType ?? '',
        'dosage': dosageAmount ?? '',
        'doseCount': selectedDoseCount ?? '',
        'times': timesList,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medication saved successfully ✅ ")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" Error saving medication: $e ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          backgroundcolor(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 200),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Medication Name",
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.medication, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 35),
                  TextField(
                    onChanged: (value) {
                      dosageAmount = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Dosage Amount",
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 20),
                      prefixIcon: const Icon(Icons.scale, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMedicationType,
                      dropdownColor: Colors.black87,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      hint: const Text(
                        "Select medication type",
                        style: TextStyle(color: Colors.white70),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Tablet",
                          child: Text("💊 Tablet", style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: "Syrup",
                          child: Text("💧 Syrup ", style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: "Injection",
                          child: Text("💉 Injection ", style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: "Effervescent",
                          child: Text("🫧 Effervescent", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMedicationType = newValue;
                        });
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: DropdownButton<String>(
                      value: selectedDoseCount,
                      dropdownColor: Colors.black87,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      hint: const Text(
                        "Select number of doses per day",
                        style: TextStyle(color: Colors.white70),
                      ),
                      items: <String>['1', '2', '3', '4', '5', '6', '7']
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          "$value times/day",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) _updateDoseCount(newValue);
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (doseTimes.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(doseTimes.length, (index) {
                        final time = doseTimes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () => _pickTime(index),
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              time == null
                                  ? "Select time ${index + 1}"
                                  : "Dose ${index + 1}: ${time.format(context)}",
                            ),
                          ),
                        );
                      }),
                    ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: (_nameController.text.isNotEmpty &&
                          dosageAmount != null &&
                          selectedMedicationType != null &&
                          selectedDoseCount != null)
                          ? () async {
                        await saveMedication();
                        int notifyId =
                            DateTime.now().millisecondsSinceEpoch ~/ 1000;
                        for (var t in doseTimes) {
                          if (t != null) {
                            await NotificationService.scheduleNotification(
                              id: notifyId++,
                              title: "It's time to take your medicine 🔔",
                              body:
                                  "Name : ${_nameController.text}\n"
                              "The Medication Type is : $selectedMedicationType\n"
                                  "Dose : $dosageAmount",
                              hour: t.hour,
                              min: t.minute,
                            );
                          }
                        }
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text("Save Done ✅"),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Save Medication",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
