import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/models/admin/menu_modal.dart';

class MenuProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController menunameController = TextEditingController();
  final List<Menu> _menuList = [];
  List<Menu> get menuList => _menuList;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  String _editingmenuCode = '';

  bool _isFormVisible = false;
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  bool get isFormVisible => _isFormVisible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool validatemenuForm() {
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

  MenuProvider() {
    fetchmenuList();
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setEditingmenuCode(String menucode) {
    _editingmenuCode = menucode;
  }

  List<Menu> get filteredmenuList {
    return _menuList
        .where((menu) =>
            menu.menuname.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchmenuList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminMenuM"),
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
          _menuList.clear();
          _menuList.addAll(data.map((menuData) => Menu.fromJson(menuData)));
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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertAdvisorAdminmenu(
    BuildContext context,
    String menuname,
  ) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/InsertAdvisorAdminMenuM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "menuname": menuname,
        "loggedinuser": "adminUser",
      }),
    );
    if (response.statusCode == 200) {
      print("menu added successfully");
    } else {
      print("Error adding menu: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> updateAdvisorAdminmenu(String menuname, String menucode) async {
    print({'Update menuname', menuname, menucode});
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/UpdateAdvisorAdminMenuM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "menucode": menucode,
        "menuname": menuname,
        "loggedinuser": "adminUser",
      }),
    );

    if (response.statusCode == 200) {
      print("menu updated successfully");
    } else {
      print("Error updating menu: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> deleteAdvisorAdminmenu(String id) async {
    print({'delete menu api', id});
    try {
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/DeleteAdvisorAdminMenuM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
        }),
      );

      if (response.statusCode == 200) {
        print("menu deleted successfully");
        _menuList.removeWhere((menu) => menu.id.toString() == id);
        notifyListeners();
      } else {
        print("Error deleting menu: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error deleting menu: $e");
    }
  }

  Future<void> savemenu(BuildContext context) async {
    final newmenu = Menu(
      menuname: menunameController.text,
      menucode: _editingmenuCode,
      status: false,
      id: 0,
    );

    if (isEditing) {
      final index =
          _menuList.indexWhere((menu) => menu.menucode == newmenu.menucode);
      if (index != -1) {
        updatemenu(newmenu, index);

        await updateAdvisorAdminmenu(
          newmenu.menuname,
          newmenu.menucode,
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("menu Edited successfully."),
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
        menuList.any((e) => e.menuname == newmenu.menuname)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("menu name Already Exists."),
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
      await insertAdvisorAdminmenu(
        context,
        newmenu.menuname,
      );
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("menu saved successfully."),
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
    fetchmenuList();
    resetForm();
  }

  void editmenu(BuildContext context, Menu menu) {
    print({'menucpde -- ', menu.menucode});
    _isFormVisible = true;
    setEditing(true);
    setEditingmenuCode(menu.menucode);
    menunameController.text = menu.menuname;
    notifyListeners();
  }

  void updatemenu(Menu newmenu, int index) {
    if (index >= 0 && index < _menuList.length) {
      _menuList[index] = newmenu;

      _isFormVisible = false;
      updateAdvisorAdminmenu(
        newmenu.menuname,
        newmenu.menucode,
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
    if (_menuList.isNotEmpty) {
      menunameController.clear();
    }
  }

  void cancelmenuForm(BuildContext context) {
    hideForm();
    _clearForm();
  }
}
