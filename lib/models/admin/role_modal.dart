
class Role {
  final int id;
  final String rolecode;
  final String rolename;
  final String userid;
  final bool status;
  Role({
    required this.id,
    required this.rolecode,
    required this.rolename,
    required this.userid,
    required this.status,
  });
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      rolecode: json['rolecode'] ?? '',
      rolename: json['rolename'] ?? '',
      userid: json['userid'] ?? '',
      status: json['status'] ?? false,
    );
  }
}
