class PaymentReport {
  final String invoicenumber;
  final String subscriptionname;
  final String accountname;
  final String emailid;
  final String companyname;
  final String paidamount;
  final String unitamount;
  final String paiddate;

  PaymentReport({
    required this.invoicenumber,
    required this.subscriptionname,
    required this.accountname,
    required this.emailid,
    required this.companyname,
    required this.paidamount,
    required this.unitamount,
    required this.paiddate,
  });
  factory PaymentReport.fromJson(Map<String, dynamic> json) {
    return PaymentReport(
      invoicenumber: json['invoicenumber'] ?? '',
      subscriptionname: json['subscriptionname'] ?? '',
      accountname: json['accountname'] ?? '',
      emailid: json['emailid'] ?? '',
      companyname: json['companyname'] ?? '',
      paidamount: json['paidamount'] ?? '',
      unitamount: json['unitamount'] ?? '',
      paiddate: json['paiddate'] ?? '',
    );
  }
}
