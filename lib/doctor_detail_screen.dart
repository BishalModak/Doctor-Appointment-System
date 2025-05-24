import 'package:flutter/material.dart';
import 'appointment_form_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Map<String, String> doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor['name']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor['info']!, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                child: const Text('Book Appointment'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentFormScreen(
                        doctorName: doctor['name']!,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}