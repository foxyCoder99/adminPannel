import 'package:advisorapp/models/admin/subscription_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubscriptionProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController subscriptionnameController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  final List<String> types = ['SUB', 'VAS'];
  final List<String> priceunits = ['USD'];
  final List<String> displayPeriodunits = ['Monthly', 'Yearly', 'Days'];
  final List<String> backendPeriodunits = ['MM', 'YY', 'DD'];

  final List<Subscription> _subscriptionList = [];

  bool _isFormVisible = false;
  bool _isEditing = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;

  bool validateSubscriptionForm() {
    return formKey.currentState?.validate() ?? false;
  }

  List<Subscription> get subscriptionList => _subscriptionList;
  bool get isFormVisible => _isFormVisible;

  List<Subscription> get filteredSubscriptionList {
    return _subscriptionList
        .where((subscription) =>
            subscription.subscriptionname
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            subscription.type
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String _selectedType = '';
  String _selectedPriceunit = '';
  String _selectedPeriodunit = '';
  String _searchQuery = '';

  String get selectedType => _selectedType;
  String get selectedPriceunit => _selectedPriceunit;
  String get selectedPeriodunit => _selectedPeriodunit;
  String _editingSubscriptionCode = '';
  SubscriptionProvider() {
    fetchSubscriptionList();
  }

  void resetSearchQuery() {
    searchQuery = '';
  }

  String _selectedDisplayPeriodUnit = 'Monthly';

  String get selectedDisplayPeriodUnit => _selectedDisplayPeriodUnit;

  String get searchQuery => _searchQuery;

  String get selectedBackendPeriodUnit {
    // Find the corresponding backend value based on the display value
    int index = displayPeriodunits.indexOf(_selectedDisplayPeriodUnit);
    return index != -1 ? backendPeriodunits[index] : '';
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setEditingSubscriptionCode(String subscriptionCode) {
    _editingSubscriptionCode = subscriptionCode;
  }

  void setSelectedType(String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedType = value.isNotEmpty ? value : types.first;
      notifyListeners();
    });
  }

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void setSelectedDisplayPeriodUnit(String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedDisplayPeriodUnit =
          value.isNotEmpty ? value : displayPeriodunits.first;
      notifyListeners();
    });
  }

  void setSelectedPeriodunit(String periodunit) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Perform state changes here
      _selectedPeriodunit = periodunit;
      notifyListeners();
    });
  }

  void setSelectedPriceunit(String priceunit) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Perform state changes here
      _selectedPriceunit = priceunit;
      notifyListeners();
    });
  }

  void showForm() {
    if (!_isFormVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isFormVisible = true;
        notifyListeners();
      });
    }
  }

  void hideForm() {
    _isFormVisible = false;
    notifyListeners();
  }

  void _clearForm() {
    subscriptionnameController.clear();
    priceController.clear();
    periodController.clear();
  }

  void cancelSubscriptionForm(BuildContext context) {
    hideForm();
    _clearForm();
  }

  Future<void> insertSubscription(
      BuildContext context, Subscription subscription) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/InsertAdvisorAdminSubscriptionTypeM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "type": subscription.type,
        "subscriptionname": subscription.subscriptionname,
        "price": subscription.price.toString(),
        "priceunit": subscription.priceunit,
        "period": subscription.period.toString(),
        "periodunit": subscription.periodunit,
        "loggedinuser": "adminUser",
      }),
    );

    if (response.statusCode == 200) {
      print("Subscription added successfully");
    } else {
      print("Error adding subscription: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> fetchSubscriptionList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            "https://advisordevelopment.azurewebsites.net/api/Advisor/ReadAdvisorAdminSubsciptionTypeM"),
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
          _subscriptionList.clear();
          _subscriptionList
              .addAll(data.map((subData) => Subscription.fromJson(subData)));
          notifyListeners();
        } else {
          print(
              "Error parsing subscription list. Expected a list, but got: $data");
        }
      } else {
        print("Error fetching subscription list: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching subscription list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAdvisorAdminSubscription(Subscription subscription) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/UpdateAdvisorAdminSubsciptionTypeM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "type": subscription.type,
        "subscriptioncode": subscription.subscriptioncode,
        "subscriptionname": subscription.subscriptionname,
        "price": subscription.price.toString(),
        "priceunit": subscription.priceunit,
        "period": subscription.period.toString(),
        "periodunit": subscription.periodunit,
        "loggedinuser": "adminUserUpdate",
      }),
    );

    if (response.statusCode == 200) {
      print("Subscription updated successfully");
    } else {
      print("Error updating subscription: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> deleteAdvisorAdminSubscription(String subscriptioncode) async {
    final response = await http.post(
      Uri.parse(
          "https://advisordevelopment.azurewebsites.net/api/Advisor/DeleteAdvisorAdminSubsciptionTypeM"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "subscriptioncode": subscriptioncode,
        "loggedinuser": "admindeleteuser",
      }),
    );

    if (response.statusCode == 200) {
      print("Subscription deleted successfully");
      _subscriptionList.removeWhere(
          (subscription) => subscription.subscriptioncode == subscriptioncode);

      notifyListeners();
    } else {
      print("Error deleting subscription: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> saveSubscription(BuildContext context) async {
    final newSubscription = Subscription(
      id: 0,
      type: _selectedType,
      subscriptionname: subscriptionnameController.text,
      priceunit: _selectedPriceunit,
      price: double.parse(priceController.text),
      periodunit: _selectedPeriodunit,
      period: int.parse(periodController.text),
      subscriptioncode: _editingSubscriptionCode,
    );

    if (isEditing) {
      final index = _subscriptionList.indexWhere((subscription) =>
          subscription.subscriptioncode == newSubscription.subscriptioncode);

      // Subscription existingSubscription = _subscriptionList.firstWhere(
      //   (element) =>
      //       element.subscriptioncode == newSubscription.subscriptioncode,
      // );

      if (index != -1) {
        await updateAdvisorAdminSubscription(newSubscription);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Subscription Edited successfully."),
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
        _subscriptionList.any(
            (e) => e.subscriptionname == newSubscription.subscriptionname)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("Subscription Name Already Exists."),
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
      await insertSubscription(context, newSubscription);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Subscription saved successfully."),
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
    fetchSubscriptionList();
    resetForm();
  }

  void editSubscription(BuildContext context, Subscription subscription) {
    _isFormVisible = true;
    setEditing(true);
    setEditingSubscriptionCode(subscription.subscriptioncode);
    subscriptionnameController.text = subscription.subscriptionname;
    priceController.text = subscription.price.toString();
    periodController.text = subscription.period.toString();
    _selectedType = subscription.type;
    _selectedPriceunit = subscription.priceunit;
    _selectedPeriodunit = subscription.periodunit;
    notifyListeners();
  }

  void updateSubscription(Subscription newSubscription, int index) {
    if (index >= 0 && index < _subscriptionList.length) {
      _subscriptionList[index] = newSubscription;
      _isFormVisible = false;
      updateAdvisorAdminSubscription(newSubscription);
      notifyListeners();
    }
  }

  void resetForm() {
    _clearForm();
    setEditing(false);
  }
}
