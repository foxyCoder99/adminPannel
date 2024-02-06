import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/models/admin/role_modal.dart';

class RoleProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController rolenameController = TextEditingController();
  final List<Role> _roleList = [];
  List<Role> get roleList => _roleList;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  String _editingRoleCode = '';

  bool _isFormVisible = false;
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  bool get isFormVisible => _isFormVisible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool validateRoleForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void resetForm() {
    _clearForm();
    setEditing(false);
  }

  RoleProvider() {
    fetchRoleList();
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setEditingRoleCode(String rolecode) {
    _editingRoleCode = rolecode;
  }

  List<Role> get filteredRoleList {
    return _roleList
        .where((role) =>
            role.rolename.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchRoleList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminRoleM"),
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
          _roleList.clear();
          _roleList.addAll(data.map((roleData) => Role.fromJson(roleData)));
          notifyListeners();
        } else {
          print("Error parsing role list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching role list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching role list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertAdvisorAdminrole(
    BuildContext context,
    String rolename,
  ) async {
    print({'insert rolename', rolename});
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/InsertAdvisorAdminRoleM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "rolename": rolename,
        "loggedinuser": "AC-20230111154731090",
      }),
    );
    if (response.statusCode == 200) {
      print("role added successfully");
    } else {
      print("Error adding role: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> updateAdvisorAdminrole(
      String rolename, String rolecode, bool status, String userid) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/UpdateAdvisorAdminRoleM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        {
          "rolename": rolename,
          "rolecode": rolecode,
          "status": status,
          "userid": userid,
        }
      }),
    );

    if (response.statusCode == 200) {
      print("role updated successfully");
    } else {
      print("Error updating role: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> deleteAdvisorAdminrole(String rolecode) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/DeleteAdvisorAdminRoleM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "rolecode": rolecode,
        }),
      );

      if (response.statusCode == 200) {
        print("role deleted successfully");
        _roleList.removeWhere((role) => role.rolecode == rolecode);
        notifyListeners();
      } else {
        print("Error deleting role: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error deleting role: $e");
    }
  }

  Future<void> saverole(BuildContext context) async {
    final newrole = Role(
      rolename: rolenameController.text,
      rolecode: _editingRoleCode,
      userid: 'AC-20230111154731090',
      status: false,
      id: 0,
    );

    if (isEditing) {
      final index =
          _roleList.indexWhere((role) => role.rolecode == newrole.rolecode);
      if (index != -1) {
        updaterole(newrole, index);

        await updateAdvisorAdminrole(
          newrole.rolename,
          newrole.rolecode,
          newrole.status,
          newrole.userid,
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("role Edited successfully."),
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
        roleList.any((e) => e.rolename == newrole.rolename)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("role name Already Exists."),
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
      await insertAdvisorAdminrole(
        context,
        newrole.rolename,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("role saved successfully."),
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
    fetchRoleList();
    resetForm();
  }

  void editRole(BuildContext context, Role role) {
    _isFormVisible = true;
    setEditing(true);
    setEditingRoleCode(role.rolecode);
    rolenameController.text = role.rolename;
    notifyListeners();
  }

  void updaterole(Role newrole, int index) {
    if (index >= 0 && index < _roleList.length) {
      _roleList[index] = newrole;

      _isFormVisible = false;
      updateAdvisorAdminrole(
        newrole.rolename,
        newrole.rolecode,
        newrole.status,
        newrole.userid,
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
    if (_roleList.isNotEmpty) {
      rolenameController.clear();
    }
  }

  void cancelroleForm(BuildContext context) {
    hideForm();
    _clearForm();
  }
}
