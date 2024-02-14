import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/providers/menu_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuFormPage extends StatelessWidget {
  const MenuFormPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
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
                      menuProvider.showForm();
                      menuProvider.resetForm();
                    },
                    child: const Text(
                      '+ Add a new menu',
                      style: appstyle,
                    )),
                const SizedBox(height: 16.0),
                if (menuProvider.isFormVisible)
                  _buildmenuForm(context, menuProvider),
                SizedBox(
                  width: defaultwidth / 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding,
                    ),
                    child: SizedBox(
                      width: defaultwidth / 3,
                      child: TextField(
                        onChanged: (value) {
                          menuProvider.searchQuery = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Search by menu name',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                if (menuProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  _buildmenuDataTable(context, menuProvider),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildmenuForm(BuildContext context, MenuProvider menuProvider) {
    double defaultwidth = SizeConfig.screenWidth;

    return SizedBox(
      width: defaultwidth / 3,
      child: Form(
        key: menuProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: menuProvider.menunameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter menu Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'menu Name',
                  const Icon(
                    Icons.person,
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
                    menuProvider.formKey.currentState?.validate();
                    if (menuProvider.formKey.currentState?.validate() ??
                        false) {
                      menuProvider.savemenu(context);
                    }
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    menuProvider.cancelmenuForm(context);
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

  Widget _buildmenuDataTable(BuildContext context, MenuProvider menuProvider) {
    final menuList = menuProvider.filteredmenuList;
    double defaultwidth = SizeConfig.screenWidth;

    if (menuList.isEmpty) {
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
              DataColumn(label: Text('Menu Name')),
              DataColumn(label: Text('Actions')),
            ],
            rows: menuList
                .map(
                  (menu) => DataRow(
                    cells: [
                      DataCell(Text(menu.menuname)),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                menuProvider.editmenu(context, menu);
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
                                          "Are you sure you want to delete this menu?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            menuProvider.deleteAdvisorAdminmenu(
                                                menu.id.toString());
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
