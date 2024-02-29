import 'dart:convert';
import 'dart:typed_data';
import 'package:advisorapp/adminforms/drive_upload/transcripted_box.dart';
import 'package:http/http.dart' as http;
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/drive_modals/upload_modal.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class DriveUploadProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PlatformFile? _selectedFile;

  final List<UploadedFile> _uploadedFiles = [];
  final List<UploadedFile> _readFiles = [];
  List<UploadedFile> _filteredFiles = [];

  String _searchQuery = '';

  String selectedFileType = 'DOC';
  TextEditingController emailController = TextEditingController();
  TextEditingController fileDescpController = TextEditingController();

  final Set<String> _selectedCategories = {};

  bool _searchFocused = false;
  String _transcription = '';

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
  String get transcription => _transcription;

  List<UploadedFile> get uploadedFiles => _uploadedFiles;
  List<UploadedFile> get readFiles => _readFiles;

  List<UploadedFile> get filteredFiles => _filteredFiles;

  void resetSearchQuery() {
    searchQuery = '';
  }

  void setSelectedFile(PlatformFile file) {
    _selectedFile = file;
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
            '${webApiserviceURL}Advisor/ReadDriveAccountUploadedSharedFiles'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
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
        filename.toLowerCase().endsWith('.m4a') ||
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
      Uri insertEndpoint =
          Uri.parse('${webApiserviceURL}Advisor/InsertDriveAccountUploadFiles');
      http.Response response = await http.post(
        insertEndpoint,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonPayload,
      );
      if (response.statusCode == 200) {
        print('${response.body} : File Uploaded Successfully');
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
                  onPressed: () async {
                    await deleteAdvisorDriveFiles(
                        file.accountcode, file.filecode);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('File deleted successfully.'),
                      ),
                    );
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

  Future<void> deleteAdvisorDriveFiles(
      String accountCode, String fileCode) async {
    try {
      final response = await http.post(
        Uri.parse('${webApiserviceURL}Advisor/DeleteAdvisorDriveFiles'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "accountcode": contantAcountCode,
          "filecode": fileCode,
          "loggedinuser": "system"
        }),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
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

  set transcription(String text) {
    print(text);
    _transcription =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse viverra lectus a interdum condimentum. Nunc condimentum enim ipsum, non eleifend purus interdum quis. In elementum, nisi eget posuere dapibus, erat lorem molestie purus, in dapibus sem eros non metus. Integer consectetur lacus dui, nec placerat nibh pharetra eu. Aenean mattis pulvinar volutpat. Vivamus congue auctor lectus, id feugiat ipsum sodales et. Vestibulum quis elementum ipsum. Duis sodales ac nisl quis gravida. Cras vestibulum massa at hendrerit volutpat. Vestibulum a ullamcorper ante, sed finibus turpis. Maecenas posuere, est lobortis sollicitudin porttitor, nisi metus dictum nibh, ac commodo sem nulla sit amet odio. Praesent vehicula magna arcu, vitae dignissim metus tempor vitae. Donec blandit felis non quam porta, id ultricies lectus sollicitudin. Fusce tortor arcu, lacinia a urna a, pellentesque tincidunt sem. Cras consequat ex ac leo varius, eu suscipit est semper.\n\nDonec vulputate consequat vulputate. Donec facilisis libero in metus facilisis lobortis. Duis porttitor ex et tellus ultricies cursus. Curabitur ac dui ut leo placerat pellentesque sed vel dui. Integer vitae convallis nisl, a pretium libero. Sed diam risus, tincidunt id nibh nec, sollicitudin condimentum ligula. Curabitur pulvinar, eros vitae volutpat vestibulum, nisl ex mollis orci, at ullamcorper est dolor at magna. Vestibulum auctor bibendum neque, sit amet vehicula metus elementum blandit. Pellentesque semper hendrerit justo nec aliquam. Sed mattis nibh a ligula blandit feugiat. Nam egestas erat condimentum, accumsan arcu id, sodales dolor. Mauris sed consequat purus.\n\nCurabitur pellentesque posuere leo, hendrerit mattis ante. Donec nec nisi dui. Nunc facilisis vitae nulla eu laoreet. Suspendisse condimentum sapien quis magna venenatis pharetra. Suspendisse faucibus ac dolor ut accumsan. Phasellus ac nisl scelerisque, ullamcorper ipsum eu, viverra sem. Phasellus volutpat interdum urna, sed interdum elit.\n\nNunc sodales sapien ac nunc tristique cursus. In hac habitasse platea dictumst. Fusce vitae mattis tortor. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla non leo non ligula pharetra vulputate vitae vel urna. Vestibulum sagittis felis sem. Morbi facilisis lorem in leo dictum imperdiet. Etiam lacinia venenatis risus, id fringilla mauris gravida sed. Curabitur at mauris et justo ultrices ullamcorper. Duis vitae vulputate odio. Morbi ullamcorper posuere eros sit amet sollicitudin. Proin ipsum augue, ultrices non eleifend ut, finibus ac augue. Etiam a blandit nibh, ac porttitor sapien.\n\nSed tempus gravida nunc, a ultricies lacus ultricies non. Mauris nec condimentum sem. Morbi sed interdum velit. Nunc tincidunt, diam eget aliquam rutrum, erat neque ullamcorper mauris, in accumsan orci metus eget lectus. Nullam quam quam, maximus tristique lobortis ut, varius non urna. Curabitur tempus pharetra dui, nec consequat nulla lacinia quis. Etiam lobortis eros massa, non ullamcorper dui pharetra nec. Fusce ut dolor justo. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin sit amet finibus enim, eu iaculis massa. Nam ullamcorper sapien non sapien mattis porta. Phasellus ultrices tortor faucibus, dapibus quam ut, ullamcorper ante.';

    notifyListeners();
  }

  void showTranscriptDialog(BuildContext context, UploadedFile file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TranscriptBox(key: UniqueKey(), transcriptText: _transcription, file: file);
      },
    );
  }
}
