import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/paymentreport_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:advisorapp/constants.dart';

class PaymentReportProvider extends ChangeNotifier {
  final List<PaymentReport> _paymentList = [];
  List<PaymentReport> get paymentList => _paymentList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  var fromDate = DateTime(2022, 1, 1);
  var toDate = DateTime(2023, 12, 31);
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  List<PaymentReport> get filteredPayments {
    return _paymentList
        .where((payment) =>
            payment.invoicenumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            payment.accountname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            payment.emailid.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  PaymentReportProvider() {
    fetchPaymentDetailList(fromDate, toDate);
  }

  Future<void> fetchPaymentDetailList(
      DateTime fromDate, DateTime toDate) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorAdminPaymentDetail"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fromdate": DateFormat('MM/dd/yyyy').format(fromDate),
          "todate": DateFormat('MM/dd/yyyy').format(toDate),
        }),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);
        if (data is List) {
          _paymentList.clear();
          _paymentList.addAll(
              data.map((paymentData) => PaymentReport.fromJson(paymentData)));
          notifyListeners();
        } else {
          print("Error parsing payment list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching payment list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching payment list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> exportToExcel(BuildContext context) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    sheet.appendRow([
      const TextCellValue('Invoice Number'),
      const TextCellValue('Subscription Name'),
      const TextCellValue('Account Name'),
      const TextCellValue('Email Id'),
      const TextCellValue('Company Name'),
      const TextCellValue('Paid Amount'),
      const TextCellValue('Unit Amount'),
      const TextCellValue('Paid Date'),
    ]);

    // Add data
    for (var report in _paymentList) {
      sheet.appendRow([
        TextCellValue(report.invoicenumber),
        TextCellValue(report.subscriptionname),
        TextCellValue(report.accountname),
        TextCellValue(report.emailid),
        TextCellValue(report.companyname),
        TextCellValue(report.paidamount),
        TextCellValue(report.unitamount),
        TextCellValue(report.paiddate),
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

  void updateDateRange(DateTime newFromDate, DateTime newToDate) {
    fromDate = newFromDate;
    toDate = newToDate;
    fetchPaymentDetailList(fromDate, toDate);
  }

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
