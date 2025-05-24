import 'package:flutter/material.dart';

class AppointmentFormScreen extends StatefulWidget {
  final String doctorName;

  AppointmentFormScreen({required this.doctorName});

  @override
  _AppointmentFormScreenState createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', phone = '', date = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment with ${widget.doctorName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your Name'),
                onSaved: (val) => name = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onSaved: (val) => phone = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter phone' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Preferred Date'),
                onSaved: (val) => date = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter date' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                        title: const Text('Appointment Booked'),
                        content: Text(
                          'Thank you $name. Your appointment with ${widget.doctorName} is confirmed.',
                        ),
                        actions: [
                          TextButton(
                            onPressed:
                                () => Navigator.popUntil(
                              context,
                                  (route) => route.isFirst,
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}