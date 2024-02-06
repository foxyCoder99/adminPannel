class MenuAccess {
  final int id;
  final String menucode;
  final String menuname;
  final String rolecode;
  final String rolename;
  bool access;
  bool trxnaccess;

  MenuAccess({
    required this.id,
    required this.menucode,
    required this.menuname,
    required this.rolecode,
    required this.rolename,
    required this.access,
    required this.trxnaccess,
  });
  factory MenuAccess.fromJson(Map<String, dynamic> json) {
    return MenuAccess(
      id: json['id'] ?? 0,
      menucode: json['menucode'] ?? '',
      menuname: json['menuname'] ?? '',
      rolecode: json['rolecode'] ?? '',
      rolename: json['rolename'] ?? '',
      access: json['access'] ?? false,
      trxnaccess: json['trxnaccess'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'access': access ? '1' : '0',
      'trxnaccess': trxnaccess ? '1' : '0',
      "loggedinuser": "deepak",
    };
  }
}
