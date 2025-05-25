import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor_list_screen.dart';
import 'admin_panel_screen.dart';
import 'sign_in_page.dart';
import 'my_appointments_screen.dart';

class DiseaseListScreen extends StatefulWidget {
  const DiseaseListScreen({super.key});

  @override
  State<DiseaseListScreen> createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen> {
  String _userName = 'Guest';
  String _userEmail = 'guest@example.com';
  String _userRole = 'user';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _userName = data['username'] ?? 'User';
            _userEmail = data['email'] ?? user.email ?? 'No Email';
            _userRole = data['role'] ?? 'user';
          });
        } else {
          setState(() {
            _userEmail = user.email ?? 'No Email';
            _userRole = 'user';
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
        setState(() {
          _userEmail = user.email ?? 'No Email';
          _userRole = 'user';
        });
      }
    } else {
      setState(() {
        _userName = 'Guest';
        _userEmail = 'guest@example.com';
        _userRole = 'guest';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Disease'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userName,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    _userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.blue,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('My Appointments'),
              leading: const Icon(Icons.calendar_today),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyAppointmentsScreen(),
                  ),
                );
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.blue,
              indent: 16,
              endIndent: 16,
            ),
            if (_userRole == 'admin')
              ListTile(
                title: const Text('Admin Panel'),
                leading: const Icon(Icons.admin_panel_settings),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPanelScreen(),
                    ),
                  );
                },
              ),
            if (_userRole == 'admin')
              const Divider(
                thickness: 1,
                color: Colors.blue,
                indent: 16,
                endIndent: 16,
              ),
            if (_userRole != 'admin')
              ListTile(
                title: const Text('Login as Admin'),
                leading: const Icon(Icons.login),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                        (route) => false,
                  );
                },
              ),
            if (_userRole != 'admin')
              const Divider(
                thickness: 1,
                color: Colors.blue,
                indent: 16,
                endIndent: 16,
              ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
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

                // --- START OF CHANGES FOR INTERACTIVITY ---
                return ListView(
                  padding: const EdgeInsets.all(8.0), // Add padding around the list
                  children: diseases.map((disease) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Margin between cards
                      elevation: 4, // Shadow for the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      child: InkWell( // Makes the entire card tappable with a ripple effect
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorListScreen(disease: disease),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12), // Matches Card's border radius
                        child: Padding(
                          padding: const EdgeInsets.all(16), // Padding inside the card
                          child: Row(
                            children: [
                              // You can add a relevant icon here. For now, a generic one.
                              Icon(Icons.medical_services, color: Theme.of(context).primaryColor, size: 30),
                              const SizedBox(width: 16.0),
                              Expanded( // Use Expanded to prevent text overflow in Row
                                child: Text(
                                  disease,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Ensure text truncates if too long
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Arrow indicator
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
                // --- END OF CHANGES FOR INTERACTIVITY ---
              },
            ),
          ),
          if (_userRole == 'admin')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPanelScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Go to Admin Panel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}