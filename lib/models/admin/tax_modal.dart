class Tax {
  final int id;
  String taxName;
  double taxValue;
  final bool status;
  final DateTime createDdate;
  final String createdBy;
  final DateTime? modifiedDate; // Update to DateTime?
  final String? modifiedBy; // Update to String?

  Tax({
    required this.id,
    required this.taxName,
    required this.taxValue,
    required this.status,
    required this.createDdate,
    required this.createdBy,
    required this.modifiedDate,
    required this.modifiedBy,
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      id: json['id'],
      taxName: json['taxName'],
      taxValue: json['taxValue'],
      status: json['status'],
      createDdate: DateTime.parse(json['createDdate']),
      createdBy: json['createdBy'],
      modifiedDate: json['modifiedDate'] != null &&
              json['modifiedDate'] is String &&
              json['modifiedDate'].isNotEmpty
          ? DateTime.parse(json['modifiedDate'])
          : null,
      modifiedBy: json['modifiedBy'] != null &&
              json['modifiedBy'] is String &&
              json['modifiedBy'].isNotEmpty
          ? json['modifiedBy']
          : null,
    );
  }
}
