import 'package:flutter/material.dart';
import 'appointment_form_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  // Keeping Map<String, dynamic> for flexibility, even if values are currently strings.
  final Map<String, dynamic> doctor;

  DoctorDetailScreen({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    final String doctorName = doctor['name'] ?? 'Doctor Name';
    final String specialization = doctor['specialization'] ?? 'General Practitioner';
    final String info = doctor['info'] ?? 'No detailed information available.';
    final String? phoneNumber = doctor['phone_number'];
    final String? address = doctor['address'];
    final String? workingHours = doctor['working_hours'];
    // Removed 'rating' variable as it's no longer used.

    return Scaffold(
      appBar: AppBar(
        title: Text(doctorName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView( // Still good to keep for content that might overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Header Section (Prominent Name and Specialization)
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.local_hospital, // Icon for doctor
                        size: 70,
                        color: Colors.blue.shade700,
                      ),
                      // Remove backgroundImage if you don't have doctor images
                    ),
                    const SizedBox(height: 16),
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Removed rating stars
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // About Doctor Section (using Card for visual grouping)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Doctor',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const Divider(height: 16, thickness: 1),
                      Text(
                        info,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),

              // Contact Information Section (just displaying text, no interactive calls)
              if (phoneNumber != null || address != null || workingHours != null)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact & Location',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                        const Divider(height: 16, thickness: 1),
                        if (phoneNumber != null)
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.green),
                            title: Text(phoneNumber),
                            dense: true,
                          ),
                        if (address != null)
                          ListTile(
                            leading: const Icon(Icons.location_on, color: Colors.red),
                            title: Text(address),
                            dense: true,
                          ),
                        if (workingHours != null)
                          ListTile(
                            leading: const Icon(Icons.access_time, color: Colors.purple),
                            title: Text(workingHours),
                            dense: true,
                          ),
                      ],
                    ),
                  ),
                ),

              //SizedBox(height: 50,),

              // Book Appointment Button (Styled)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentFormScreen(
                          doctorName: doctorName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}