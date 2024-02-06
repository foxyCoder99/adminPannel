class Accountreport {
  final String accountname;
  final String employername;
  final String companytype;
  final String planeffectivedate;
  // final String contractsignatoryemail;
  final String createddate;

  Accountreport({
    required this.accountname,
    required this.employername,
    required this.companytype,
    required this.planeffectivedate,
    // required this.contractsignatoryemail,
    required this.createddate,
  });
  factory Accountreport.fromJson(Map<String, dynamic> json) {
    return Accountreport(
      accountname: json['accountname'] ?? '',
      employername: json['employername'] ?? '',
      companytype: json['companytype'] ?? '',
      planeffectivedate: json['planeffectivedate'] ?? '',
      // contractsignatoryemail: json['contractsignatoryemail'] ?? '',
      createddate: json['createddate'] ?? '',
    );
  }
}
