import 'dart:convert';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/report_modals/reporttable_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends ChangeNotifier {
  List<Account> _data = [];

  List<Account> get data => _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReportProvider() {
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            '${webApiserviceURL}Advisor/ReadAdvisorAdminAccountEmployerPartner'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "1"}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          _data = data.map<Account>((data) => Account.fromJson(data)).toList();
          notifyListeners();
        } else {
          print("Error parsing advisor data : $data");
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
