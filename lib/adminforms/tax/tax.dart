import 'package:advisorapp/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/providers/taxform_provider.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:advisorapp/constants.dart';

class TaxFormpage extends StatelessWidget {
  const TaxFormpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taxProvider = Provider.of<TaxProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Form'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: buttonStyleGrey,
                onPressed: taxProvider.showForm,
                child: const Text(
                  '+ Add New Tax',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (taxProvider.isFormVisible)
                SizedBox(
                  width: SizeConfig.screenWidth / 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding,
                          horizontal: defaultPadding,
                        ),
                        child: TextFormField(
                          controller: taxProvider.taxnameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          decoration: CustomTextDecoration.textDecoration(
                            'Tax Name',
                            const Icon(
                              Icons.person,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding,
                          horizontal: defaultPadding,
                        ),
                        child: TextFormField(
                          controller: taxProvider.taxvalueController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          decoration: CustomTextDecoration.textDecoration(
                            'Tax Value',
                            const Icon(
                              Icons.numbers,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: buttonStyleGreen,
                              onPressed: () async {
                                await taxProvider.saveupdatetax(context);
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            ElevatedButton(
                              style: buttonStyleBlue,
                              onPressed: taxProvider.hideForm,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              if (taxProvider.isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else ...[
                if (taxProvider.taxDetails.isNotEmpty) ...[
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Tax Name')),
                      DataColumn(label: Text('Tax Value')),
                      DataColumn(label: Text('Update')),
                      DataColumn(label: Text('Delete')),
                    ],
                    rows: taxProvider.taxDetails.map((tax) {
                      return DataRow(cells: [
                        DataCell(Text(tax.taxName)),
                        DataCell(Text(tax.taxValue.toString())),
                        DataCell(IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            taxProvider.setSelectedTaxId(tax.id);
                            taxProvider.showForm();
                            taxProvider.setEditing(true);
                            taxProvider.taxnameController.text = tax.taxName;
                            taxProvider.taxvalueController.text =
                                tax.taxValue.toString();
                          },
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            String taxId = tax.id.toString();
                            taxProvider.deletetax(context, taxId);
                          },
                        )),
                      ]);
                    }).toList(),
                  ),
                ] else ...[
                  const Center(
                    child: Text(
                      'No Data Available',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
