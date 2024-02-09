import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/upload_modal.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DriveUploadProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PlatformFile? _selectedFile;

  final List<UploadedFile> _uploadedFiles = [];
  final List<UploadedFile> _readFiles = [];
  final List<ShareMail> _readEmails = [];
  List<UploadedFile> _filteredFiles = [];
  List<ShareMail> trueShareEmails = [];

  String _searchQuery = '';
  String selectedFileType = 'DOC';
  TextEditingController emailController = TextEditingController();
  TextEditingController fileDescpController = TextEditingController();

  final Set<String> _selectedCategories = {};

  bool _searchFocused = false;
  bool _uploadingFile = false;
  bool _isFormVisible = false;
  bool _isLoading = false;

  PlatformFile? get selectedFile => _selectedFile;
  Set<String> get selectedCategories => _selectedCategories;

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isFormVisible => _isFormVisible;
  bool get uploadingFile => _uploadingFile;
  bool get searchFocused => _searchFocused;

  List<UploadedFile> get uploadedFiles => _uploadedFiles;
  List<UploadedFile> get readFiles => _readFiles;
  List<ShareMail> get readEmails => _readEmails;
  List<UploadedFile> get filteredFiles => _filteredFiles;

  void resetSearchQuery() {
    searchQuery = '';
  }

  void setSelectedFile(PlatformFile file) {
    _selectedFile = file;
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

  set uploadingFile(bool value) {
    _uploadingFile = value;
    notifyListeners();
  }

  set searchFocused(bool value) {
    _searchFocused = value;
    notifyListeners();
  }

  set searchQuery(String value) {
    _searchQuery = value;
    _filterFiles();
    notifyListeners();
  }

  DriveUploadProvider() {
    fetchUploadedFiles();
  }

  void _filterFiles() {
    if (_selectedCategories.isEmpty && _searchQuery.isEmpty) {
      _filteredFiles = _readFiles;
    } else {
      _filteredFiles = _readFiles.where((file) {
        final filenameMatch =
            file.filename.toLowerCase().contains(_searchQuery.toLowerCase());
        final filetypeMatch = _selectedCategories.isEmpty ||
            _selectedCategories
                .contains(determineFiletype(file.filename).toLowerCase());
        return filenameMatch && filetypeMatch;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchUploadedFiles() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
            'https://advisordevelopment.azurewebsites.net/api/Advisor/ReadDriveAccountUploadedSharedFiles'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          // "accountcode": "AC-20231206095313303",
          "accountcode": contantAcountCode,
          "fromdate": "01/01/2022",
          "todate": "03/31/2024"
        }),
      );
      if (response.statusCode == 200) {
        final cleanedResponse =
            response.body.replaceAll(RegExp(r'[\u0000-\u001F]'), '');

        final dynamic data = jsonDecode(cleanedResponse);

        if (data is List) {
          _readFiles.clear();
          _readFiles.addAll(data.map((file) => UploadedFile.fromJson(file)));
          _filterFiles();
          // fetchSharingEmails();
          notifyListeners();
        } else {
          print("Error parsing file list. Expected a list, but got: $data");
        }
      } else {
        print('Failed to fetch uploaded files: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching uploaded files: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSharingEmails(String filecode, String accountcode) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://advisordevelopment.azurewebsites.net/api/Advisor/ReadDriveAccountShareDetails'),
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

  String formatFileSize(int bytes) {
    const int kilobyte = 1024;
    const int megabyte = 1024 * 1024;
    const int gigabyte = 1024 * 1024 * 1024;

    if (bytes >= gigabyte) {
      return '${(bytes / gigabyte).toStringAsFixed(2)} GB';
    } else if (bytes >= megabyte) {
      return '${(bytes / megabyte).toStringAsFixed(2)} MB';
    } else if (bytes >= kilobyte) {
      return '${(bytes / kilobyte).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }

  String determineFiletype(String filename) {
    if (filename.toLowerCase().endsWith('.pdf')) {
      return 'Pdf';
    } else if (filename.toLowerCase().endsWith('.doc') ||
        filename.toLowerCase().endsWith('.docx')) {
      return 'Word';
    } else if (filename.toLowerCase().endsWith('.xls') ||
        filename.toLowerCase().endsWith('.xlsx')) {
      return 'Excel';
    } else if (filename.toLowerCase().endsWith('.mp3') ||
        filename.toLowerCase().endsWith('.wav') ||
        filename.toLowerCase().endsWith('.ogg')) {
      return 'Audio';
    } else if (filename.toLowerCase().endsWith('.mp4') ||
        filename.toLowerCase().endsWith('.avi') ||
        filename.toLowerCase().endsWith('.mkv')) {
      return 'Video';
    } else if (filename.toLowerCase().endsWith('.zip')) {
      return 'Zip';
    } else if (filename.toLowerCase().endsWith('.jpg') ||
        filename.toLowerCase().endsWith('.jpeg') ||
        filename.toLowerCase().endsWith('.gif') ||
        filename.toLowerCase().endsWith('.png')) {
      return 'Image';
    } else {
      return 'Document';
    }
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.clear();
      _selectedCategories.add(category);
    }
    _filterFiles();
    notifyListeners();
  }

  Future<void> accountUploadFiles(BuildContext context) async {
    try {
      List<Map<String, dynamic>> fileUploads = _uploadedFiles.map((file) {
        return {
          'filename': file.filename,
          'fileextension': '.${file.fileExtension}',
          'filetype': file.filetype,
          'description': file.description,
          'filebase64': file.filebase64.toString(),
        };
      }).toList();
      Map<String, dynamic> payload = {
        'accountcode': contantAcountCode,
        // 'accountcode': 'AC-20231206095313303',
        'loggedinuser': 'system',
        'fileupload': fileUploads,
      };
      String jsonPayload = jsonEncode(payload);
      Uri insertEndpoint = Uri.parse(
          'https://advisordevelopment.azurewebsites.net/api/Advisor/InsertDriveAccountUploadFiles');
      http.Response response = await http.post(
        insertEndpoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonPayload,
      );
      if (response.statusCode == 200) {
        print('Upload file successful');
      } else {
        print('Upload file failed: ${response.statusCode}');
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print('Error while inserting file: $e');
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    if (_selectedFile == null) {
      uploadingFile = false;
      return;
    }
    try {
      final Uint8List bytes = _selectedFile!.bytes!;
      final String filename = _selectedFile!.name;
      int fileSize = _selectedFile!.size;
      String base64String = base64Encode(bytes);
      if (fileSize > 50 * 1024 * 1024) {
        uploadingFile = false;
        showFileSizeAlert(context);
      } else {
        uploadingFile = true;
        final newUploadedFile = UploadedFile(
          accountcode: '',
          filecode: '',
          filename: filename,
          description: fileDescpController.text,
          sharedfrom: '',
          uploadedby: '',
          uploadeddate:
              DateFormat('MM-dd-yyyy').format(DateTime.now()).toString(),
          fileurl: '',
          fileExtension: filename.split('.').last,
          filetype: selectedFileType,
          filebase64: base64String,
        );
        _uploadedFiles.add(newUploadedFile);
        await accountUploadFiles(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File uploaded successfully.'),
          ),
        );
        hideForm();
        fetchUploadedFiles();
        resetForm();
      }
    } catch (error) {
      print('Error uploading file: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading file. Please try again later.'),
        ),
      );
    } finally {
      uploadingFile = false;
      notifyListeners();
    }
  }

  void showFileSizeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'File Size Exceeds Limit',
            style: TextStyle(color: Colors.red),
          ),
          content:
              const Text('The file size exceeds the maximum limit of 50MB.'),
          actions: <Widget>[
            TextButton(
              style: buttonStyleGreen,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, UploadedFile file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete File'),
          content: const Text('Are you sure you want to delete this file?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: buttonStyleGreen,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: buttonStyleRed,
                  onPressed: () {
                    deleteAdvisorDriveFiles(file.accountcode, file.filecode);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
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
          return AlertDialog(
            title: const Text('Share File'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    width: SizeConfig.screenWidth / 3,
                    height: SizeConfig.screenHeight / 5,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(2.0),
                      itemCount: readEmails.length,
                      itemBuilder: (BuildContext context, int index) {
                        final email = readEmails[index];
                        return Consumer<DriveUploadProvider>(
                            builder: (context, driveUploadProvider, _) { 
                          return CheckboxListTile(
                              title: Text(email.accountname),
                              subtitle: Text(email.emailid),
                              value: email.fileshare,
                              onChanged: (value) {
                                driveUploadProvider.toggleSelectedEmail(
                                    email, value ?? false);
                              });
                        });
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: buttonStyleGreen,
                      onPressed: () {
                        sharesharingEmails(filecode, accountcode);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: buttonStyleRed,
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error reading share Emails: $e');
    }
  }

  Future<void> sharesharingEmails(String filecode, String accountcode) async {
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
            'https://advisordevelopment.azurewebsites.net/api/Advisor/SetAdvisorDriveShareFilestoAccount'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(sharePayload),
      );
      if (response.statusCode == 200) {
        print('File Shared successful');
      } else {
        print('Share failed: ${response.statusCode}');
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print('Error sharing files: $e');
    }
  }

  Future<void> deleteAdvisorDriveFiles(
      String accountCode, String fileCode) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://advisordevelopment.azurewebsites.net/api/Advisor/DeleteAdvisorDriveFiles'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "accountcode": contantAcountCode,
          "filecode": fileCode,
          "loggedinuser": "system"
        }),
      );
      if (response.statusCode == 200) {
        print('File deleted successfully');
        _readFiles.removeWhere((file) => file.filecode == fileCode);
        fetchUploadedFiles();
        notifyListeners();
      } else {
        print('Failed to delete file: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  void resetForm() {
    _clearForm();
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
    if (_uploadedFiles.isNotEmpty) {
      _selectedFile = null;

      _uploadedFiles.clear();
      fileDescpController.clear();
      selectedFileType = 'DOC';
    }
  }

  void cancelmenuForm(BuildContext context) {
    hideForm();
    _clearForm();
  }
}
