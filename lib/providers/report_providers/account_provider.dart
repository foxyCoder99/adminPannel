// account_provider.dart
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/accountdetail_model.dart';
import 'package:intl/intl.dart';

class AccountProvider extends ChangeNotifier {
  final List<Account> _accountList = [];
  List<Account> get accountList => _accountList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var fromDate = DateTime(2022, 1, 1);
  var toDate = DateTime(2023, 12, 1);
  var _searchQuery = '';

  AccountProvider() {
    fetchAccounts(fromDate, toDate);
  }

  String get searchQuery => _searchQuery;

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Account> get filteredAccounts {
    return _accountList
        .where((account) =>
            account.accountName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            account.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            account.companyName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchAccounts(DateTime fromDate, DateTime toDate) async {
    try {
      _isLoading = true;
      notifyListeners();
      const url =
          'https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminAccountDetail';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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
          _accountList
              .addAll(data.map((accountData) => Account.fromJson(accountData)));
          notifyListeners();
        } else {
          print("Error parsing account list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching account list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch accounts');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateDateRange(DateTime newFromDate, DateTime newToDate) {
    fromDate = newFromDate;
    toDate = newToDate;
    fetchAccounts(fromDate, toDate);
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Account Data'];
    // Add header row
    sheet.appendRow([
      const TextCellValue('Account Name'),
      const TextCellValue('Account Type'),
      const TextCellValue('Category Name'),
      const TextCellValue('Email'),
      const TextCellValue('NAICS'),
      const TextCellValue('Phone Number'),
      const TextCellValue('Company Type'),
      const TextCellValue('Company Name'),
      const TextCellValue('Joined Date'),
    ]);

    // Add data rows
    for (var account in accountList) {
      sheet.appendRow([
        TextCellValue(account.accountName),
        TextCellValue(account.accountType),
        TextCellValue(account.categoryName),
        TextCellValue(account.email),
        TextCellValue(account.naicsCode),
        TextCellValue(account.phoneNumber),
        TextCellValue(account.companyType),
        TextCellValue(account.companyName),
        TextCellValue(account.joinedDate.toString()),
      ]);
    }
    var filePath = '../flutterproject/advsoradmin/account_data.xlsx';
    excel.save(fileName: filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel file saved at: $filePath'),
      ),
    );
  }
}
