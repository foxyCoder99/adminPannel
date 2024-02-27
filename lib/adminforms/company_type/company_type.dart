import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/cirlular_loader.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/custom/search_text_field.dart';
import 'package:advisorapp/providers/companytype_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/component/background.dart';

class CompanyType extends StatelessWidget {
  const CompanyType({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final companyTypeProvider = Provider.of<CompanyTypeProvider>(context);
    double defaultwidth = SizeConfig.screenWidth;

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
                  TextButton(
                      onPressed: () {
                        companyTypeProvider.showForm();
                        companyTypeProvider.resetForm();
                      },
                      child: const Text(
                        ' + Add a new Company Type',
                        style: appstyle,
                      )),
                  const SizedBox(height: 16.0),
                  if (companyTypeProvider.isFormVisible)
                    _buildCompanyForm(context, companyTypeProvider),
                  SizedBox(
                    width: defaultwidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding,
                      ),
                      child: CustomSearch(
                        onChanged: (value) {
                          companyTypeProvider.searchQuery = value;
                        },
                        hintText: 'Search by company type name ...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (companyTypeProvider.isLoading)
                    const CirlularLoader()
                  else
                    _buildCompanyDataTable(context, companyTypeProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyForm(
      BuildContext context, CompanyTypeProvider companyTypeProvider) {
    double defaultwidth = SizeConfig.screenWidth;
    return SizedBox(
      width: defaultwidth / 3,
      child: Form(
        key: companyTypeProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: companyTypeProvider.typenameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter Company type Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Company type Name',
                  const Icon(
                    Icons.corporate_fare,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0, width: 250),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: buttonStyleGreen,
                  onPressed: () {
                    companyTypeProvider.formKey.currentState?.validate();
                    if (companyTypeProvider.formKey.currentState?.validate() ??
                        false) {
                      companyTypeProvider.saveCompanyType(context);
                    }
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    companyTypeProvider.cancelTypeForm(context);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDataTable(
      BuildContext context, CompanyTypeProvider companyTypeProvider) {
    double defaultwidth = SizeConfig.screenWidth;

    final typeList = companyTypeProvider.filteredCompanyTypeList;
    if (typeList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: defaultwidth / 3,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Type Name')),
              DataColumn(label: Text('Actions')),
            ],
            rows: typeList
                .map(
                  (companyType) => DataRow(
                    cells: [
                      DataCell(Text(companyType.typename)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                companyTypeProvider.editCompanyType(
                                    context, companyType);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                          "Are you sure you want to delete this Company Type?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            companyTypeProvider
                                                .deleteAdvisorCompanyType(
                                                    companyType.id.toString());
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
