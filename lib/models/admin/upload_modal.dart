class UploadedFile {
  final String accountcode;
  final String filename;
  final String filecode;
  final String fileExtension;
  final String fileType;
  // final String fileSize;
  final String description;
  final String filebase64;
  // final String uploadDate;

  UploadedFile({
    required this.accountcode,
    required this.filecode,
    required this.filename,
    required this.fileExtension,
    required this.fileType,
    // required this.fileSize,
    required this.description,
    required this.filebase64,
    // required this.uploadDate,
  });
  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      accountcode: json['accountcode'] ?? '',
      filecode: json['filecode'] ?? '',
      filename: json['filename'] ?? '',
      fileExtension: json['fileExtension'] ?? '',
      fileType: json['fileType'] ?? '',
      // fileSize: json['fileSize'] ?? '',
      description: json['description'] ?? '',
      filebase64: json['filebase64'] ?? '',
    );
  }

  static String determineFileType(String filename) {
    List<String> parts = filename.split('.');
    if (parts.length > 1) {
      String extension = parts.last.toLowerCase();
      switch (extension) {
        case 'jpg':
        case 'jpeg':
        case 'png':
        case 'gif':
          return 'Image';
        case 'mp3':
        case 'wav':
        case 'ogg':
          return 'Audio';
        case 'mp4':
        case 'avi':
        case 'mkv':
          return 'Video';
        case 'xls':
        case 'xlsx':
          return 'Excel';
        case 'doc':
        case 'docx':
          return 'Word';
        case 'pdf':
          return 'PDF';
        case 'zip':
          return 'ZIP';
        default:
          return 'Document';
      }
    } else {
      return 'Unknown';
    }
  }
}

class ShareMail {
  final String accountcode;
  final String accountname;
  final String emailid;
  final String filesharedfrom;

  ShareMail({
    required this.accountcode,
    required this.accountname,
    required this.emailid,
    required this.filesharedfrom,
  });

  factory ShareMail.fromJson(Map<String, dynamic> json) {
    return ShareMail(
      accountcode: json['accountcode'] ?? '',
      accountname: json['accountname'] ?? '',
      emailid: json['emailid'] ?? '',
      filesharedfrom: json['filesharedfrom'] ?? '',
    );
  }
}

class SelectedEmail {
  final String emailId;
  final String accountcode;

  SelectedEmail(this.emailId, this.accountcode);
}
