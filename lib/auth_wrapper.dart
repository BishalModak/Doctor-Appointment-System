import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in_page.dart';
import 'disease_list_screen.dart';
import 'admin_panel_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<Widget> _getInitialScreen() async {
    User? user = FirebaseAuth.instance.currentUser;

    print("AuthWrapper: Current User: ${user?.uid}"); // DEBUG: Print UID

    if (user == null) {
      print("AuthWrapper: No user logged in, redirecting to SignInPage."); // DEBUG
      return const SignInPage();
    } else {
      print("AuthWrapper: User is logged in (${user.uid}), fetching role..."); // DEBUG
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String userRole = 'user'; // Default role
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;
          userRole = data['role'] ?? 'user';
          print("AuthWrapper: User role from Firestore: $userRole"); // DEBUG: Print fetched role
        } else {
          print("AuthWrapper: User document NOT found in Firestore!"); // DEBUG
        }

        if (userRole == 'admin') {
          print("AuthWrapper: User is admin, redirecting to AdminPanelScreen."); // DEBUG
          return const AdminPanelScreen();
        } else {
          print("AuthWrapper: User is NOT admin ($userRole), redirecting to DiseaseListScreen."); // DEBUG
          return const DiseaseListScreen();
        }
      } catch (e) {
        print("AuthWrapper: Error fetching user role on app start: $e"); // DEBUG: Print any errors
        return const DiseaseListScreen(); // Fallback
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}