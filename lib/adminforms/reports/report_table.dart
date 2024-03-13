import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/search_text_field.dart';
import 'package:advisorapp/models/admin/report_modals/reporttable_modal.dart';
import 'package:advisorapp/providers/report_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:provider/provider.dart';

class ReportTable extends StatelessWidget {
  late final ExpandableTableController controller;
  final List<String> accountDataHeaders = [
    'accountname',
    "worktitle",
    "phonenumber",
    "workemail",
    "companydomainname",
    "naicscode",
    "companyname",
    "companyaddress",
    "companyphonenumber",
    "fancyname",
  ];

  ReportTable({Key? key}) : super(key: key) {
    controller = ExpandableTableController(
      firstHeaderCell: _buildHeaderCell('Advisor Data'),
      rows: [],
      headers: accountDataHeaders
          .map(
            (key) => ExpandableTableHeader(
              cell: _buildHeaderCell(key),
            ),
          )
          .toList(),
      headerHeight: 80,
      defaultsColumnWidth: 220,
    );
  }

  String _getValueForHeader(String header, AccountData accountData) {
    switch (header) {
      case 'accountname':
        return '${accountData.accountname} ${accountData.lastname}';
      case 'worktitle':
        return accountData.worktitle ?? '';
      case 'phonenumber':
        return accountData.phonenumber ?? '';
      case 'workemail':
        return accountData.workemail ?? '';
      // case 'accountrole':
      //   return accountData.accountrole ?? '';
      case 'companydomainname':
        return accountData.companydomainname ?? '';
      case 'naicscode':
        return accountData.naicscode ?? '';
      case 'companyname':
        return accountData.companyname ?? '';
      // case 'typeofcompany':
      //   return accountData.typeofcompany ?? '';
      // case 'companycategory':
      //   return accountData.companycategory ?? '';
      case 'companyaddress':
        return accountData.companyaddress ?? '';
      case 'companyphonenumber':
        return accountData.companyphonenumber ?? '';
      // case 'accountpaymentinfo':
      //   return accountData.accountpaymentinfo ?? '';
      case 'fancyname':
        return accountData.fancyname ?? '';
      // case 'status':
      //   return accountData.status.toString();
      default:
        return '';
    }
  }

  String _getValueForEmployerHeader(String header, employerData) {
    switch (header) {
      case 'companydomain':
        return employerData.companydomain ?? '';
      case 'companyname':
        return employerData.companyname ?? '';
      case 'companyaddress':
        return employerData.companyaddress ?? '';
      case 'companyphoneno':
        return employerData.companyphoneno ?? '';
      case 'companytypename':
        return employerData.companytypename ?? '';
      case 'companytype':
        return employerData.companytype ?? '';
      case 'companycategory':
        return employerData.companycategory ?? '';
      case 'categoryname':
        return employerData.categoryname ?? '';
      case 'naicscode':
        return employerData.naicscode ?? '';
      case 'eincode':
        return employerData.eincode ?? '';
      default:
        return '';
    }
  }

  ExpandableTableCell _buildHeaderCell(String content, {CellBuilder? builder}) {
    return builder != null
        ? ExpandableTableCell(
            builder: builder,
          )
        : ExpandableTableCell(
            child: DefaultCellCard(
              // color: AppColors.sidemenu,
              color: AppColors.secondary,
              child: Center(
                child: Text(
                  content.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      // color: Colors.blue,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
  }

  ExpandableTableCell _buildSubHeaderCell(String content,
      {CellBuilder? builder}) {
    return builder != null
        ? ExpandableTableCell(
            builder: builder,
          )
        : ExpandableTableCell(
            child: DefaultCellCard(
              color: AppColors.barBg,
              // color: const Color.fromARGB(255, 233, 236, 245),
              child: Center(
                child: Text(
                  content.toUpperCase(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 3, 149, 129),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
  }

  ExpandableTableCell _buildFirstRowCell(String imageUrl) {
    return ExpandableTableCell(builder: (context, details) {
      return DefaultCellCard(
        // color: const Color.fromARGB(255, 233, 236, 245),
        color: AppColors.barBg,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 24 * details.row!.address.length.toDouble(),
                child: details.row?.children != null &&
                        details.row?.visible == true
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 500),
                          turns:
                              details.row?.childrenExpanded == true ? 0.25 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : null,
              ),
              // (imageUrl == 'Account Data')
              //     ? const CircleAvatar(
              //         radius: 16,
              //         backgroundImage: NetworkImage(
              //             'https://via.placeholder.com/150'),
              //       )
              //     :
              Text(
                imageUrl,
                style: TextStyle(
                    color: imageUrl == 'Account Data'
                        ? Colors.blue
                        : imageUrl == 'Employer Data'
                            ? const Color.fromARGB(255, 3, 149, 129)
                            : const Color.fromARGB(255, 229, 168, 0),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<ExpandableTableRow> _generateAccountDataRow(
    List<String> accountDataHeaders,
    List<Account> data,
  ) {
    final List<String> employerDataHeaders = [
      'companydomain',
      'companyname',
      'companyaddress',
      'companyphoneno',
      'companytypename',
      // 'companytype',
      // 'companycategory',
      'categoryname',
      'naicscode',
      'eincode',
    ];

    return data
        .map((account) {
          final List<AccountData> accountDataList = account.accountdata;
          final List<Employer> employerDataList = account.employers;
          return accountDataList.map((accountData) {
            return ExpandableTableRow(
              firstCell: _buildFirstRowCell('Account Data'),
              children: _generateEmployerDataRow(
                  employerDataHeaders, employerDataList),
              cells: accountDataHeaders.map((header) {
                return ExpandableTableCell(
                  builder: (context, details) => DefaultCellCard(
                    child: Center(
                      child: Text(
                        _getValueForHeader(header, accountData),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList();
        })
        .expand((element) => element)
        .toList();
  }

  ExpandableTableRow _buildEmployerHeaderRow(List<String> employerDataHeaders) {
    return ExpandableTableRow(
      firstCell: _buildFirstRowCell(' '),
      cells: employerDataHeaders.map((header) {
        return _buildSubHeaderCell(header);
      }).toList(),
    );
  }

  List<ExpandableTableRow> _generateParnterDataRow(
      List<String> partnerDataHeaders, List<Partner> partners) {
    List<ExpandableTableRow> rows = [];
    // rows.add(_buildEmployerHeaderRow(partnerDataHeaders));
    rows.addAll(partners.map((partner) {
      return ExpandableTableRow(
        firstCell: _buildFirstRowCell('Partner Data'),
        cells: partnerDataHeaders.map((header) {
          return ExpandableTableCell(
            builder: (context, details) => DefaultCellCard(
              child: Center(
                child: Text(
                  _getValueForEmployerHeader(header, partner.partnerdata),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }).toList());
    return rows;
  }

  List<ExpandableTableRow> _generateEmployerDataRow(
      List<String> employerDataHeaders, List<dynamic> employerDataList) {
    List<ExpandableTableRow> rows = [];
    rows.add(_buildEmployerHeaderRow(employerDataHeaders));
    rows.addAll(employerDataList.map((employerData) {
      final List<Partner> partner = employerData.partners;
      List<String> partnerDataHeaders = [
        'companydomain',
        'companyname',
        'companyaddress',
        'companyphoneno',
        'companytypename',
        // 'companytype',
        // 'companycategory',
        'categoryname',
        'naicscode',
        'eincode',
      ];
      return ExpandableTableRow(
        firstCell: _buildFirstRowCell('Employer Data'),
        children: _generateParnterDataRow(partnerDataHeaders, partner),
        cells: employerDataHeaders.map((header) {
          return ExpandableTableCell(
            builder: (context, details) => DefaultCellCard(
              child: Center(
                child: Text(
                  _getValueForEmployerHeader(header, employerData),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }).toList());
    return rows;
  }

  Widget _buildExpandableTable(ReportProvider reportProvider) {
    controller.allRows.clear();
    controller.rows = _generateAccountDataRow(
        accountDataHeaders, reportProvider.filteredAccount);

    return ExpandableTable(
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    return Background(
      child: SizedBox(
        height: SizeConfig.screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: SizeConfig.screenWidth / 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                        ),
                        child: CustomSearch(
                          onChanged: (value) {
                            reportProvider.searchQuery = value;
                          },
                          hintText: 'Search by account name, work email ...',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: defaultPadding,
                      ),
                      child: TextButton.icon(
                        style: buttonStyleBlue,
                        onPressed: () => reportProvider.exportToExcel(context),
                        icon: Image.asset(
                          'assets/excel.png',
                          width: 24,
                          height: 24,
                        ),
                        label: const Text(
                          'Download',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                reportProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding,
                          horizontal: defaultPadding,
                        ),
                        child: SingleChildScrollView(
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Consumer<ReportProvider>(
                                    builder: (context, reportProvider, _) {
                                  return reportProvider
                                          .filteredAccount.isNotEmpty
                                      ? _buildExpandableTable(reportProvider)
                                      : const Center(
                                          child: Text(
                                            'No Data Available',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                }))),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultCellCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const DefaultCellCard({
    Key? key,
    this.color = Colors.white54,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.secondary),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: child,
    );
  }
}
