import 'dart:convert';
import 'package:advisorapp/adminforms/drive_upload/share_file.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/drive_modals/sharefile_modal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ShareFileProvider extends ChangeNotifier {
  final List<ShareMail> _readEmails = [];
  List<ShareMail> trueShareEmails = [];
  List<ShareMail> get readEmails => _readEmails;
  bool _searchEmailFocused = false;
  bool get searchEmailFocused => _searchEmailFocused;
  String _searchEmailQuery = '';
  String get searchEmailQuery => _searchEmailQuery;
  final Set<String> _selectedTypes = {};
  Set<String> get selectedType => _selectedTypes;

  set searchEmailQuery(String query) {
    _searchEmailQuery = query;
    _filterEmails();
    notifyListeners();
  }

  set searchEmailFocused(bool value) {
    _searchEmailFocused = value;
    notifyListeners();
  }

  void toggleSelectedEmail(ShareMail email, bool value) {
    email.fileshare = value;
    if (value) {
      trueShareEmails.add(email);
    } else {
      trueShareEmails.remove(email);
    }
    notifyListeners();
  }

  List<ShareMail> _filteredEmails = [];
  List<ShareMail> get filteredEmails => _filteredEmails;

  void _filterEmails() {
    if (_selectedTypes.isEmpty && _searchEmailQuery.isEmpty) {
      _filteredEmails = _readEmails;
    } else {
      _filteredEmails = _readEmails.where((email) {
        final emailMatch = email.accountname
                .toLowerCase()
                .contains(_searchEmailQuery.toLowerCase()) ||
            email.emailid
                .toLowerCase()
                .contains(_searchEmailQuery.toLowerCase());
        final emailtypeMatch = _selectedTypes.isEmpty ||
            _selectedTypes.contains(email.emailtype.toLowerCase());
        return emailMatch && emailtypeMatch;
      }).toList();
    }
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedTypes.contains(category)) {
      _selectedTypes.remove(category);
    } else {
      _selectedTypes.clear();
      _selectedTypes.add(category);
    }
    _filterEmails();
    notifyListeners();
  }

  void showShareDialog(
      BuildContext context, String filecode, String accountcode) async {
    try {
      await fetchSharingEmails(filecode, accountcode);

      for (ShareMail email in readEmails) {
        if (email.fileshare) {
          trueShareEmails.add(email);
        }
      }
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShareFile(
            key: UniqueKey(),
            filecode: filecode,
            accountcode: accountcode,
          );
        },
      );
    } catch (e) {
      print('Error reading share Emails: $e');
    }
  }

  Future<void> fetchSharingEmails(String filecode, String accountcode) async {
    try {
      final response = await http.post(
        Uri.parse('${webApiserviceURL}Advisor/ReadDriveAccountShareDetails'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "accountcode": contantAcountCode,
          "filecode": filecode,
          "fromdate": "01/01/2022",
          "todate": "01/12/2024"
        }),
      );
      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);
        if (data is List) {
          _readEmails.clear();
          _readEmails.addAll(data.map((email) => ShareMail.fromJson(email)));
          _filterEmails();
          notifyListeners();
        } else {
          print("Error parsing Emails list. Expected a list, but got: $data");
        }
      } else {
        print('Failed to fetch Emails: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Emails: $e');
    }
  }

  Future<void> fileSharingEmails(String filecode, String accountcode) async {
    try {
      List<Map<String, dynamic>> sharePayload = trueShareEmails.map((email) {
        return {
          "toaccountcode": email.accountcode,
          "fromaccountcode": accountcode,
          "filecode": filecode,
          "fileshare": 1,
          "loggedinuser": "system"
        };
      }).toList();

      final response = await http.post(
        Uri.parse(
            '${webApiserviceURL}Advisor/SetAdvisorDriveShareFilestoAccount'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(sharePayload),
      );
      if (response.statusCode == 200) {
        print('${response.body} : Sharing file successfully');
      } else {
        print('Share failed: ${response.statusCode}');
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print('Error sharing files: $e');
    }
  }
}
