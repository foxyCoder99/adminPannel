
import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/accountactionitem_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:advisorapp/constants.dart';

class AccountActionItemProvider extends ChangeNotifier {
  final List<AccountActionItem> _accountList = [];
  List<AccountActionItem> get accountList => _accountList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var fromDate = DateTime(2022, 1, 1);
  var toDate = DateTime(2023, 12, 1);
  var _searchQuery = '';

  AccountActionItemProvider() {
    fetchAccountDetailList(fromDate, toDate);
  }

  String get searchQuery => _searchQuery;

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchAccountDetailList(
      DateTime fromDate, DateTime toDate) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorAdminAccountwiseActionItem"),
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
              data.map((account) => AccountActionItem.fromJson(account)));
          notifyListeners();
        } else {
          print(
              "Error parsing account ActionItem list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching account ActionItem list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching account ActionItem list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateDateRange(DateTime newFromDate, DateTime newToDate) {
    fromDate = newFromDate;
    toDate = newToDate;
    fetchAccountDetailList(fromDate, toDate);
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    sheet.appendRow([
      const TextCellValue('Account Name'),
      const TextCellValue('Item Name'),
      const TextCellValue('Launch'),
      const TextCellValue('Renewal'),
      const TextCellValue('Private'),
      const TextCellValue('Item Status'),
      const TextCellValue('Document Name'),
      const TextCellValue('Document View'),
    ]);

    // Add data
    for (var report in accountList) {
      sheet.appendRow([
        TextCellValue(report.accountname),
        TextCellValue(report.itemName),
        TextCellValue(report.launch),
        TextCellValue(report.renewal),
        TextCellValue(report.private),
        TextCellValue(report.itemStatus),
        TextCellValue(report.documentName),
        TextCellValue(report.documentView),
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
