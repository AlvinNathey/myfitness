import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new activity
  Future<void> addActivity(String name, String duration, String calories, String? selectedImage) async {
    await _firestore.collection('activities').add({
      'name': name,
      'duration': duration,
      'calories': calories,
      'image': selectedImage, // Add the image field
    });
  }

  // Fetch all activities
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    QuerySnapshot snapshot = await _firestore.collection('activities').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Example of updating an activity
  Future<void> updateActivity(String id, Map<String, dynamic> data) async {
    await _firestore.collection('activities').doc(id).update(data);
  }

  // Example of deleting an activity
  Future<void> deleteActivity(String id) async {
    await _firestore.collection('activities').doc(id).delete();
  }
}
