import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/models/admin/user_modal.dart';

class UserProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final List<String> userRoles = [];
  final List<String> _userRoleCode = [];
  final List<User> _userList = [];

  List<String> get userRoleCode => _userRoleCode;
  List<User> get userList => _userList;

  String selectedUserRole = '';
  String _editingUserCode = '';
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  bool _isFormVisible = false;
  bool _isEditing = false;

  bool get isEditing => _isEditing;
  bool get isFormVisible => _isFormVisible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool validateUserForm() {
    return formKey.currentState?.validate() ?? false;
  }

  UserProvider() {
    fetchUserList();
    if (userRoles.isNotEmpty) {
      selectedUserRole = userRoles.first;
    }
  }
  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void resetForm() {
    _clearForm();
    setEditing(false);
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  void setEditingUserCode(String usercode) {
    _editingUserCode = usercode;
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<User> get filteredUserList {
    return _userList
        .where((user) =>
            user.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.emailid.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.rolename.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchUserList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminUserM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "status": "1",
        }),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);
        if (data is List) {
          _userList.clear();
          _userList.addAll(data.map((userData) => User.fromJson(userData)));

          final roleResponse = await http.post(
            Uri.parse(
                "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminRoleM"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "status": "1",
            }),
          );

          if (roleResponse.statusCode == 200) {
            final roleData = jsonDecode(roleResponse.body);
            if (roleData is List) {
              for (var element in roleData) {
                _userRoleCode.addAll([element["rolecode"]]);
                userRoles.addAll([element["rolename"]]);
              }
            } else {
              print(
                  "Error parsing role list. Expected a list, but got: $roleData");
            }
          } else {
            print("Error fetching role list: ${roleResponse.statusCode}");
            print("Response body: ${roleResponse.body}");
          }
          notifyListeners();
        } else {
          print("Error parsing user list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching user list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching user list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertAdvisorAdminUser(
    BuildContext context,
    String firstname,
    String lastname,
    String emailId,
    String roleCode,
  ) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/InsertAdvisorAdminUserM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstname": firstname,
        "lastname": lastname,
        "emailid": emailId,
        "rolecode": roleCode,
        "loggedinuser": "AC-20230111154731090",
        // "loggedinuser": "admin"
      }),
    );
    if (response.statusCode == 200) {
      // final jsonResponse = json.decode(response.body);
      // if (jsonResponse['response'] == "User EmailId already exists") {
      //   // Show an alert with the error message
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: const Text("Alert"),
      //         content: Text(jsonResponse['response']),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: const Text("OK"),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // } else {
      // }
      print("User added successfully");
    } else {
      print("Error adding user: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> updateAdvisorAdminUser(String firstname, String lastname,
      String emailId, String roleCode, String userCode) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/UpdateAdvisorAdminUserM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usercode": userCode,
        "firstname": firstname,
        "lastname": lastname,
        "rolecode": roleCode,
        "loggedinuser": "AC-20230111154731090",
      }),
    );

    if (response.statusCode == 200) {
      print("User updated successfully");
    } else {
      print("Error updating user: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> deleteAdvisorAdminUser(String userCode) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/DeleteAdvisorAdminUserM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usercode": userCode,
        }),
      );

      if (response.statusCode == 200) {
        print("User deleted successfully");
        _userList.removeWhere((user) => user.usercode == userCode);
        notifyListeners();
      } else {
        print("Error deleting user: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> saveUser(BuildContext context) async {
    if (selectedUserRole == '') {
      selectedUserRole = userRoles.isNotEmpty ? userRoles.first : '';
    }
    final newUser = User(
      // userloginid: '',
      usercode: _editingUserCode,
      // createdby: '',
      // createddate: DateTime.now(),
      // modifiedBy: '',
      // modifieddate: DateTime.now(),
      firstname: firstnameController.text,
      lastname: lastnameController.text,
      username: '',
      emailid: emailIdController.text,
      rolename: selectedUserRole,
      rolecode: userRoleCode[userRoles.indexOf(selectedUserRole)],
      // loginpassword: '',
      // status: true,
      // id: 0,
    );

    if (isEditing) {
      final index =
          _userList.indexWhere((user) => user.emailid == newUser.emailid);
      if (index != -1) {
        updateUser(newUser, index);

        await updateAdvisorAdminUser(
          newUser.firstname,
          newUser.lastname,
          newUser.emailid,
          newUser.rolecode,
          newUser.usercode,
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("User Edited successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else if (!isEditing &&
        userList.any((e) => e.emailid == newUser.emailid)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("User EmailId Already Exists."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      print('insert');
      await insertAdvisorAdminUser(
        context,
        newUser.firstname,
        newUser.lastname,
        newUser.emailid,
        newUser.rolecode,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("User saved successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

    hideForm();
    fetchUserList();
    resetForm();
  }

  // void addUser(User user) {
  //   print({"adduser function"});
  //   _userList.add(user);
  //   _isFormVisible = false;
  //   setEditing(false);
  //   // insertAdvisorAdminUser(
  //   //     user.firstname, user.lastname, user.emailid, user.rolecode);
  //   notifyListeners();
  // }

  void editUser(BuildContext context, User user) {
    _isFormVisible = true;
    setEditing(true);
    setEditingUserCode(user.usercode);
    firstnameController.text = user.firstname;
    lastnameController.text = user.lastname;
    emailIdController.text = user.emailid;
    selectedUserRole = user.rolename;
    notifyListeners();
  }

  void updateUser(User newUser, int index) {
    if (index >= 0 && index < _userList.length) {
      _userList[index] = newUser;

      _isFormVisible = false;
      updateAdvisorAdminUser(
        newUser.firstname,
        newUser.lastname,
        newUser.emailid,
        newUser.rolecode,
        newUser.usercode,
      );
      notifyListeners();
    }
  }

  void showForm() {
    _isFormVisible = true;
    notifyListeners();
  }

  void hideForm() {
    _isFormVisible = false;
    notifyListeners();
  }

  void _clearForm() {
    if (userRoles.isNotEmpty) {
      selectedUserRole = userRoles.first;
    }
    if (_userList.isNotEmpty) {
      firstnameController.clear();
      lastnameController.clear();
      emailIdController.clear();
    }
  }

  void cancelUserForm(BuildContext context) {
    hideForm();
    _clearForm();
  }
}
