// unpaidinvoice_provider.dart
import 'dart:convert';
import 'package:advisorapp/models/admin/report_modals/UnpaidInvoice_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnpaidInvoiceProvider extends ChangeNotifier {
  final List<UnpaidInvoice> _invoiceList = [];
  List<UnpaidInvoice> get invoiceList => _invoiceList;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  UnpaidInvoiceProvider() {
    fetchUnpaidInvoiceList();
  }

  Future<void> fetchUnpaidInvoiceList() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminUnpaidInvoice"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"accountcode": ""}),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);
        if (data is List) {
          _invoiceList.clear();
          _invoiceList.addAll(
              data.map((invoiceData) => UnpaidInvoice.fromJson(invoiceData)));
          notifyListeners();
        } else {
          print("Error parsing invoice list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching invoice list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching invoice list: $e");
    }
  }

  List<UnpaidInvoice> getFilteredInvoiceList(String query) {
    final lowerCaseQuery = query.toLowerCase();
    return _invoiceList.where((invoice) {
      return invoice.id.toLowerCase().contains(lowerCaseQuery) ||
          invoice.accountcode.toLowerCase().contains(lowerCaseQuery) ||
          invoice.fromdate.toLowerCase().contains(lowerCaseQuery) ||
          invoice.todate.toLowerCase().contains(lowerCaseQuery) ||
          invoice.status.toLowerCase().contains(lowerCaseQuery) ||
          invoice.loggedinuser.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }
}
