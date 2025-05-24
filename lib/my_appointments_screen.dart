import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // This line is correct and needed for date formatting

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Check if a user is logged in
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Appointments')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Please log in to view your appointments.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        backgroundColor: Colors.blue, // Consistent AppBar color
        foregroundColor: Colors.white, // Text color for AppBar title/icons
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Fetches appointments for the current user, ordered by date.
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: currentUser!.uid)
            .orderBy('appointmentDateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Error fetching appointments: ${snapshot.error}"); // For debugging
            return Center(child: Text('Error loading appointments.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You have no appointments scheduled yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          // Displays the list of appointments
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var appointmentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // Safely get data, providing 'N/A' if missing
              String doctorName = appointmentData['doctorName'] ?? 'Unknown Doctor';
              String specialization = appointmentData['specialization'] ?? 'N/A';
              Timestamp? appointmentTimestamp = appointmentData['appointmentDateTime'] as Timestamp?;

              // Format date and time
              String appointmentTime = 'Date not set';
              if (appointmentTimestamp != null) {
                DateTime dateTime = appointmentTimestamp.toDate();
                appointmentTime = DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
              }

              return Card(
                elevation: 3, // Simple shadow
                margin: const EdgeInsets.only(bottom: 12.0), // Space between cards
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Slightly rounded corners
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doctor: $doctorName',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Specialization: $specialization',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Time: $appointmentTime',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
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