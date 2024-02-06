class Account {
  final String accountName;
  final String partnerCode;
  final String employerCode;
  final String companyType;
  final String role;
  final String contact;

  Account({
    required this.accountName,
    required this.partnerCode,
    required this.employerCode,
    required this.companyType,
    required this.role,
    required this.contact,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountName: json['accountname'],
      partnerCode: json['partnercode'],
      employerCode: json['employercode'],
      companyType: json['companytype'],
      role: json['role'],
      contact: json['contact'],
    );
  }
}
