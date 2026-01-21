class Vehicle {
  final String id;
  String type;
  String number;
  String fuelType;
  String? model;
  int? year;
  String? color;
  bool isDefault;

  Vehicle({
    required this.id,
    required this.type,
    required this.number,
    required this.fuelType,
    this.model,
    this.year,
    this.color,
    this.isDefault = false,
  });

  // Convert Vehicle object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'number': number,
      'fuelType': fuelType,
      'model': model,
      'year': year,
      'color': color,
      'isDefault': isDefault,
    };
  }

  // Create Vehicle object from Map
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] ?? '',
      type: map['type'] ?? 'Sedan',
      number: map['number'] ?? '',
      fuelType: map['fuelType'] ?? 'Petrol',
      model: map['model'],
      year: map['year'],
      color: map['color'],
      isDefault: map['isDefault'] ?? false,
    );
  }

  // Create a copy of the vehicle with updated fields
  Vehicle copyWith({
    String? id,
    String? type,
    String? number,
    String? fuelType,
    String? model,
    int? year,
    String? color,
    bool? isDefault,
  }) {
    return Vehicle(
      id: id ?? this.id,
      type: type ?? this.type,
      number: number ?? this.number,
      fuelType: fuelType ?? this.fuelType,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
