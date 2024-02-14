import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/providers/roleform_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleFormPage extends StatelessWidget {
  const RoleFormPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);
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
                      roleProvider.showForm();
                      roleProvider.resetForm();
                    },
                    child: const Text(
                      '+ Add a new role',
                      style: appstyle,
                    )),
                const SizedBox(height: 16.0),
                if (roleProvider.isFormVisible)
                  _buildRoleForm(context, roleProvider),
                SizedBox(
                  width: defaultwidth / 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        roleProvider.searchQuery = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search by role name',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                if (roleProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  _buildRoleDataTable(context, roleProvider),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildRoleForm(BuildContext context, RoleProvider roleProvider) {
    double defaultwidth = SizeConfig.screenWidth;
    return SizedBox(
      width: defaultwidth / 3,
      child: Form(
        key: roleProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: roleProvider.rolenameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter Role Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Role Name',
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
                    roleProvider.formKey.currentState?.validate();
                    if (roleProvider.formKey.currentState?.validate() ??
                        false) {
                      roleProvider.saverole(context);
                    }
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    roleProvider.cancelroleForm(context);
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

  Widget _buildRoleDataTable(BuildContext context, RoleProvider roleProvider) {
    double defaultwidth = SizeConfig.screenWidth;
    final roleList = roleProvider.filteredRoleList;
    if (roleList.isEmpty) {
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
              DataColumn(label: Text('Role Name')),
              DataColumn(label: Text('Actions')),
            ],
            rows: roleList
                .map(
                  (role) => DataRow(
                    cells: [
                      DataCell(Text(role.rolename)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                roleProvider.editRole(context, role);
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
                                          "Are you sure you want to delete this role?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            roleProvider.deleteAdvisorAdminrole(
                                                role.rolecode);
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
