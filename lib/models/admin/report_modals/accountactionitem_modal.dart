class AccountActionItem {
  final String accountname;
  final String itemName;
  final String launch;
  final String renewal;
  final String private;
  final String itemStatus;
  final String documentName;
  final String documentView;

  AccountActionItem({
    required this.accountname,
    required this.itemName,
    required this.launch,
    required this.renewal,
    required this.private,
    required this.itemStatus,
    required this.documentName,
    required this.documentView,
  });
  factory AccountActionItem.fromJson(Map<String, dynamic> json) {
    return AccountActionItem(
      accountname: json['accountname'] ?? '',
      itemName: json['itemName'] ?? '',
      launch: json['launch'] ?? '',
      renewal: json['renewal'] ?? '',
      private: json['private'] ?? '',
      itemStatus: json['itemStatus'] ?? '',
      documentName: json['documentName'] ?? '',
      documentView: json['documentView'] ?? '',
    );
  }
}
