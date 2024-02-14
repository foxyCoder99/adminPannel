//company_category.dart
import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/providers/companycategory_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyCategory extends StatelessWidget {
  const CompanyCategory({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final companycategoryProvider =
        Provider.of<CompanyCategoryProvider>(context);
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
                        companycategoryProvider.showForm();
                        companycategoryProvider.resetForm();
                      },
                      child: const Text(
                        ' + Add a new Company Category',
                        style: appstyle,
                      )),
                  const SizedBox(height: 16.0),
                  if (companycategoryProvider.isFormVisible)
                    _buildCompanyForm(context, companycategoryProvider),
                  SizedBox(
                    width: defaultwidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          companycategoryProvider.searchQuery = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Search by company category name ...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (companycategoryProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildCompanyDataTable(context, companycategoryProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyForm(
      BuildContext context, CompanyCategoryProvider companyCategoryProvider) {
    double defaultwidth = SizeConfig.screenWidth;
    return SizedBox(
      width: defaultwidth / 3,
      child: Form(
        key: companyCategoryProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: companyCategoryProvider.typenameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter Company Category Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Company Category Name',
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
                    companyCategoryProvider.formKey.currentState?.validate();
                    if (companyCategoryProvider.formKey.currentState
                            ?.validate() ??
                        false) {
                      companyCategoryProvider.saveCompanyCategory(context);
                    }
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    companyCategoryProvider.cancelTypeForm(context);
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
      BuildContext context, CompanyCategoryProvider companyCategoryProvider) {
    double defaultwidth = SizeConfig.screenWidth;

    final typeList = companyCategoryProvider.filteredCompanyTypeList;
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
              DataColumn(label: Text('Category Name')),
              DataColumn(label: Text('Actions')),
            ],
            rows: typeList
                .map(
                  (Category) => DataRow(
                    cells: [
                      DataCell(Text(Category.name)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                companyCategoryProvider.editCompanyCategory(
                                    context, Category);
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
                                          "Are you sure you want to delete this Company category?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            companyCategoryProvider
                                                .deleteCompanyCategory(
                                                    Category.id.toString());
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
