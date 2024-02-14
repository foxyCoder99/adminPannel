import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/providers/userform_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFormPage extends StatelessWidget {
  const UserFormPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
                        userProvider.showForm();
                        userProvider.resetForm();
                      },
                      child: const Text(
                        '+ Add a new user',
                        style: appstyle,
                      )),
                  const SizedBox(height: 16.0),
                  if (userProvider.isFormVisible)
                    _buildUserForm(context, userProvider),
                  SizedBox(
                    width: SizeConfig.screenWidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          userProvider.searchQuery = value;
                        },
                        decoration: const InputDecoration(
                          labelText:
                              'Search by username, emailid, rolename ... ',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (userProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildUserDataTable(context, userProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserForm(BuildContext context, UserProvider userProvider) {
    Set<String> uniqueRoleValues = <String>{};
    return SizedBox(
      width: SizeConfig.screenWidth / 3,
      child: Form(
        key: userProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: userProvider.firstnameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter First Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'First Name',
                  const Icon(
                    Icons.person,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: userProvider.lastnameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter Last Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Last Name',
                  const Icon(
                    Icons.person,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: userProvider.emailIdController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                enabled: !userProvider.isEditing,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please Enter Email ID';
                  } else if (!(RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(value ?? ''))) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Email ID',
                  const Icon(
                    Icons.email,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: DropdownButtonFormField(
                value: userProvider.selectedUserRole.isNotEmpty
                    ? userProvider.selectedUserRole
                    : userProvider.userRoles.isNotEmpty
                        ? userProvider.userRoles.first
                        : null,
                items: userProvider.userRoles
                    .where((role) => uniqueRoleValues.add(role))
                    .map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  userProvider.selectedUserRole = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'User Roles',
                  const Icon(
                    Icons.supervisor_account_outlined,
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
                    userProvider.formKey.currentState?.validate();
                    if (userProvider.formKey.currentState?.validate() ??
                        false) {
                      userProvider.saveUser(context);
                    }
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    userProvider.cancelUserForm(context);
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

  Widget _buildUserDataTable(BuildContext context, UserProvider userProvider) {
    final userList = userProvider.filteredUserList;
    if (userList.isEmpty) {
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
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email ID')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Actions')),
          ],
          rows: userList
              .map(
                (user) => DataRow(
                  cells: [
                    DataCell(Text(user.username)),
                    DataCell(Text(user.emailid)),
                    DataCell(Text(user.rolename)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              userProvider.editUser(context, user);
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
                                        "Are you sure you want to delete this user?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          userProvider.deleteAdvisorAdminUser(
                                              user.usercode);
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
    );
  }
}
