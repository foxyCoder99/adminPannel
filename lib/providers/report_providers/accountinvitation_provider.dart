import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/accountinvitation_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:advisorapp/constants.dart';

class AccountInvitationProvider extends ChangeNotifier {
  final List<AccountInvitation> _accountList = [];
  List<AccountInvitation> get accountList => _accountList;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  var fromDate = DateTime(2022, 1, 1);
  var toDate = DateTime(2023, 12, 1);
  String _searchTerm = '';

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  List<AccountInvitation> get filteredAccountList {
    if (_searchTerm.isEmpty) {
      return _accountList;
    } else {
      return _accountList.where((account) {
        return account.accountname
                .toLowerCase()
                .contains(_searchTerm.toLowerCase()) ||
            account.email.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }
  }

  AccountInvitationProvider() {
    fetchAccountDetailList(fromDate, toDate);
  }

  Future<void> fetchAccountDetailList(
      DateTime fromDate, DateTime toDate) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorAdminAccountInvitation"),
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
              data.map((account) => AccountInvitation.fromJson(account)));
          notifyListeners();
        } else {
          print(
              "Error parsing account invitation list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching account invitation list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching account invitation list: $e");
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
      const TextCellValue('Account Type'),
      const TextCellValue('Category Name'),
      const TextCellValue('Email'),
      const TextCellValue('Company Name'),
      const TextCellValue('NAICS'),
      const TextCellValue('Phone Number'),
      const TextCellValue('Company Type'),
      const TextCellValue('Invitation Status'),
      const TextCellValue('Joined Date'),
    ]);

    // Add data
    for (var report in filteredAccountList) {
      sheet.appendRow([
        TextCellValue(report.accountname),
        TextCellValue(report.accounttype),
        TextCellValue(report.categoryname),
        TextCellValue(report.email),
        TextCellValue(report.companyname),
        TextCellValue(report.naicscode),
        TextCellValue(report.phonenumber),
        TextCellValue(report.companytype),
        TextCellValue(report.invitationstatus),
        TextCellValue(report.joineddate),
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
