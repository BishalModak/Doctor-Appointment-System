import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor_list_screen.dart';
import 'admin_panel_screen.dart'; // Import the AdminPanelScreen
import 'sign_in_page.dart'; // Import sign_in_page for logout navigation
import 'my_appointments_screen.dart'; // Import the My Appointments Screen

class DiseaseListScreen extends StatefulWidget {
  const DiseaseListScreen({super.key});

  @override
  State<DiseaseListScreen> createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen> {
  String _userName = 'Guest';
  String _userEmail = 'guest@example.com';
  // Removed _userRole as we're not using it for conditional display here

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data (name, email) from Firestore
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
          });
        } else {
          // If user document doesn't exist, use Firebase Auth email
          setState(() {
            _userEmail = user.email ?? 'No Email';
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
        // Fallback to Firebase Auth email if Firestore fetch fails
        setState(() {
          _userEmail = user.email ?? 'No Email';
        });
      }
    } else {
      // User is not logged in
      setState(() {
        _userName = 'Guest';
        _userEmail = 'guest@example.com';
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
          padding: EdgeInsets.zero, // Remove default ListView padding
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue, // Background color for the header
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white, // Background for the icon
                    child: Icon(
                      Icons.person, // Static "no photo" icon
                      size: 50,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userName,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    overflow: TextOverflow.ellipsis, // Ensures text truncates
                    maxLines: 1, // Ensures text stays on a single line
                  ),
                  Text(
                    _userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                    overflow: TextOverflow.ellipsis, // Ensures text truncates
                    maxLines: 1, // Ensures text stays on a single line
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation logic for home if needed
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.blue,
              indent: 16, // Indent for better visual
              endIndent: 16,
            ),
            ListTile(
              title: const Text('My Appointments'),
              leading: const Icon(Icons.calendar_today),
              onTap: () {
                Navigator.pop(context); // Close the drawer
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
            // Always show Admin Panel link in Drawer
            ListTile(
              title: const Text('Admin Panel'),
              leading: const Icon(Icons.admin_panel_settings),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPanelScreen(),
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
            // Always show Login as Admin button
            ListTile(
              title: const Text('Login as Admin'),
              leading: const Icon(Icons.login),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                      (route) => false, // Remove all routes from the stack
                );
              },
            ),
            const Divider( // Add divider after the button
              thickness: 1,
              color: Colors.blue,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                      (route) => false, // Remove all routes from the stack
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
          // --- NEW: Admin Panel Button at the bottom of the body ---


          // --- END NEW ---
        ],
      ),
    );
  }
}