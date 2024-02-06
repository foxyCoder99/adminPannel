import 'package:advisorapp/adminforms/drive_upload/drive_uploads.dart';
import 'package:advisorapp/adminforms/reports/AccountPage.dart';
import 'package:advisorapp/adminforms/reports/EmpActionPage.dart';
import 'package:advisorapp/adminforms/reports/account_employer.dart';
import 'package:advisorapp/adminforms/reports/employer_partner.dart';
import 'package:advisorapp/adminforms/reports/account_invitation.dart';
import 'package:advisorapp/adminforms/reports/accountwiseaction_item.dart';
import 'package:advisorapp/adminforms/company_type/company_type.dart';
import 'package:advisorapp/adminforms/reports/unpaid_invoice.dart';
import 'package:advisorapp/adminforms/menu/menu_access.dart';
import 'package:advisorapp/adminforms/menu/menu_master.dart';
import 'package:advisorapp/adminforms/reports/paymentdetail_report.dart';
import 'package:advisorapp/adminforms/role/role.dart';
import 'package:advisorapp/adminforms/sidemenu/sidemenu.dart';
import 'package:advisorapp/adminforms/subscription/subscription.dart';
import 'package:advisorapp/adminforms/tax/tax.dart';
import 'package:advisorapp/adminforms/user/user.dart';
import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CentralForm extends StatelessWidget {
  const CentralForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Expanded(flex: 2, child: AdminSideMenu()),
          Expanded(
              flex: 10,
              child: SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Consumer<SidebarProvider>(
                    builder: (context, menuProvider, child) {
                  return Center(
                      child: (menuProvider.selectedMenu == "Company Type")
                          ? const CompanyType()
                          : (menuProvider.selectedMenu == "User Reports")
                              ? const UserFormPage()
                              : (menuProvider.selectedMenu == "Subscription")
                                  ? const SubscriptionFormPage()
                                  : (menuProvider.selectedMenu == "Role")
                                      ? const RoleFormPage()
                                      : (menuProvider.selectedMenu == "Menu")
                                          ? const MenuFormPage()
                                          : (menuProvider.selectedMenu ==
                                                  "Menu Access")
                                              ? const MenuAccessPage()
                                              : (menuProvider.selectedMenu ==
                                                      "Payment Detail")
                                                  ? const PaymentReportDetails()
                                                  : (menuProvider
                                                              .selectedMenu ==
                                                          "Account Detail")
                                                      ? const AccountPage()
                                                      : (menuProvider
                                                                  .selectedMenu ==
                                                              "Account Employer")
                                                          ? const AccountEmployer()
                                                          : (menuProvider
                                                                      .selectedMenu ==
                                                                  "Tax")
                                                              ? const TaxFormpage()
                                                              : (menuProvider
                                                                          .selectedMenu ==
                                                                      "Drive")
                                                                  ? const DriveUpload()
                                                                  : (menuProvider
                                                                              .selectedMenu ==
                                                                          "Unpaid Invoice")
                                                                      ? const UnpaidInvoice()
                                                                      : (menuProvider.selectedMenu ==
                                                                              "Employer Partner")
                                                                          ? const EmployerPartner()
                                                                          : (menuProvider.selectedMenu == "Account Invitation")
                                                                              ? const AccountInvitation()
                                                                              : (menuProvider.selectedMenu == "Account Wise Item")
                                                                                  ? const AccountActionItem()
                                                                                  : (menuProvider.selectedMenu == "Employer Wise Item")
                                                                                      ? const EmpActionPage()
                                                                                      : const Text('ADMIN PORTAL'));
                }),
              ))
        ]));
  }
}
