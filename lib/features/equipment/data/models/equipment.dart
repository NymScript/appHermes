class Equipment {
  final int? id;
  String? document;
  String brand;
  String model;
  String color;
  String serial;
  dynamic state;

  Equipment({
    this.id,
    this.document,
    required this.brand,
    required this.model,
    required this.color,
    required this.serial,
    required this.state,
  });

  // Convertir JSON a objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      brand: json['brand'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      serial: json['serial'] ?? 'N/A',
      state: json['state'] == true || json['state'] == "true", // bool en frontend
    );
  }

  // Convertir objeto Equipment a JSON para registrar
  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'brand': brand,
      'serial': serial,
      'model': model,
      'color': color,
      'state': state.toString(), // String en backend
    };
  }

  set setDocumentId(String idValue) {
    document = idValue;
  }
}
