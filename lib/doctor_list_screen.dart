import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_detail_screen.dart';

class DoctorListScreen extends StatelessWidget {
  final String disease;

  DoctorListScreen({required this.disease, super.key}); // Added super.key for best practice

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$disease Doctors'),
        backgroundColor: Colors.blue, // Consistent AppBar color
        foregroundColor: Colors.white, // Text color for AppBar title
      ),
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
            return const Center(child: Text(
              'No doctors found for this specialization yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ));
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0), // Padding around the list of cards
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctorData = doctors[index].data() as Map<String, dynamic>;

              // --- START OF CHANGES FOR INTERACTIVITY ---
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                elevation: 5.0, // A bit more shadow for depth
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // More rounded corners
                ),
                child: InkWell( // Makes the entire card tappable with a ripple effect
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailScreen(
                        doctor: {
                          'name': doctorData['name'],
                          'info': doctorData['info'],
                          // You might want to pass more doctor data here for the detail screen
                          // For example, 'specialization': doctorData['specialization'],
                          // 'image_url': doctorData['image_url'], etc.
                        },
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(15.0), // Matches Card's border radius
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Inner padding for content
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
                      children: [
                        // Doctor Profile Picture/Avatar (Placeholder)
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.shade100, // Light blue background
                          child: Icon(
                            Icons.person, // Generic person icon
                            size: 35,
                            color: Colors.blue.shade700,
                          ),
                          // If you had an image URL for doctors:
                          // backgroundImage: doctorData['image_url'] != null
                          //     ? NetworkImage(doctorData['image_url'])
                          //     : null,
                        ),
                        const SizedBox(width: 16.0), // Space between avatar and text

                        // Doctor Name and Info
                        Expanded( // Allows text to take available space
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                            children: [
                              Text(
                                doctorData['name'] ?? 'Doctor Name',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                doctorData['info'] ?? 'No additional information.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey.shade700,
                                ),
                                maxLines: 2, // Allow info to wrap up to 2 lines
                                overflow: TextOverflow.ellipsis,
                              ),
                              // You could add more details here like:
                              // if (doctorData.containsKey('hospital'))
                              //   Text('Hospital: ${doctorData['hospital']}', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              // if (doctorData.containsKey('rating'))
                              //   Row(
                              //     children: List.generate(5, (starIndex) => Icon(
                              //       starIndex < (doctorData['rating'] ?? 0).round() ? Icons.star : Icons.star_border,
                              //       color: Colors.amber,
                              //       size: 16,
                              //     )),
                              //   ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0), // Space before arrow
                        // Navigation Arrow
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blueGrey,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // --- END OF CHANGES FOR INTERACTIVITY ---
            },
          );
        },
      ),
    );
  }
}