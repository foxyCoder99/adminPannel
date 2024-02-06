class User {
  // final int id;
  // final String userloginid;
  // final String loginpassword;
  final String rolecode;
  final String rolename;
  final String usercode;
  final String firstname; 
  final String lastname;
  final dynamic username; 
  final String emailid;
  // final bool status;
  // final DateTime createddate;
  // final String createdby;
  // final DateTime? modifieddate; 
  // final String? modifiedBy; 
  User({
    // required this.id,
    // required this.userloginid,
    // required this.loginpassword,
    required this.rolecode,
    required this.rolename,
    required this.usercode,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.emailid,
    // required this.status,
    // required this.createddate,
    // required this.createdby,
    // required this.modifieddate,
    // required this.modifiedBy,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // id: json['id'] ?? 0,
      // userloginid: json['userloginid'] ?? '',
      // loginpassword: json['loginpassword'] ?? '',
      rolecode: json['rolecode'] ?? '',
      rolename: json['rolename'] ?? '',
      usercode: json['usercode'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      username: (json['username'] is String)
          ? json['username']
          : (json['username'] is Map)
              ? (json['username'].isNotEmpty
                      ? json['username']['your_key']
                      : '')
                  .toString()
              : '',
      emailid: json['emailid'] ?? '',
      // status: json['status'] ?? false,
      // createddate:
      //     DateTime.tryParse(json['createddate'] ?? '') ?? DateTime.now(),
      // createdby: json['createdby'] ?? '',
      // modifieddate: DateTime.tryParse(json['modifieddate'] ?? ''),
      // modifiedBy: json['modifiedBy'] ?? '',
    );
  }
}

