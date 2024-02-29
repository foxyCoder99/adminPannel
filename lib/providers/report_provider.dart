import 'dart:convert';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/report_modals/reporttable_modal.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends ChangeNotifier {
  List<Account> _data = [];
  bool _isLoading = false;

  String _searchQuery = '';

  List<Account> get data => _data;

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

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

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  List<Account> get filteredAccount {
    String searchText = _searchQuery.toLowerCase();
    List<Account> filteredAccounts = _data.where((account) {
      return account.accountdata.any((data) =>
          data.accountname?.toLowerCase().contains(searchText) == true ||
          data.lastname?.toLowerCase().contains(searchText) == true ||
          data.workemail?.toLowerCase().contains(searchText) == true);
    }).toList();
    return filteredAccounts;
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    sheet.appendRow([
      const TextCellValue(''),
      //headers of advisor data
      const TextCellValue('Account Name'),
      const TextCellValue('Work Title'),
      const TextCellValue('Phone Number'),
      const TextCellValue('Work Email'),
      const TextCellValue('Company Domain Name'),
      const TextCellValue('Naics Code'),
      const TextCellValue('Company Name'),
      const TextCellValue('Company Address'),
      const TextCellValue('Company Phone Number'),
      const TextCellValue('Fancy Name'),
    ]);

    for (var item in data) {
      for (var accountData in item.accountdata) {
        sheet.appendRow([
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
        ]);
        sheet.appendRow([
          const TextCellValue('Account Data'),
          TextCellValue('${accountData.accountname} ${accountData.lastname}'),
          TextCellValue(accountData.worktitle ?? ''),
          TextCellValue(accountData.phonenumber ?? ''),
          TextCellValue(accountData.workemail ?? ''),
          TextCellValue(accountData.companydomainname ?? ''),
          TextCellValue(accountData.naicscode ?? ''),
          TextCellValue(accountData.companyname ?? ''),
          TextCellValue(accountData.companyaddress ?? ''),
          TextCellValue(accountData.companyphonenumber ?? ''),
          TextCellValue(accountData.fancyname ?? ''),
        ]);
        sheet.appendRow([
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
        ]);

        sheet.appendRow([
          const TextCellValue(''),
          const TextCellValue('Company Domain Name'),
          const TextCellValue('Company Name'),
          const TextCellValue('Company Address'),
          const TextCellValue('Company Phone Number'),
          const TextCellValue('Company Type Name'),
          const TextCellValue('Category Name'),
          const TextCellValue('Naics code'),
          const TextCellValue('EIN code'),
        ]);
        sheet.appendRow([
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
          const TextCellValue(''),
        ]);
        for (var employer in item.employers) {
          sheet.appendRow([
            const TextCellValue('Employer Data'),
            TextCellValue(employer.companydomain ?? ''),
            TextCellValue(employer.companyname ?? ''),
            TextCellValue(employer.companyaddress ?? ''),
            TextCellValue(employer.companyphoneno ?? ''),
            TextCellValue(employer.companytypename ?? ''),
            TextCellValue(employer.categoryname ?? ''),
            TextCellValue(employer.naicscode ?? ''),
            TextCellValue(employer.eincode ?? ''),
          ]);
          for (var partner in employer.partners) {
            sheet.appendRow([
              const TextCellValue('Partner Data'),
              TextCellValue(partner.partnerdata.companydomain ?? ''),
              TextCellValue(partner.partnerdata.companyname ?? ''),
              TextCellValue(partner.partnerdata.companyaddress ?? ''),
              TextCellValue(partner.partnerdata.companyphoneno ?? ''),
              TextCellValue(partner.partnerdata.companytypename ?? ''),
              TextCellValue(partner.partnerdata.categoryname ?? ''),
              TextCellValue(partner.partnerdata.naicscode ?? ''),
              TextCellValue(partner.partnerdata.eincode ?? ''),
            ]);
          }
        }
      }
    }

    // sheet.appendRow([
    //   const TextCellValue('Account Code'),
    //   const TextCellValue('Account Name'),
    //   const TextCellValue('Last Name'),
    //   const TextCellValue('Work Title'),
    //   const TextCellValue('Phone Number'),
    //   const TextCellValue('Work Email'),
    //   const TextCellValue('Company Domain Name'),
    //   const TextCellValue('Company Name'),
    //   const TextCellValue('Company Address'),
    //   const TextCellValue('Company Phone Number'),
    //   const TextCellValue('Fancy Name'),
    //   const TextCellValue('Status'),
    //   const TextCellValue('Employer Company Name'),
    //   const TextCellValue('Employer Company Address'),
    //   const TextCellValue('Employer Company Phone Number'),
    //   const TextCellValue('Partner Company Name'),
    //   const TextCellValue('Partner Company Address'),
    //   const TextCellValue('Partner Company Phone Number'),
    // ]);
    // for (var item in data) {
    //   for (var accountData in item.accountdata) {
    //     for (var employer in item.employers) {
    //       for (var partner in employer.partners) {
    //         sheet.appendRow([
    //           TextCellValue(accountData.accountcode ?? ''),
    //           TextCellValue(accountData.accountname ?? ''),
    //           TextCellValue(accountData.lastname ?? ''),
    //           TextCellValue(accountData.worktitle ?? ''),
    //           TextCellValue(accountData.phonenumber ?? ''),
    //           TextCellValue(accountData.workemail ?? ''),
    //           TextCellValue(accountData.companydomainname ?? ''),
    //           TextCellValue(accountData.companyname ?? ''),
    //           TextCellValue(accountData.companyaddress ?? ''),
    //           TextCellValue(accountData.companyphonenumber ?? ''),
    //           TextCellValue(accountData.fancyname ?? ''),
    //           TextCellValue(accountData.status.toString()),
    //           TextCellValue(employer.companyname ?? ''),
    //           TextCellValue(employer.companyaddress ?? ''),
    //           TextCellValue(employer.companyphoneno ?? ''),
    //           TextCellValue(partner.partnerdata.companyname ?? ''),
    //           TextCellValue(partner.partnerdata.companyaddress ?? ''),
    //           TextCellValue(partner.partnerdata.companyphoneno ?? ''),
    //         ]);
    //       }
    //     }
    //   }
    // }

    var filePath = '../Advisor/Excel_data.xlsx';
    excel.save(fileName: filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel file saved at: $filePath'),
      ),
    );
  }
}
