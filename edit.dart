import 'package:flutter/material.dart';
import 'package:myfitness/database.dart'; // Import your DatabaseService
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditActivityDialog extends StatelessWidget {
  final Map<String, dynamic> activity;
  final DatabaseService dbService = DatabaseService();

  EditActivityDialog({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String workoutName = activity['name'];
    String duration = activity['duration'];
    String calories = activity['calories'];
    TextEditingController durationController = TextEditingController(text: duration);
    TextEditingController caloriesController = TextEditingController(text: calories);

    return AlertDialog(
      title: Text('Edit $workoutName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: durationController,
            decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: caloriesController,
            decoration: const InputDecoration(labelText: 'Calories burned'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Call delete method if needed
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            String updatedDuration = durationController.text;
            String updatedCalories = caloriesController.text;
            DateTime updatedTimestamp = DateTime.now();

            dbService.updateActivity(activity['id'], updatedDuration, updatedCalories, updatedTimestamp);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
