import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController(); // This data isn't saved to Firebase Auth directly
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // You might want to save username and mobile to Firestore here
        // For simplicity, we are just creating the user in Firebase Auth.

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
        Navigator.pop(context); // Go back to sign in page
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Sign up failed';
        if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Email is already in use';
        } else {
          errorMessage = e.message ?? 'An unknown error occurred';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email';
                    if (!value.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter password';
                    if (value.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Confirm your password'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(),
                    helperText: 'Optional', // Added helper text as it's not stored in Firebase Auth directly
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to sign in page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Sign In"),
                      ),
                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}