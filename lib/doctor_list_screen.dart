import 'package:flutter/material.dart';
import 'doctor_detail_screen.dart';
import 'mock_data.dart';

class DoctorListScreen extends StatelessWidget {
  final String disease;

  DoctorListScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    final doctors = diseaseDoctors[disease]!;

    return Scaffold(
      appBar: AppBar(title: Text('$disease Doctors')),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            title: Text(doctor['name']!),
            subtitle: Text(doctor['info']!),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDetailScreen(doctor: doctor),
              ),
            ),
          );
        },
      ),
    );
  }
}
