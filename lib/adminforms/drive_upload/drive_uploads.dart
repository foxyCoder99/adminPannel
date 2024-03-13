import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/custom/search_text_field.dart';
import 'package:advisorapp/providers/drive_providers/sharefile_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/providers/drive_providers/driveupload_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DriveUpload extends StatelessWidget {
  const DriveUpload({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final driveUploadProvider = Provider.of<DriveUploadProvider>(context);
    return Background(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.screenHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          backgroundColor: AppColors.action,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () {
                        driveUploadProvider.showForm();
                        driveUploadProvider.resetForm();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'New',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (driveUploadProvider.isFormVisible)
                    _buildUploadForm(context, driveUploadProvider),
                  SizedBox(
                    width: SizeConfig.screenWidth / 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: TextFieldTapRegion(
                        onTapOutside: (event) {
                          driveUploadProvider.searchFocused = false;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 3,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Consumer<DriveUploadProvider>(
                                  builder: (context, driveUploadProvider, _) {
                                return CustomSearchTextField(
                                  hintText: 'Search files...',
                                  onChanged: (value) {
                                    driveUploadProvider.searchQuery = value;
                                  },
                                  onTap: (() {
                                    driveUploadProvider.searchFocused = true;
                                  }),
                                );
                              }),
                              Consumer<DriveUploadProvider>(
                                  builder: (context, driveUploadProvider, _) {
                                return driveUploadProvider.searchFocused
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        child: Wrap(
                                          spacing: 10.0,
                                          runSpacing: 8.0,
                                          children: [
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'word'),
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'excel'),
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'pdf'),
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'image'),
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'audio'),
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'video'),
                                            _buildCategoryButton(context,
                                                driveUploadProvider, 'zip'),
                                            _buildCategoryButton(
                                                context,
                                                driveUploadProvider,
                                                'document'),
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16.0),
                  driveUploadProvider.isLoading
                      ? SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .background
                                          .withOpacity(0.08);
                                    }
                                    return AppColors.secondaryBg;
                                  }),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.zero,
                                      topRight: Radius.zero,
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    border:
                                        Border.all(color: AppColors.secondary),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('File Name')),
                                    DataColumn(label: Text('File Type')),
                                    DataColumn(label: Text('Description')),
                                    DataColumn(label: Text('Upload Date')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: driveUploadProvider
                                          .filteredFiles.isNotEmpty
                                      ? driveUploadProvider.filteredFiles
                                          .map((file) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                InkWell(
                                                  onTap: () {
                                                    if (file
                                                        .fileurl.isNotEmpty) {
                                                      launchUrl(Uri.parse(
                                                          file.fileurl));
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      _getIconForFiletype(
                                                          driveUploadProvider
                                                              .determineFiletype(
                                                                  file.filename)),
                                                      const SizedBox(width: 8),
                                                      SizedBox(
                                                        width: SizeConfig
                                                                .screenWidth /
                                                            4,
                                                        child: Text(
                                                          file.filename,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            decoration: file
                                                                    .fileurl
                                                                    .isNotEmpty
                                                                ? TextDecoration
                                                                    .underline
                                                                : TextDecoration
                                                                    .none,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              DataCell(Text(file.filetype)),
                                              DataCell(Text(file.description)),
                                              DataCell(Text(file.uploadeddate)),
                                              DataCell(file.sharedfrom
                                                          .toString() ==
                                                      ''
                                                  ? Center(
                                                      child: PopupMenuButton(
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                          PopupMenuItem(
                                                            child:
                                                                const ListTile(
                                                              title: Text(
                                                                  'Delete'),
                                                              leading: Icon(
                                                                  Icons.delete),
                                                            ),
                                                            onTap: () {
                                                              driveUploadProvider
                                                                  .showDeleteConfirmationDialog(
                                                                      context,
                                                                      file);
                                                            },
                                                          ),
                                                          PopupMenuItem(
                                                            child:
                                                                const ListTile(
                                                              title:
                                                                  Text('Share'),
                                                              leading: Icon(
                                                                Icons.share,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Provider.of<ShareFileProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .showShareDialog(
                                                                      context,
                                                                      file.filecode,
                                                                      file.accountcode);
                                                            },
                                                          ),
                                                          if (driveUploadProvider
                                                                      .determineFiletype(file
                                                                          .filename)
                                                                      .toLowerCase() ==
                                                                  'audio' ||
                                                              driveUploadProvider
                                                                      .determineFiletype(
                                                                          file.filename)
                                                                      .toLowerCase() ==
                                                                  'video')
                                                            PopupMenuItem(
                                                              child:
                                                                  const ListTile(
                                                                title: Text(
                                                                    'Transcripted Text'),
                                                                leading: Icon(
                                                                  Icons
                                                                      .transcribe,
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                driveUploadProvider
                                                                    .showTranscriptDialog(
                                                                        context,
                                                                        file);
                                                              },
                                                            ),
                                                        ],
                                                        offset:
                                                            const Offset(0, 40),
                                                        child: const Icon(
                                                            Icons.more_vert),
                                                      ),
                                                    )
                                                  : Text(file.sharedfrom)),
                                            ],
                                          );
                                        }).toList()
                                      : [
                                          const DataRow(
                                            cells: [
                                              DataCell(
                                                SizedBox(
                                                  child: Center(
                                                    child: Text(
                                                      'Please Upload File',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(SizedBox()),
                                              DataCell(SizedBox()),
                                              DataCell(SizedBox()),
                                              DataCell(SizedBox()),
                                            ],
                                          ),
                                        ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadForm(
    BuildContext context,
    DriveUploadProvider driveUploadProvider,
  ) {
    return SizedBox(
      width: SizeConfig.screenWidth / 2,
      child: Form(
        key: driveUploadProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: defaultPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_file,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.sidemenu,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.loose(
                                          const Size.fromWidth(150)),
                                      child: Text(
                                        driveUploadProvider.selectedFile != null
                                            ? driveUploadProvider
                                                .selectedFile!.name
                                            : 'Browse File...',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 4,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.5),
                                          backgroundColor: AppColors.iconGray,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePickerWeb.platform
                                                .pickFiles(
                                          type: FileType.any,
                                          allowMultiple: false,
                                        );
                                        if (result != null) {
                                          // String? filePath =
                                          //     result.files.single.path;
                                          // if (filePath != null) {
                                          //   print("File Path: $filePath");
                                          // }
                                          // driveUploadProvider.filePath = filePath!;
                                          PlatformFile file =
                                              result.files.single;
                                          driveUploadProvider
                                              .setSelectedFile(file);
                                        } else {
                                          print('User canceled file picker');
                                        }
                                      },
                                      child: const Text(
                                        'Browse',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: driveUploadProvider.selectedFileType,
                      items: const [
                        DropdownMenuItem(
                          value: 'DOC',
                          child: Text('Document'),
                        ),
                        DropdownMenuItem(
                          value: 'AV',
                          child: Text('Audio/Video'),
                        ),
                      ],
                      onChanged: (newValue) {
                        driveUploadProvider.selectedFileType = newValue ?? '';
                      },
                      decoration: CustomTextDecoration.textDecoration(
                        'File Type',
                        const Icon(
                          Icons.video_file,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: defaultPadding,
              ),
              child: TextFormField(
                controller: driveUploadProvider.fileDescpController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                decoration: CustomTextDecoration.textDecoration(
                  'File Description',
                  const Icon(
                    Icons.description,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: buttonStyleGreen,
                  onPressed: () {
                    driveUploadProvider.formKey.currentState?.validate();
                    if (driveUploadProvider.formKey.currentState?.validate() ??
                        false) {
                      if (driveUploadProvider.selectedFile != null) {
                        driveUploadProvider.uploadFile(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please choose a file to upload.'),
                          ),
                        );
                      }
                    }
                  },
                  child: driveUploadProvider.uploadingFile
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Upload',
                          style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    driveUploadProvider.cancelmenuForm(context);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context,
      DriveUploadProvider driveUploadProvider, String category) {
    final isSelected =
        driveUploadProvider.selectedCategories.contains(category);
    return ElevatedButton(
      onPressed: () {
        driveUploadProvider.toggleCategory(category);
        driveUploadProvider.searchFocused = false;
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.5),
          backgroundColor:
              isSelected ? Colors.blue.shade100 : Colors.grey.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? Colors.blue.shade400 : Colors.grey.shade50,
                width: 2.0,
              ))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: _getIconForFiletype(category),
          ),
          Text(
            category.toUpperCase(),
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Icon _getIconForFiletype(String filetype) {
    switch (filetype.toLowerCase()) {
      case 'image':
        return const Icon(
          FontAwesomeIcons.image,
          color: Colors.lightBlue,
        );
      case 'audio':
        return const Icon(
          FontAwesomeIcons.fileAudio,
          color: Colors.orange,
        );
      case 'video':
        return const Icon(
          FontAwesomeIcons.video,
          color: Color.fromARGB(255, 95, 18, 167),
        );
      case 'excel':
        return const Icon(
          FontAwesomeIcons.fileExcel,
          color: Colors.green,
        );
      case 'word':
        return const Icon(
          FontAwesomeIcons.fileWord,
          color: Colors.blue,
        );
      case 'pdf':
        return const Icon(
          FontAwesomeIcons.filePdf,
          color: Colors.red,
        );
      case 'zip':
        return const Icon(
          FontAwesomeIcons.fileZipper,
          color: Colors.amber,
        );
      default:
        return const Icon(
          FontAwesomeIcons.file,
          color: Colors.purple,
        );
    }
  }
}
