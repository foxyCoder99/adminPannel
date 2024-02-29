import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/drive_modals/upload_modal.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TranscriptBox extends StatelessWidget {
  final String transcriptText;
  final UploadedFile file;

  const TranscriptBox(
      {Key? key, required this.transcriptText, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryBg,
      title: Text('Transcripted Text : ${file.filename}',style: appstyle,),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.screenHeight / 2,
            width: SizeConfig.screenWidth / 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(138, 255, 255, 255),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  transcriptText,
                  style: const TextStyle(fontSize: 14),
                ),
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
                  _copyToClipboard(transcriptText, context);
                },
                child: const Text(
                  'Copy text',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: buttonStyleRed,
                onPressed: () {
                  Navigator.pop(context);
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
  }
}

void _copyToClipboard(String text, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Transcript copied to clipboard')),
  );
}
