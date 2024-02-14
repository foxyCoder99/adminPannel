class ShareMail {
  final String accountcode;
  final String accountname;
  final String emailid;
  final String emailtype;
  bool fileshare;

  ShareMail({
    required this.accountcode,
    required this.accountname,
    required this.emailid,
    required this.emailtype,
    required this.fileshare,
  });

  factory ShareMail.fromJson(Map<String, dynamic> json) {
    return ShareMail(
      accountcode: json['accountcode'] ?? '',
      accountname: json['accountname'] ?? '',
      emailid: json['emailid'] ?? '',
      emailtype: json['emailtype'] ?? '',
      fileshare: json['fileshare'] ?? false,
    );
  }
}