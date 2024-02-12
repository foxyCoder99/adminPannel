import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/accountreport_modal.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:advisorapp/constants.dart';

class AccountEmployerProvider extends ChangeNotifier {
  final List<Accountreport> _accountList = [];
  List<Accountreport> get accountList => _accountList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var fromDate = DateTime(2022, 1, 1);
  var toDate = DateTime(2024, 12, 1);
  var _searchQuery = '';

  AccountEmployerProvider() {
    fetchAccountEmployerList(fromDate, toDate);
  }

  String get searchQuery => _searchQuery;

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchAccountEmployerList(
      DateTime fromDate, DateTime toDate) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorAdminAccountEmployer"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fromdate": DateFormat('MM-dd-yyyy').format(fromDate),
          "todate": DateFormat('MM-dd-yyyy').format(toDate),
        }),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);
        if (data is List) {
          _accountList.clear();
          _accountList.addAll(
              data.map((accountData) => Accountreport.fromJson(accountData)));
          notifyListeners();
        } else {
          print("Error parsing account list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching account list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching account list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateDateRange(DateTime newFromDate, DateTime newToDate) {
    fromDate = newFromDate;
    toDate = newToDate;
    fetchAccountEmployerList(fromDate, toDate);
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    sheet.appendRow([
      const TextCellValue('Account Name'),
      const TextCellValue('Employer Name'),
      const TextCellValue('Company Type'),
      const TextCellValue('Plan Effective Date'),
      // const TextCellValue('Contract Signatory Email'),
      const TextCellValue('Created Date'),
    ]);

    // Add data
    for (var report in accountList) {
      sheet.appendRow([
        TextCellValue(report.accountname),
        TextCellValue(report.employername),
        TextCellValue(report.companytype),
        TextCellValue(report.planeffectivedate),
        // TextCellValue(report.contractsignatoryemail),
        TextCellValue(report.createddate),
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
