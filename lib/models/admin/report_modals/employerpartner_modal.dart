class EmployerPartner {
  final String accountname;
  final String partnercode;
  final String employercode;
  final String companytype;
  final String role;
  final String contact;

  EmployerPartner({
    required this.accountname,
    required this.partnercode,
    required this.employercode,
    required this.companytype,
    required this.role,
    required this.contact,
  });
  factory EmployerPartner.fromJson(Map<String, dynamic> json) {
    return EmployerPartner(
      accountname: json['accountname'] ?? '',
      partnercode: json['partnercode'],
      employercode: json['employercode'],
      companytype: json['companytype'],
      role: json['role'],
      contact: json['contact'],
    );
  }
}
