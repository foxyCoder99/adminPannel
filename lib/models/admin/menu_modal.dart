class Menu {
  final int id;
  final String menucode;
  final String menuname;
  final bool status;
  Menu({
    required this.id,
    required this.menucode,
    required this.menuname,
    required this.status,
  });
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? 0,
      menucode: json['menucode'] ?? '',
      menuname: json['menuname'] ?? '',
      status: json['status'] ?? false,
    );
  }
}
