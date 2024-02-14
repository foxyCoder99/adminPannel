import 'dart:convert';
import 'package:advisorapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/models/admin/compcategory_model.dart';

class CompanyCategoryProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController typenameController = TextEditingController();
  List<Category> _companyCategories = [];
  List<Category> get companyCategories => _companyCategories;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isFormVisible = false;
  bool _isEditing = false;
  String _editingId = '';

  bool get isEditing => _isEditing;
  bool get isFormVisible => _isFormVisible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool validateCompanyTypeForm() {
    return formKey.currentState?.validate() ?? false;
  }

  CompanyCategoryProvider() {
    fetchCompanyCategories();
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

  List<Category> get filteredCompanyTypeList {
    return _companyCategories
        .where((Category) =>
            Category.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchCompanyCategories() async {
    try {
      var response = await http.post(
        Uri.parse(
            '${webApiserviceURL}Advisor/ReadAdvisorCompanyCategoryM'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'status': '1'}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        _companyCategories = jsonResponse
            .where((entry) =>
                entry['categoryname'] is String &&
                entry['categoryname'].isNotEmpty)
            .map((entry) => Category.fromJson(entry))
            .toList();

        notifyListeners();
      } else {
        print(
            'Failed to load company categories. Status code: ${response.statusCode}');
        throw Exception('Failed to load company categories');
      }
    } catch (error) {
      print('Error fetching company categories: $error');
      throw Exception('Error fetching company categories');
    }
  }

  Future<void> saveCompanyCategory(BuildContext context) async {
    try {
      var categoryName = typenameController.text;

      if (isEditing) {
        await updateCompanyCategory(_editingId, categoryName);
      } else {
        var response = await http.post(
          Uri.parse(
              '${webApiserviceURL}Advisor/InsertAdvisorCompanyCategoryM'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'categoryname': categoryName}),
        );

        if (response.statusCode == 200) {
          print('Company category saved successfully: ${response.body}');
          await fetchCompanyCategories();
        } else {
          print('Failed to save company category: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error saving company category: $error');
    }

    hideForm();
    _clearForm();
    resetForm();
  }

  void editCompanyCategory(BuildContext context, Category category) {
    _isFormVisible = true;
    setEditing(true);
    setEditingId(category.id);
    typenameController.text = category.name;
    // Notify listeners here to show the form and update the text field
    notifyListeners();
  }

  Future<void> updateCompanyCategory(
      String categoryId, String updatedCategoryName) async {
    try {
      var response = await http.post(
        Uri.parse(
            '${webApiserviceURL}Advisor/UpdateAdvisorCompanyCategoryM'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': categoryId,
          'categoryname': updatedCategoryName,
          'status': '1',
        }),
      );

      if (response.statusCode == 200) {
        print('Category updated successfully: ${response.body}');

        // Find the index of the category to be updated
        int index = _companyCategories
            .indexWhere((category) => category.id == categoryId);

        if (index != -1) {
          _companyCategories[index] =
              Category(id: categoryId, name: updatedCategoryName);
          hideForm();
          _clearForm();
          notifyListeners();
        }
      } else {
        print('Failed to update category: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating category: $error');
    }
  }

  void setEditingId(String id) {
    _editingId = id;
  }

  void updateCompanyType(Category newCompanyType, int index) {
    if (index >= 0 && index < _companyCategories.length) {
      _companyCategories[index] = newCompanyType;

      _isFormVisible = false;
      updateCompanyCategory(newCompanyType.id, newCompanyType.name);
      notifyListeners();
    }
  }

  Future<void> deleteCompanyCategory(String categoryId) async {
    try {
      var response = await http.post(
        Uri.parse(
          '${webApiserviceURL}Advisor/DeleteAdvisorCompanyCategoryM',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': categoryId}),
      );

      if (response.statusCode == 200) {
        print('Category deleted successfully: ${response.body}');

        _companyCategories.removeWhere((category) => category.id == categoryId);
        notifyListeners();
      } else {
        print('Failed to delete category. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting category: $error');
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
