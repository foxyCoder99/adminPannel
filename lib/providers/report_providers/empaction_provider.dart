import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:advisorapp/models/admin/report_modals/empaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/constants.dart';

class EmpActionProvider extends ChangeNotifier {
  List<Account> accounts = [];
  List<Account> _filteredAccounts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  EmpActionProvider() {
    fetchData();
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  set searchQuery(String value) {
    _searchQuery = value;
    _filterAccounts();
    notifyListeners();
  }

  List<Account> get filteredAccounts => _filteredAccounts;

  void _filterAccounts() {
    _filteredAccounts = accounts
        .where((account) =>
            account.accountName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            account.role.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            account.companyType
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
            '${webApiserviceURL}Advisor/ReadAdvisorAdminEmployeerwiseActionItem'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': '1'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        accounts = jsonData.map((item) => Account.fromJson(item)).toList();
        _filterAccounts(); 
        notifyListeners();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
