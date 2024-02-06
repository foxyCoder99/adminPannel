class UploadedFile {
  final String accountcode;
  final String filecode;
  final String filename;
  final String description;
  final String sharedfrom;
  final String uploadedby;
  final String uploadeddate;
  final String fileurl;

  final String fileExtension;
  final String filetype;
  // final String fileSize;
  final String filebase64;

  UploadedFile({
    required this.accountcode,
    required this.filecode,
    required this.filename,
    required this.description,
    required this.sharedfrom,
    required this.uploadedby,
    required this.uploadeddate,
    required this.fileurl,
    required this.fileExtension,
    required this.filetype,
    //  required this.fileSize,
    required this.filebase64,
  });
  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      accountcode: json['accountcode'] ?? '',
      filecode: json['filecode'] ?? '',
      filename: json['filename'] ?? '',
      description: json['description'] ?? '',
      sharedfrom: json['sharedfrom'] ?? '',
      uploadedby: json['uploadedby'] ?? '',
      uploadeddate: json['uploadeddate'] ?? '',
      fileurl: json['fileurl'] ?? '',

      fileExtension: json['fileExtension'] ?? '',
      filetype: json['filetype'] ?? '',
      //  fileSize: json['fileSize'] ?? '',
      filebase64: json['filebase64'] ?? '',
    );
  }
}

class ShareMail {
  final String accountcode;
  final String accountname;
  final String emailid;
  bool fileshare;

  ShareMail({
    required this.accountcode,
    required this.accountname,
    required this.emailid,
    required this.fileshare,
  });

  factory ShareMail.fromJson(Map<String, dynamic> json) {
    return ShareMail(
      accountcode: json['accountcode'] ?? '',
      accountname: json['accountname'] ?? '',
      emailid: json['emailid'] ?? '',
      fileshare: json['fileshare'] ?? false,
    );
  }
}

class SelectedEmail {
  final String emailId;
  final String accountcode;

  SelectedEmail(this.emailId, this.accountcode);
}
