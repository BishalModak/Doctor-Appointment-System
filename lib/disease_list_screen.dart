import 'package:flutter/material.dart';
import 'doctor_list_screen.dart';
import 'mock_data.dart';

class DiseaseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Select Disease')),
      body: ListView(
        children: diseaseDoctors.keys.map((disease) {
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
      ),
    );
  }
}