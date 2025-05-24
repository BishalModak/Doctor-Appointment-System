import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_list_screen.dart';
import 'admin_panel_screen.dart'; // Import the AdminPanelScreen

class DiseaseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Disease')),
      body: Column( // Use Column to hold the list and the button
        children: [
          Expanded( // Make the ListView take available space
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No doctors available yet.'));
                }

                Set<String> diseases = {};
                for (var doc in snapshot.data!.docs) {
                  final doctorData = doc.data() as Map<String, dynamic>;
                  if (doctorData.containsKey('specialization')) {
                    diseases.add(doctorData['specialization'] as String);
                  }
                }

                if (diseases.isEmpty) {
                  return const Center(child: Text('No specializations found.'));
                }

                return ListView(
                  children: diseases.map((disease) {
                    return ListTile(
                      title: Text(disease),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorListScreen(disease: disease),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the AdminPanelScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPanelScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Make button wider
              ),
              child: const Text('Go to Admin Panel'),
            ),
          ),
        ],
      ),
    );
  }
}