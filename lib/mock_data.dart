final Map<String, List<Map<String, String>>> diseaseDoctors = {
  for (var disease in _diseaseNames)
    disease: List.generate(50, (index) => {
      'name': 'Dr. ${_doctorFirstNames[index % _doctorFirstNames.length]} ${_doctorLastNames[index % _doctorLastNames.length]}',
      'info': '${_specializations[disease]} | Experience: ${3 + (index % 10)} years',
    })
};

final List<String> _diseaseNames = [
  'Heart', 'Kidney', 'Skin', 'Eye', 'Diabetes', 'Lungs', 'Neurology', 'Orthopedics',
  'Gastroenterology', 'ENT', 'Dentistry', 'Psychiatry', 'Pediatrics', 'Oncology',
  'Gynecology', 'Urology', 'Hematology', 'Infectious Diseases', 'Rheumatology',
  'Endocrinology', 'Allergy & Immunology', 'General Surgery', 'Hepatology',
  'Pathology', 'Radiology', 'Plastic Surgery', 'Dermatopathology', 'Anesthesiology',
  'Pulmonology', 'Neonatology',
];

final List<String> _doctorFirstNames = [
  'Ahmed', 'Fatima', 'Rahman', 'Nabila', 'Imran', 'Sarah', 'Latif', 'Rima', 'Shafiq',
  'Nushrat', 'Karim', 'Mehreen', 'Tanveer', 'Saima', 'Rashed', 'Laila', 'Kamal',
  'Mou', 'Zaman', 'Rukhsana'
];

final List<String> _doctorLastNames = [
  'Khan', 'Hossain', 'Rahman', 'Begum', 'Ali', 'Hasan', 'Akter', 'Chowdhury',
  'Siddique', 'Banu'
];

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
};
