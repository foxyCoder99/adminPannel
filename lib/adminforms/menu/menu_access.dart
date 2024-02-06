import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/providers/menuaccess_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuAccessPage extends StatelessWidget {
  const MenuAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuAccessProvider = Provider.of<MenuAccessProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Access'),
      ),
      body: SizedBox(
        width: SizeConfig.screenWidth / 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoleDropdown(menuAccessProvider),
              const SizedBox(height: 16.0),
              if (menuAccessProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                _buildMenuDataTable(menuAccessProvider),
              const SizedBox(height: 16.0),
              SizedBox(
                width: SizeConfig.screenWidth / 3,
                child: Visibility(
                  visible: menuAccessProvider.isUpdateBtn &&
                      menuAccessProvider.menuList.isNotEmpty,
                  child: Center(
                    child: ElevatedButton(
                      style: buttonStyleBlue,
                      onPressed: () {
                        if (menuAccessProvider.menuList.isNotEmpty) {
                          menuAccessProvider.updateCheckedMenus(context);
                        }
                      },
                      child: const Text('Update',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown(MenuAccessProvider menuAccessProvider) {
    Set<String> uniqueRoleValues = <String>{};
    return SizedBox(
      width: SizeConfig.screenWidth / 3,
      child: DropdownButtonFormField(
        value: menuAccessProvider.selectedUserRole.isNotEmpty
            ? menuAccessProvider.selectedUserRole
            : menuAccessProvider.userRoles.isNotEmpty
                ? menuAccessProvider.userRoles.first
                : null,
        items: menuAccessProvider.userRoles
            .where((role) => uniqueRoleValues.add(role))
            .map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: (value) {
          menuAccessProvider.selectedUserRole = value ?? '';
          menuAccessProvider.setSelectedRole();
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
    );
  }

  Widget _buildMenuDataTable(MenuAccessProvider menuAccessProvider) {
    if (menuAccessProvider.menuList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }
    return DataTable(
      columns: const [
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Menu')),
        DataColumn(label: Text('View Access')),
        DataColumn(label: Text('Trxn Access')),
      ],
      rows: menuAccessProvider.menuList
          .map(
            (menu) => DataRow(
              cells: [
                DataCell(Text(menu.rolename)),
                DataCell(Text(menu.menuname)),
                DataCell(Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Checkbox(
                    value: menu.access,
                    onChanged: (value) {
                      menuAccessProvider.updateViewAccess(menu, value ?? false);
                    },
                  ),
                )),
                DataCell(Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Checkbox(
                    value: menu.trxnaccess,
                    onChanged: (value) {
                      menuAccessProvider.updatetrxnaccess(menu, value ?? false);
                    },
                  ),
                )),
              ],
            ),
          )
          .toList(),
    );
  }
}
