import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/employerpartner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployerPartner extends StatelessWidget {
  const EmployerPartner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employerPartnerProvider =
        Provider.of<EmployerPartnerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Employer Partner Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => employerPartnerProvider.exportToExcel(context),
              icon: Image.asset(
                'assets/excel.png',
                width: 24,
                height: 24,
              ),
              label: const Text(
                'Download',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding,
                    horizontal: defaultPadding,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      employerPartnerProvider.searchQuery = value;
                    },
                    decoration: const InputDecoration(
                      labelText:
                          'Search by account name, role name, company type ',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                if (employerPartnerProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: _buildAccountDataTable(
                        context, employerPartnerProvider),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDataTable(
      BuildContext context, EmployerPartnerProvider employerPartnerProvider) {
    final accountList = employerPartnerProvider.filteredEmployerList;
    if (accountList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Account Name')),
            DataColumn(label: Text('Company Type')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Contact')),
          ],
          rows: accountList
              .map(
                (reports) => DataRow(
                  cells: [
                    DataCell(Text(reports.accountname)),
                    DataCell(Text(reports.companytype)),
                    DataCell(Text(reports.role)),
                    DataCell(Text(reports.contact)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
