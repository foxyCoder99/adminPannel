class UnpaidInvoice {
  final String id;
  final String accountcode;
  final String fromdate;
  final String todate;
  final String status;
  final String loggedinuser;

  UnpaidInvoice({
    required this.id,
    required this.accountcode,
    required this.fromdate,
    required this.todate,
    required this.status,
    required this.loggedinuser,
  });
  factory UnpaidInvoice.fromJson(Map<String, dynamic> json) {
    return UnpaidInvoice(
      id: json['id'] ?? '',
      accountcode: json['accountcode'] ?? '',
      fromdate: json['fromdate'] ?? '',
      todate: json['todate'] ?? '',
      status: json['status'] ?? '',
      loggedinuser: json['loggedinuser'] ?? '',
    );
  }
}
