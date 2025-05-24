import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data.dart'; // Import mock_data for specializations

class AdminDoctorFormScreen extends StatefulWidget {
  final String? doctorId; // Null for new doctor, ID for editing
  final Map<String, dynamic>? initialData; // Data for editing

  AdminDoctorFormScreen({this.doctorId, this.initialData});

  @override
  _AdminDoctorFormScreenState createState() => _AdminDoctorFormScreenState();
}

class _AdminDoctorFormScreenState extends State<AdminDoctorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  String? _selectedSpecialization;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _infoController.text = widget.initialData!['info'] ?? '';
      _selectedSpecialization = widget.initialData!['specialization'];
    }
  }

  Future<void> _saveDoctor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final doctorData = {
        'name': _nameController.text.trim(),
        'info': _infoController.text.trim(),
        'specialization': _selectedSpecialization,
      };

      try {
        if (widget.doctorId == null) {
          // Add new doctor
          await FirebaseFirestore.instance.collection('doctors').add(doctorData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor added successfully!')),
          );
        } else {
          // Update existing doctor
          await FirebaseFirestore.instance.collection('doctors').doc(widget.doctorId).update(doctorData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor updated successfully!')),
          );
        }
        Navigator.pop(context); // Go back to admin panel
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save doctor: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctorId == null ? 'Add New Doctor' : 'Edit Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSpecialization,
                decoration: const InputDecoration(
                  labelText: 'Specialization',
                  border: OutlineInputBorder(),
                ),
                items: getAllSpecializations().map((String specialization) {
                  return DropdownMenuItem<String>(
                    value: specialization,
                    child: Text(specialization),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSpecialization = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a specialization';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _infoController,
                decoration: const InputDecoration(labelText: 'Doctor Info (e.g., Experience)'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor\'s info';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _saveDoctor,
                child: Text(widget.doctorId == null ? 'Add Doctor' : 'Update Doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}