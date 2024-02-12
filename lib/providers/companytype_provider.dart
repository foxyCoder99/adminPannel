import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/models/admin/companytype_modal.dart';
import 'package:advisorapp/constants.dart';

class CompanyTypeProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController typenameController = TextEditingController();
  final List<CompanyType> _companyTypeList = [];
  List<CompanyType> get companyTypeList => _companyTypeList;
  String _searchQuery = '';
  String _editingTypeCode = '';

  String get searchQuery => _searchQuery;

  bool _isFormVisible = false;
  bool _isEditing = false;

  bool get isEditing => _isEditing;
  bool get isFormVisible => _isFormVisible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool validateCompanyTypeForm() {
    return formKey.currentState?.validate() ?? false;
  }

  CompanyTypeProvider() {
    fetchCompanyTypeList();
  }
  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void resetForm() {
    _clearForm();
    setEditing(false);
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setEditingTypeCode(String usercode) {
    _editingTypeCode = usercode;
  }

  List<CompanyType> get filteredCompanyTypeList {
    return _companyTypeList
        .where((companyType) => companyType.typename
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchCompanyTypeList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/ReadAdvisorCompanyTypeM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "status": "1",
        }),
      );

      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);

        if (data is List) {
          _companyTypeList.clear();
          _companyTypeList.addAll(data
              .map((companyTypeData) => CompanyType.fromJson(companyTypeData)));
          notifyListeners();
        } else {
          print(
              "Error parsing CompanyType list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching CompanyType list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching CompanyType list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertAdvisoradminCompanyType(
    BuildContext context,
    String typename,
  ) async {
    final response = await http.post(
      Uri.parse(
          "${webApiserviceURL}Advisor/InsertAdvisorCompanyTypeM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"typename": typename}),
    );
    if (response.statusCode == 200) {
      print("${response.body} : CompanyType added successfully");
    } else {
      print("Error adding CompanyType: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> updateAdvisoradminCompanyType(
      String typename, String typecode) async {
    final response = await http.post(
      Uri.parse(
          "${webApiserviceURL}Advisor/UpdateAdvisorCompanyTypeM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"typecode": typecode, "typename": typename, "status": "1"}),
    );
    if (response.statusCode == 200) {
      print("${response.body} : CompanyType updated successfully");
    } else {
      print("Error updating CompanyType: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> deleteAdvisorCompanyType(String id) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${webApiserviceURL}Advisor/DeleteAdvisorCompanyTypeM"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
        }),
      );

      if (response.statusCode == 200) {
        print("${response.body} : CompanyType deleted successfully");
        _companyTypeList
            .removeWhere((companyType) => companyType.id.toString() == id);
        notifyListeners();
      } else {
        print("Error deleting CompanyType: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error deleting CompanyType: $e");
    }
  }

  Future<void> saveCompanyType(BuildContext context) async {
    final newCompanyType = CompanyType(
      id: 0,
      typename: typenameController.text,
      typecode: _editingTypeCode,
      status: true,
    );

    if (isEditing) {
      final index = _companyTypeList.indexWhere(
          (companyType) => companyType.typecode == newCompanyType.typecode);
      if (index != -1) {
        updateCompanyType(newCompanyType, index);

        await updateAdvisoradminCompanyType(
            newCompanyType.typename, newCompanyType.typecode);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("CompanyType Edited successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else if (!isEditing &&
        companyTypeList.any((e) => e.typename == newCompanyType.typename)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("CompanyType Name Already Exists."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      await insertAdvisoradminCompanyType(context, newCompanyType.typename);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("CompanyType saved successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

    hideForm();
    fetchCompanyTypeList();
    resetForm();
  }

  void editCompanyType(BuildContext context, CompanyType companyType) {
    _isFormVisible = true;
    setEditing(true);
    setEditingTypeCode(companyType.typecode);
    typenameController.text = companyType.typename;
    notifyListeners();
  }

  void updateCompanyType(CompanyType newCompanyType, int index) {
    if (index >= 0 && index < _companyTypeList.length) {
      _companyTypeList[index] = newCompanyType;

      _isFormVisible = false;
      updateAdvisoradminCompanyType(
          newCompanyType.typename, newCompanyType.typecode);
      notifyListeners();
    }
  }

  void showForm() {
    _isFormVisible = true;
    notifyListeners();
  }

  void hideForm() {
    _isFormVisible = false;
    notifyListeners();
  }

  void _clearForm() {
    typenameController.clear();
  }

  void cancelTypeForm(BuildContext context) {
    hideForm();
    _clearForm();
  }
}
