import 'package:flutter/cupertino.dart';

class SidebarProvider extends ChangeNotifier {
  String _selectedMenu = 'Account';
  String get selectedMenu => _selectedMenu;
  String selectedReport = '';

  set selectedMenu(String obj) {
    _selectedMenu = obj;
    notifyListeners();
  }

  bool isMenuSelected(String menuName) {
    return _selectedMenu == menuName;
  }

  void setMenuSelected(String menuName) {
    _selectedMenu = menuName;
    notifyListeners();
  }
}
