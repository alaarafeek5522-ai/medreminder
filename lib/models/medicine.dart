class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String unit;
  final List<String> times;
  final List<bool> days;
  final String color;
  final String icon;
  bool isActive;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.times,
    required this.days,
    required this.color,
    required this.icon,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'unit': unit,
        'times': times,
        'days': days,
        'color': color,
        'icon': icon,
        'isActive': isActive,
      };

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        id: json['id'],
        name: json['name'],
        dosage: json['dosage'],
        unit: json['unit'],
        times: List<String>.from(json['times']),
        days: List<bool>.from(json['days']),
        color: json['color'],
        icon: json['icon'],
        isActive: json['isActive'] ?? true,
      );
}
