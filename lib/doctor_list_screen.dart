import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_detail_screen.dart';

class DoctorListScreen extends StatelessWidget {
  final String disease;

  DoctorListScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$disease Doctors')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .where('specialization', isEqualTo: disease)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No doctors found for this specialization.'));
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctorData = doctors[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(doctorData['name'] ?? 'No Name'),
                subtitle: Text(doctorData['info'] ?? 'No Info'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailScreen(
                      doctor: {
                        'name': doctorData['name'],
                        'info': doctorData['info'],
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}