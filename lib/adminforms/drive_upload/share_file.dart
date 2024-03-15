import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/search_text_field.dart';
import 'package:advisorapp/providers/drive_providers/sharefile_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareFile extends StatelessWidget {
  final String filecode;
  final String accountcode;

  const ShareFile({
    Key? key,
    required this.filecode,
    required this.accountcode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shareFileProvider = Provider.of<ShareFileProvider>(context);

    return AlertDialog(
      backgroundColor: AppColors.secondaryBg,
      title: const Text('Share With'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: TextFieldTapRegion(
              onTapOutside: (event) {
                shareFileProvider.searchEmailFocused = false;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(28),
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
                    CustomSearchTextField(
                      hintText: 'Search Emails...',
                      onChanged: (value) {
                        shareFileProvider.searchEmailQuery = value;
                      },
                      onTap: (() {
                        shareFileProvider.searchEmailFocused = true;
                      }),
                    ),
                    shareFileProvider.searchEmailFocused
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _toggleButton(
                                    context, shareFileProvider, 'partner'),
                                _toggleButton(
                                    context, shareFileProvider, 'employer'),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: SizedBox(
              width: SizeConfig.screenWidth / 3,
              height: SizeConfig.screenHeight / 5,
              child: ListView.separated(
                padding: const EdgeInsets.all(2.0),
                itemCount: shareFileProvider.filteredEmails.length,
                itemBuilder: (BuildContext context, int index) {
                  final email = shareFileProvider.filteredEmails[index];
                  return Consumer<ShareFileProvider>(
                      builder: (context, ShareFileProvider, _) {
                    if (accountcode != email.accountcode) {
                      return CheckboxListTile(
                          title: Text(email.accountname),
                          subtitle: Text(email.emailid),
                          value: email.fileshare,
                          onChanged: (value) {
                            ShareFileProvider.toggleSelectedEmail(
                                email, value ?? false);
                          });
                    } else {
                      return const SizedBox();
                    }
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
                onPressed: () async {
                  await shareFileProvider.fileSharingEmails(
                      filecode, accountcode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File shared successfully.'),
                    ),
                  );
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
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(BuildContext context,
      ShareFileProvider shareFileProvider, String category) {
    final isSelected = shareFileProvider.selectedType.contains(category);
    return ElevatedButton(
      onPressed: () {
        shareFileProvider.toggleCategory(category);
        shareFileProvider.searchEmailFocused = false;
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
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}
