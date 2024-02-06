// account_employer.dart
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/accountemployer_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final TextEditingController _searchController = TextEditingController();

class AccountEmployer extends StatelessWidget {
  const AccountEmployer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountEmployerProvider =
        Provider.of<AccountEmployerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Employer Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => accountEmployerProvider.exportToExcel(context),
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
                _buildDateFilter(context, accountEmployerProvider),
                const SizedBox(height: 16.0),
                _buildSearchBar(accountEmployerProvider),
                const SizedBox(height: 16.0),
                Consumer<AccountEmployerProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Expanded(
                        child: _buildAccountDataTable(
                            context, accountEmployerProvider),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AccountEmployerProvider accountEmployerProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: defaultPadding,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          accountEmployerProvider.searchQuery = value;
        },
        decoration: const InputDecoration(
          labelText: 'Search by account name, employer name, etc.',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    AccountEmployerProvider accountEmployerProvider,
  ) {
    return Consumer<AccountEmployerProvider>(
        builder: (context, accountEmployerProvider, _) {
      return Row(
        children: [
          ElevatedButton(
            style: buttonStyleGrey,
            onPressed: () async {
              final DateTime? fromDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
              );
              if (fromDate != null) {
                // ignore: use_build_context_synchronously
                final DateTime? toDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: fromDate,
                  lastDate: DateTime.now(),
                );
                if (toDate != null) {
                  accountEmployerProvider.updateDateRange(fromDate, toDate);
                }
              }
            },
            child: const Text(
              'Select Date Range',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                const TextSpan(
                  text: 'From ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat('MM-dd-yyyy')
                      .format(accountEmployerProvider.fromDate),
                  style: const TextStyle(color: Colors.black),
                ),
                const TextSpan(
                  text: ' To ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat('MM-dd-yyyy')
                      .format(accountEmployerProvider.toDate),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAccountDataTable(
      BuildContext context, AccountEmployerProvider accountEmployerProvider) {
    final accountList = accountEmployerProvider.accountList;

    if (accountList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Apply search filter
    final filteredList = accountList.where((account) {
      final lowerCaseQuery = accountEmployerProvider.searchQuery.toLowerCase();
      return account.accountname.toLowerCase().contains(lowerCaseQuery) ||
          account.employername.toLowerCase().contains(lowerCaseQuery) ||
          account.companytype.toLowerCase().contains(lowerCaseQuery) ||
          account.planeffectivedate.toLowerCase().contains(lowerCaseQuery) ||
          // account.contractsignatoryemail.toLowerCase().contains(lowerCaseQuery) ||
          account.createddate.toLowerCase().contains(lowerCaseQuery);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Account Name')),
            DataColumn(label: Text('Employer Name')),
            DataColumn(label: Text('Company Type')),
            DataColumn(label: Text('Plan Effective Date')),
            // DataColumn(label: Text('Contract Signatory Email')),
            DataColumn(label: Text('Created Date')),
          ],
          rows: filteredList
              .map(
                (reports) => DataRow(
                  cells: [
                    DataCell(Text(reports.accountname)),
                    DataCell(Text(reports.employername)),
                    DataCell(Text(reports.companytype)),
                    DataCell(Text(reports.planeffectivedate)),
                    // DataCell(Text(reports.contractsignatoryemail)),
                    DataCell(Text(reports.createddate)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
