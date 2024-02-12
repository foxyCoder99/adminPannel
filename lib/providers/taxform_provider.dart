import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/tax_modal.dart';

class TaxProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController taxnameController = TextEditingController();
  final TextEditingController taxvalueController = TextEditingController();

  bool _isFormVisible = false;
  bool _isEditing = false;
  bool _isLoading = false;
  final List<Tax> _taxDetails = [];
  int _selectedTaxId = 0;

  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  List<Tax> get taxDetails => _taxDetails;

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void resetForm() {
    //_clearForm();
    setEditing(false);
  }

  void showForm() {
    _isFormVisible = true;
    setEditing(false);
    resetTextFields();
    notifyListeners();
  }

  void hideForm() {
    _isFormVisible = false;
    notifyListeners();
  }

  void resetTextFields() {
    taxnameController.text = '';
    taxvalueController.text = '';
  }

  bool get isFormVisible => _isFormVisible;

  TaxProvider() {
    fetchTaxData();
  }

  // Fetch tax data from the API
  Future<void> fetchTaxData() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            '${webApiserviceURL}Advisor/ReadAdvisorAdminTaxM'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': '1'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _taxDetails.clear();
        _taxDetails.addAll(responseData.map((json) => Tax.fromJson(json)));
        notifyListeners();
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveupdatetax(BuildContext context) async {
    try {
      // Check if taxname is blank
      if (taxnameController.text.trim().isEmpty) {
        _showDialog(context, 'Info', 'Tax name cannot be blank');
        return;
      }

      // Check if taxvalue is numeric or decimal
      if (!isNumericOrDecimal(taxvalueController.text)) {
        _showDialog(context, 'Info', 'Tax value must be numeric or decimal');
        return;
      }

      // Check if editing, then update; otherwise, save new record
      if (_isEditing) {
        // Implement update logic here
        final response = await http.post(
          Uri.parse(
              '${webApiserviceURL}Advisor/UpdateAdvisorAdminTaxM'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id': _selectedTaxId.toString(),
            'taxname': taxnameController.text,
            'taxvalue': taxvalueController.text,
            'loggedinuser': 'adminUser',
          }),
        );

        if (response.statusCode == 200) {
          _showDialog(context, 'Info', 'Tax updated successfully');
          fetchTaxData(); // Fetch updated data or perform any other action
          hideForm();
        } else {
          _showDialog(
              context, 'Error', 'Failed to update tax: ${response.statusCode}');
        }
      } else {
        // Check if taxname already exists
        if (_taxDetails.any((tax) => tax.taxName == taxnameController.text)) {
          _showDialog(context, 'Info', 'Tax name already exists');
          return;
        }

        // Implement save new record logic here
        final response = await http.post(
          Uri.parse(
              '${webApiserviceURL}Advisor/InsertAdvisorAdminTaxM'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'taxname': taxnameController.text,
            'taxvalue': taxvalueController.text,
            'loggedinuser': 'adminUser',
          }),
        );

        if (response.statusCode == 200) {
          _showDialog(context, 'Info', 'Tax saved successfully');
          fetchTaxData(); // Fetch updated data or perform any other action
        } else {
          _showDialog(
              context, 'Error', 'Failed to save tax: ${response.statusCode}');
        }
      }
    } catch (error) {
      _showDialog(context, 'Info', 'Error saving/updating tax: $error');
    }
  }

  bool isNumericOrDecimal(String value) {
    if (value == "") {
      return false;
    }
    return double.tryParse(value) != null;
  }

  Future<void> deletetax(BuildContext context, String taxId) async {
    try {
      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this tax?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User chose not to delete
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed deletion
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );

      // If the user confirmed deletion, proceed with the deletion
      if (confirmDelete == true) {
        final response = await http.post(
          Uri.parse(
              '${webApiserviceURL}Advisor/DeleteAdvisorAdminTaxM'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id': taxId,
            'loggedinuser': 'adminUser',
          }),
        );

        print('Delete Tax API Response: ${response.body}');

        if (response.statusCode == 200) {
          _showDialog(context, 'Info', 'Tax deleted successfully');
          fetchTaxData(); // Fetch updated data or perform any other action
        } else {
          _showDialog(
            context,
            'Error',
            'Failed to delete tax: ${response.statusCode}',
          );
        }
      }
    } catch (error) {
      _showDialog(context, 'Error', 'Error deleting tax: $error');
    }
  }

  void setSelectedTaxId(int taxId) {
    _selectedTaxId = taxId;
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
