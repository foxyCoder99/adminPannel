class AccountInvitation {
  final String accountname;
  final String accounttype;
  final String categoryname;
  final String email;
  final String companyname;
  final String naicscode;
  final String phonenumber;
  final String companytype;
  final String invitationstatus;
  final String joineddate;

  AccountInvitation({
    required this.accountname,
    required this.accounttype,
    required this.categoryname,
    required this.email,
    required this.companyname,
    required this.naicscode,
    required this.phonenumber,
    required this.companytype,
    required this.invitationstatus,
    required this.joineddate,
  });
  factory AccountInvitation.fromJson(Map<String, dynamic> json) {
    return AccountInvitation(
      accountname: json['accountname'] ?? '',
      accounttype: json['accounttype'] ?? '',
      categoryname: json['categoryname'] ?? '',
      email: json['email'] ?? '',
      companyname: json['companyname'] ?? '',
      naicscode: json['naicscode'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      companytype: json['companytype'] ?? '',
      invitationstatus: json['invitationstatus'] ?? '',
      joineddate: json['joineddate'] ?? '',
    );
  }
}
