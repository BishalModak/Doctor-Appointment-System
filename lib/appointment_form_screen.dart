import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:firebase_auth/firebase_auth.dart';     // For current user UID
import 'my_appointments_screen.dart'; // Import My Appointments Screen

class AppointmentFormScreen extends StatefulWidget {
  final String doctorName;
  // Optional: Pass doctor's UID if you want to link appointments specifically to a doctor's profile
  // final String? doctorUid;

  AppointmentFormScreen({required this.doctorName, super.key}); // Added super.key

  @override
  _AppointmentFormScreenState createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController(); // Controller for date field

  String _name = '';
  String _phone = '';
  DateTime? _selectedDate; // Store the selected date as DateTime object

  @override
  void dispose() {
    _dateController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Set initial date
      firstDate: DateTime.now(), // Cannot select past dates
      lastDate: DateTime.now().add(const Duration(days: 30)), // Allow 5 years into the future
      helpText: 'Select Appointment Date',
      cancelText: 'Not Now',
      confirmText: 'Select',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color
            colorScheme: const ColorScheme.light(primary: Colors.blue, onPrimary: Colors.white), // Selected day/text color
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}"; // Format for display
      });
    }
  }

  // Function to submit appointment to Firestore
  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ensure a date is selected
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a preferred date.')),
        );
        return;
      }

      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to book an appointment.')),
        );
        return;
      }

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        await FirebaseFirestore.instance.collection('appointments').add({
          'userId': user.uid,
          'doctorName': widget.doctorName,
          'userName': _name,
          'userPhone': _phone,
          'appointmentDate': Timestamp.fromDate(_selectedDate!), // Store date as Timestamp
          'status': 'pending', // Initial status
          'createdAt': FieldValue.serverTimestamp(), // Timestamp of creation
        });

        // Dismiss loading indicator
        Navigator.pop(context);

        // Show success dialog
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Appointment Booked!'),
            content: Text(
              'Thank you $_name. Your appointment with ${widget.doctorName} on ${_dateController.text} is pending confirmation.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate to My Appointments screen, clear stack up to DiseaseListScreen
                  Navigator.popUntil(context, ModalRoute.withName('/')); // Pop to home
                  Navigator.push( // Then push My Appointments screen
                    context,
                    MaterialPageRoute(builder: (context) => const MyAppointmentsScreen()),
                  );
                },
                child: const Text('View My Appointments'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));// Pop to home screen
                  Navigator.push( // Then push My Appointments screen
                    context,
                    MaterialPageRoute(builder: (context) =>  AppointmentFormScreen(doctorName: '${widget.doctorName}',)),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Dismiss loading indicator in case of error
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: $e')),
        );
        print('Error booking appointment: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment with ${widget.doctorName}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              // Your Name field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person),
                ),
                onSaved: (val) => _name = val ?? '',
                validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),

              // Phone Number field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone, // Set keyboard type to phone
                onSaved: (val) => _phone = val ?? '',
                validator: (val) => val!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 20),

              // Preferred Date field with Calendar Picker
              TextFormField(
                controller: _dateController,
                readOnly: true, // Make it read-only
                decoration: InputDecoration(
                  labelText: 'Preferred Date',
                  hintText: 'Tap to select date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: const Icon(Icons.arrow_drop_down), // Dropdown icon
                ),
                onTap: () => _selectDate(context), // Open date picker on tap
                validator: (val) => _selectedDate == null ? 'Please select a date' : null,
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text(
                  'Submit Appointment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _submitAppointment, // Call the submit function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Consistent button color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}