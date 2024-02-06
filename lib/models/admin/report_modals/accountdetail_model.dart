class Account {
  String accountName;
  String accountType;
  String categoryName;
  String email;
  String naicsCode;
  String phoneNumber;
  String companyName;
  String companyType;
  String joinedDate;

  Account({
    required this.accountName,
    required this.accountType,
    required this.categoryName,
    required this.email,
    required this.naicsCode,
    required this.phoneNumber,
    required this.companyName,
    required this.companyType,
    required this.joinedDate,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountName: json['accountname'] ?? '',
      accountType: json['accounttype'] ?? '',
      categoryName: json['categoryname'] ?? '',
      email: json['email'] ?? '',
      naicsCode: json['naicscode'] ?? '',
      phoneNumber: json['phonenumber'] ?? '',
      companyName: json['companyname'] ?? '',
      companyType: json['companytype'] ?? '',
      joinedDate: json['joineddate'] ?? '',
    );
  }
}
