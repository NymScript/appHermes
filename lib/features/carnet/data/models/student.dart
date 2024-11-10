class Student {
  final String dateBirth;
  final String bloodType;
  final String address;

  Student({
    required this.dateBirth,
    required this.bloodType,
    required this.address,
  });

  /// Converts JSON data into a Student object.
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      dateBirth:
          json['date_birth'] ?? 'N/A', // Matches JSON keys from the backend
      bloodType: json['blood_type'] ?? 'N/A',
      address: json['address'] ?? 'N/A',
    );
  }

  /// Converts a Student object to JSON for backend compatibility.
  Map<String, dynamic> toJson() {
    return {
      'date_birth': dateBirth, // Matches backend expected format
      'blood_type': bloodType,
      'address': address,
    };
  }
}
