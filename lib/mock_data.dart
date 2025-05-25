// mock_data.dart
// This file will now primarily hold static data like specializations.
// Doctor data will be fetched from Firestore.

final Map<String, String> _specializations = {
  'Heart': 'Cardiologist',
  'Kidney': 'Nephrologist',
  'Skin': 'Dermatologist',
  'Eye': 'Ophthalmologist',
  'Diabetes': 'Endocrinologist',
  'Lungs': 'Pulmonologist',
  'Neurology': 'Neurologist',
  'Orthopedics': 'Orthopedic Surgeon',
  'Gastroenterology': 'Gastroenterologist',
  'ENT': 'ENT Specialist',
  'Dentistry': 'Dentist',
  'Psychiatry': 'Psychiatrist',
  'Pediatrics': 'Pediatrician',
  'Oncology': 'Oncologist',
  'Gynecology': 'Gynecologist',
  'Urology': 'Urologist',
  'Hematology': 'Hematologist',
  'Infectious Diseases': 'Infectious Disease Specialist',
  'Rheumatology': 'Rheumatologist',
  'Endocrinology': 'Endocrinologist',
  'Allergy & Immunology': 'Allergy & Immunology Specialist',
  'General Surgery': 'General Surgeon',
  'Hepatology': 'Hepatologist',
  'Pathology': 'Pathologist',
  'Radiology': 'Radiologist',
  'Plastic Surgery': 'Plastic Surgeon',
  'Dermatopathology': 'Dermatopathologist',
  'Anesthesiology': 'Anesthesiologist',
  'Pulmonology': 'Pulmonologist',
  'Neonatology': 'Neonatologist',
  'Cardiology': 'Cardiologist',
};

// Expose specializations for selection in the admin panel
List<String> getAllSpecializations() {
  return _specializations.keys.toList();
}

String getSpecializationName(String disease) {
  return _specializations[disease] ?? 'General Practitioner';
}