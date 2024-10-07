import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new activity with the current timestamp and return the document ID
  Future<String> addActivity(String name, String duration, String calories, String? selectedImage) async {
    DocumentReference docRef = await _firestore.collection('activities').add({
      'name': name,
      'duration': duration,
      'calories': calories,
      'image': selectedImage, // Add the image field
      'timestamp': FieldValue.serverTimestamp(), // Store the current time
    });
    return docRef.id; // Return the document ID
  }

  // Fetch all activities and order them by timestamp
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    QuerySnapshot snapshot = await _firestore
        .collection('activities')
        .orderBy('timestamp', descending: true) // Fetch in descending order of time
        .get();
    return snapshot.docs.map((doc) => {
      'id': doc.id, // Include the document ID in the returned map
      ...doc.data() as Map<String, dynamic>
    }).toList();
  }

  // Example of updating an activity
  Future<void> updateActivity(String id, String updatedDuration, String updatedCalories, DateTime updatedTimestamp) async {
    await _firestore.collection('activities').doc(id).update({
      'duration': updatedDuration,
      'calories': updatedCalories,
      'timestamp': updatedTimestamp, // Update timestamp if needed
    });
  }

  // Example of deleting an activity
  Future<void> deleteActivity(String id) async {
    await _firestore.collection('activities').doc(id).delete();
  }
}
