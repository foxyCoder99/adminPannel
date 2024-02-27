import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AdminSideMenu extends StatelessWidget {
  const AdminSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sidebarProvider = Provider.of<SidebarProvider>(context);

    return SizedBox(
      width: SizeConfig.screenWidth / 7,
      child: Container(
          width: SizeConfig.screenWidth / 7,
          height: SizeConfig.screenHeight,
          decoration: const BoxDecoration(
              color: AppColors.sidemenu,
              border: Border(right: BorderSide(color: AppColors.sidemenu))),
          child: Stack(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight / 1.1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ),
                      ExpansionTile(
                        title: const Text(
                          'Master',
                          style: sideMenuStyle,
                        ),
                        leading: const SizedBox(
                          width: 20,
                          child: Icon(
                            Icons.manage_history,
                            color: AppColors.iconGray,
                          ),
                        ),
                        children: [
                          buildReportSubMenu(
                            context,
                            'Subscription',
                            'Subscription',
                            Icons.subscriptions,
                            () {
                              sidebarProvider.selectedMenu = 'Subscription';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Tax',
                            'Tax',
                            Icons.payment,
                            () {
                              sidebarProvider.selectedMenu = 'Tax';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Company Type',
                            'Company Type',
                            Icons.corporate_fare,
                            () {
                              sidebarProvider.selectedMenu = 'Company Type';
                            },
                          ),
                                   buildReportSubMenu(
                            context,
                            'Company Category',
                            'Company Category',
                            Icons.corporate_fare,
                            () {
                              sidebarProvider.selectedMenu = 'Company Category';
                            },
                          )
                        ],
                      ),

                      /* Container(
                        decoration: BoxDecoration(
                            color:
                                (sidebarProvider.selectedMenu == 'Subscription')
                                    ? const Color.fromARGB(255, 234, 231, 231)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.subscriptions,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Subscription',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Subscription';
                            //Navigator.pushNamed(context, "/Subscription");
                          },
                        ),
                      ), */
                      ExpansionTile(
                        title: const Text(
                          'Role & Access',
                          style: sideMenuStyle,
                        ),
                        leading: const SizedBox(
                          width: 20,
                          child: Icon(
                            Icons.description,
                            color: AppColors.iconGray,
                          ),
                        ),
                        children: [
                          buildReportSubMenu(
                            context,
                            'Role',
                            'Role',
                            Icons.supervisor_account_outlined,
                            () {
                              sidebarProvider.selectedMenu = 'Role';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Menu',
                            'Menu',
                            Icons.menu,
                            () {
                              sidebarProvider.selectedMenu = 'Menu';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Menu Access',
                            'Menu Access',
                            Icons.accessibility,
                            () {
                              sidebarProvider.selectedMenu = 'Menu Access';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Users',
                            'Users',
                            Icons.face_6,
                            () {
                              sidebarProvider.selectedMenu = 'Users';
                            },
                          )
                        ],
                      ),

                      /*  Container(
                        decoration: BoxDecoration(
                            color: (sidebarProvider.selectedMenu == 'Role')
                                ? const Color.fromARGB(255, 234, 231, 231)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.supervisor_account_outlined,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Role',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Role';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ), */
                      /* Container(
                        decoration: BoxDecoration(
                            color: (sidebarProvider.selectedMenu == 'Menu')
                                ? const Color.fromARGB(255, 234, 231, 231)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.menu,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Menu',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Menu';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ), */
                      /* Container(
                        decoration: BoxDecoration(
                            color:
                                (sidebarProvider.selectedMenu == 'Menu Access')
                                    ? const Color.fromARGB(255, 234, 231, 231)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            child: Icon(
                              Icons.menu_book,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Menu Access',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Menu Access';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ), */
                      /*  Container(
                        decoration: BoxDecoration(
                            color: (sidebarProvider.selectedMenu == 'Users')
                                ? const Color.fromARGB(255, 234, 231, 231)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: SizedBox(
                            width: 20,
                            child: SvgPicture.asset(
                              'assets/account.svg',
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Users',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Users';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ), */
                      /* Container(
                        decoration: BoxDecoration(
                            color:
                                (sidebarProvider.selectedMenu == 'Company Type')
                                    ? const Color.fromARGB(255, 234, 231, 231)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            // child: SvgPicture.asset(
                            //   'assets/workspace.svg',
                            //   color: AppColors.iconGray,
                            // ),
                            child: Icon(
                              Icons.corporate_fare,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Company Type',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Company Type';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ), */
                      /* Container(
                        decoration: BoxDecoration(
                            color: (sidebarProvider.selectedMenu == 'Tax')
                                ? const Color.fromARGB(255, 234, 231, 231)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            // child: SvgPicture.asset(
                            //   'assets/workspace.svg',
                            //   color: AppColors.iconGray,
                            // ),
                            child: Icon(
                              Icons.payment,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Tax',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Tax';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ), */
                      Container(
                        decoration: BoxDecoration(
                            color: (sidebarProvider.selectedMenu == 'Drive')
                                ? const Color.fromARGB(255, 234, 231, 231)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: ListTile(
                          leading: const SizedBox(
                            width: 20,
                            // child: SvgPicture.asset(
                            //   'assets/workspace.svg',
                            //   color: AppColors.iconGray,
                            // ),
                            child: Icon(
                              Icons.drive_file_move,
                              color: AppColors.iconGray,
                            ),
                          ),
                          title: const Text(
                            'Drive',
                            style: sideMenuStyle,
                          ),
                          onTap: () {
                            sidebarProvider.selectedMenu = 'Drive';
                            //Navigator.pushNamed(context, "/Invoice");
                          },
                        ),
                      ),
                      ExpansionTile(
                        title: const Text(
                          'Reports',
                          style: sideMenuStyle,
                        ),
                        leading: const SizedBox(
                          width: 20,
                          child: Icon(
                            Icons.description,
                            color: AppColors.iconGray,
                          ),
                        ),
                        children: [
                          buildReportSubMenu(
                            context,
                            'Payment Detail',
                            'Payment Detail',
                            Icons.payments,
                            () {
                              sidebarProvider.selectedMenu = 'Payment Detail';
                            },
                          ),
                            buildReportSubMenu(
                            context,
                            'TREE',
                            'TREE',
                            Icons.payments,
                            () {
                              sidebarProvider.selectedMenu = 'TREE';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Account Detail',
                            'Account Detail',
                            Icons.account_balance_wallet,
                            () {
                              sidebarProvider.selectedMenu = 'Account Detail';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Account Employer',
                            'Account Employer',
                            Icons.account_balance,
                            () {
                              sidebarProvider.selectedMenu = 'Account Employer';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Employer Partner',
                            'Employer Partner',
                            Icons.work,
                            () {
                              sidebarProvider.selectedMenu = 'Employer Partner';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Account Invitation',
                            'Account Invitation',
                            Icons.switch_account,
                            () {
                              sidebarProvider.selectedMenu =
                                  'Account Invitation';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Account Wise Item',
                            'Account Wise Item',
                            Icons.account_tree_rounded,
                            () {
                              sidebarProvider.selectedMenu =
                                  'Account Wise Item';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Employer Wise Item',
                            'Employer Wise Item',
                            Icons.work_outline_outlined,
                            () {
                              sidebarProvider.selectedMenu =
                                  'Employer Wise Item';
                            },
                          ),
                          buildReportSubMenu(
                            context,
                            'Unpaid Invoice',
                            'Unpaid Invoice',
                            Icons.insert_drive_file,
                            () {
                              sidebarProvider.selectedMenu = 'Unpaid Invoice';
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment(0, 1),
                child: ListTile(
                  title: Text('Need help?'),
                  subtitle: Text('support@alicorn.co'),
                ),
              ),
            ],
          )
          // })
          ),
    );
  }

  Widget buildReportSubMenu(BuildContext context, String title,
      String selectedMenu, IconData icon, VoidCallback onTap) {
    final sidebarProvider = Provider.of<SidebarProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: (sidebarProvider.selectedMenu == selectedMenu)
            ? const Color.fromARGB(255, 234, 231, 231)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: ListTile(
          leading: SizedBox(
            width: 18,
            child: Icon(
              icon,
              color: AppColors.iconGray,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
