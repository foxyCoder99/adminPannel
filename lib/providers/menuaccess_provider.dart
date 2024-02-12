import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/models/admin/menuaccess_modal.dart';
import 'package:advisorapp/constants.dart';

class MenuAccessProvider extends ChangeNotifier {
  String selectedRoleCode = '';
  String selectedUserRole = '';
  final List<String> userRoles = [];
  final List<String> _userRoleCode = [];
  final List<MenuAccess> _menuList = [];
  List<MenuAccess> updatedMenus = [];

  List<MenuAccess> checkedMenus = [];
  List<MenuAccess> get menuList => _menuList;
  List<String> get userRoleCode => _userRoleCode;

  bool _isUpdateBtn = false;
  bool get isUpdateBtn => _isUpdateBtn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  MenuAccessProvider() {
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      _isLoading = true;
      notifyListeners();
      final roleResponse = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorAdminRoleM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "1"}),
      );

      if (roleResponse.statusCode == 200) {
        final roleData = jsonDecode(roleResponse.body);
        if (roleData is List) {
          for (var element in roleData) {
            _userRoleCode.addAll([element["rolecode"]]);
            userRoles.addAll([element["rolename"]]);
          }
          if (userRoles.isNotEmpty) {
            setSelectedRole();
          }
        } else {
          print("Error parsing role list. Expected a list, but got: $roleData");
        }
      } else {
        print("Error fetching role list: ${roleResponse.statusCode}");
        print("Response body: ${roleResponse.body}");
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching role list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenuAccess(String roleCode) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorAdminMenuAccess"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"rolecode": roleCode, "status": "1"}),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);

        if (data is List) {
          _menuList.clear();
          _menuList
              .addAll(data.map((menuData) => MenuAccess.fromJson(menuData)));
          notifyListeners();
        } else {
          print("Error parsing menu list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching menu list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching menu list: $e");
    }
  }

  Future<void> updateMenuAccess(
      BuildContext context, List<MenuAccess> menus) async {
    try {
      final List menuList = menus.map((menu) => menu.toJson()).toList();

      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/UpdateAdvisorAdminMenuAccess"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(menuList),
      );

      if (response.statusCode == 200) {
        print("${response.body} : Menu access updated successfully");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Menu access updated successfully."),
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
        print("Error updating menu access: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error updating menu access: $e");
    }
  }

  void setSelectedRole() {
    if (selectedUserRole == '') {
      selectedUserRole = userRoles.isNotEmpty ? userRoles.first : '';
    }
    final userRolesIndex = userRoles.indexOf(selectedUserRole);

    if (userRolesIndex != -1 && userRolesIndex < userRoleCode.length) {
      selectedRoleCode = userRoleCode[userRolesIndex];
      fetchMenuAccess(selectedRoleCode);
      notifyListeners();
    } else {
      print('Error: Invalid index when setting selected role');
    }
    _isUpdateBtn = true;
  }

  void updateCheckedMenus(BuildContext context) {
    try {
      updateMenuAccess(context, updatedMenus);
      updatedMenus.clear();
    } catch (e) {
      print("Error updating checked menus: $e");
    }
  }

  void updateViewAccess(
    MenuAccess menu,
    bool value,
  ) {
    menu.access = value;
    if (value) {
      updatedMenus.add(menu);
    } else {
      updatedMenus.remove(menu);
    }
    notifyListeners();
  }

  void updatetrxnaccess(
    MenuAccess menu,
    bool value,
  ) {
    menu.trxnaccess = value;
    if (value) {
      updatedMenus.add(menu);
    } else {
      updatedMenus.remove(menu);
    }
    notifyListeners();
  }
}
