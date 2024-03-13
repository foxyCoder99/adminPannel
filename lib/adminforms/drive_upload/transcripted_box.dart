import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/admin/drive_modals/upload_modal.dart';
import 'package:advisorapp/providers/drive_providers/driveupload_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TranscriptBox extends StatelessWidget {
  final UploadedFile file;

  const TranscriptBox({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driveUploadProvider = Provider.of<DriveUploadProvider>(context);
    print({
      'object',
      file.issuesummary,
      '------',
      file.processingstatus,
      '=----------',
      file.resolutionsummary
    });
    return AlertDialog(
      backgroundColor: AppColors.secondaryBg,
      title: Text(
        'Summary : ${file.filename}',
        style: appstyle,
      ),
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
                child: file.processingstatus == 'completed'
                    ? Text(
                        '${file.issuesummary}\n${file.resolutionsummary}',
                        style: const TextStyle(fontSize: 14),
                      )
                    : Center(
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (file.processingstatus == 'pending')
                            const CircularProgressIndicator(),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            file.processingstatus,
                            style: TextStyle(
                                fontSize: 22,
                                color: file.processingstatus == "pending"
                                    ? Colors.blue
                                    : Colors.red),
                          )
                        ],
                      )),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              file.processingstatus == "completed"
                  ? ElevatedButton(
                      style: buttonStyleGreen,
                      onPressed: () {
                        _copyToClipboard(file.resolutionsummary, context);
                      },
                      child: const Text(
                        'Copy to clipboard',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : file.processingstatus == "pending"
                      ? ElevatedButton(
                          style: buttonStyleGreen,
                          onPressed: null,
                          child: const Text(
                            '... Pending',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ElevatedButton(
                          style: buttonStyleInvite,
                          onPressed: () {
                            driveUploadProvider.reprocessTranscript(
                                context, file);
                          },
                          child: const Text(
                            'Reprocess Transcription',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
              ElevatedButton(
                style: buttonStyleRed,
                onPressed: () {
                  Navigator.pop(context);
                   driveUploadProvider.reprocessTranscript(
                                context, file);
                  driveUploadProvider.fetchUploadedFiles();
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
