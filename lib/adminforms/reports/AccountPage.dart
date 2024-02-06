// AccountPage.dart
import 'package:advisorapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/providers/report_providers/account_provider.dart';

final TextEditingController _searchController = TextEditingController();

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Detail Report'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => accountProvider.exportToExcel(context),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateFilter(context, accountProvider),
                const SizedBox(height: 16.0),
                _buildSearchBar(accountProvider),
                const SizedBox(height: 16.0),
                if (accountProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: _buildPaymentDataTable(context, accountProvider),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AccountProvider accountProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: defaultPadding,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          accountProvider.searchQuery = value;
        },
        decoration: const InputDecoration(
          labelText: 'Search by account name, email, company name, etc.',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    AccountProvider accountProvider,
  ) {
    return Consumer<AccountProvider>(builder: (context, accountProvider, _) {
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
                  accountProvider.updateDateRange(fromDate, toDate);
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
                  text:
                      DateFormat('MM-dd-yyyy').format(accountProvider.fromDate),
                  style: const TextStyle(color: Colors.black),
                ),
                const TextSpan(
                  text: ' To ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat('MM-dd-yyyy').format(accountProvider.toDate),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPaymentDataTable(
      BuildContext context, AccountProvider accountProvider) {
    final accountList = accountProvider.filteredAccounts;
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
            DataColumn(label: Text('Account Type')),
            DataColumn(label: Text('Category Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('NAICS')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Company Name')),
            DataColumn(label: Text('Company Type')),
            DataColumn(label: Text('Joined Date')),
          ],
          rows: accountList
              .map(
                (reports) => DataRow(
                  cells: [
                    DataCell(Text(reports.accountName)),
                    DataCell(Text(reports.accountType)),
                    DataCell(Text(reports.categoryName)),
                    DataCell(Text(reports.email)),
                    DataCell(Text(reports.naicsCode)),
                    DataCell(Text(reports.phoneNumber)),
                    DataCell(Text(reports.companyName)),
                    DataCell(Text(reports.companyType)),
                    DataCell(Text(reports.joinedDate)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
