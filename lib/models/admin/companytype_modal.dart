class CompanyType {
  final int id;
  final String typename;
  final String typecode;
  final bool status;
  CompanyType({
    required this.id,
    required this.typename,
    required this.typecode,
    required this.status,
  });
  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(
      id: json['id'] ?? 0,
      typename: json['typename'] ?? '',
      typecode: json['typecode'] ?? '',
      status: json['status'] ?? false,
    );
  }
}
