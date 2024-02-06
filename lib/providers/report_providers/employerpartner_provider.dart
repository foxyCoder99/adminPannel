import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/employerpartner_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';

class EmployerPartnerProvider extends ChangeNotifier {
  final List<EmployerPartner> _accountList = [];
  List<EmployerPartner> get accountList => _accountList;
  bool _isLoading = false;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool get isLoading => _isLoading;
  EmployerPartnerProvider() {
    fetchAccountDetailList();
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<EmployerPartner> get filteredEmployerList {
    return _accountList
        .where((account) =>
            account.accountname
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            account.role.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            account.companytype
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchAccountDetailList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminAccountEmployerPartner"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": "1"}),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);
        if (data is List) {
          _accountList.clear();
          _accountList.addAll(data.map((employerpartnerData) =>
              EmployerPartner.fromJson(employerpartnerData)));
          notifyListeners();
        } else {
          print(
              "Error parsing employerpartner list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching employerpartner list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching employerpartner list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    sheet.appendRow([
      const TextCellValue('accountname'),
      const TextCellValue('Account Name'),
      const TextCellValue('Company Type'),
      const TextCellValue('Role'),
      const TextCellValue('Contact'),
    ]);

    // Add data
    for (var report in accountList) {
      sheet.appendRow([
        TextCellValue(report.accountname),
        TextCellValue(report.companytype),
        TextCellValue(report.role),
        TextCellValue(report.contact),
      ]);
    }

    var filePath = '../Advisor/Excel_data.xlsx';
    excel.save(fileName: filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel file saved at: $filePath'),
      ),
    );
  }
}
