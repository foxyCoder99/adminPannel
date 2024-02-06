// account_invitation.dart
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/accountinvitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountInvitation extends StatelessWidget {
  const AccountInvitation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountInvitationProvider =
        Provider.of<AccountInvitationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Invitation Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => accountInvitationProvider.exportToExcel(context),
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
                _buildDateFilter(context, accountInvitationProvider),
                _buildSearchBar(context, accountInvitationProvider),
                if (accountInvitationProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: _buildAccountDataTable(
                        context, accountInvitationProvider),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    AccountInvitationProvider accountInvitationProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          accountInvitationProvider.setSearchTerm(value);
        },
        decoration: InputDecoration(
          hintText: 'Search by account name or email',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    AccountInvitationProvider accountInvitationProvider,
  ) {
    return Consumer<AccountInvitationProvider>(
        builder: (context, accountInvitationProvider, _) {
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
                final DateTime? toDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: fromDate,
                  lastDate: DateTime.now(),
                );
                if (toDate != null) {
                  accountInvitationProvider.updateDateRange(fromDate, toDate);
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
                      .format(accountInvitationProvider.fromDate),
                  style: const TextStyle(color: Colors.black),
                ),
                const TextSpan(
                  text: ' To ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat('MM-dd-yyyy')
                      .format(accountInvitationProvider.toDate),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAccountDataTable(BuildContext context,
      AccountInvitationProvider accountInvitationProvider) {
    final accountList = accountInvitationProvider.filteredAccountList;

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
            DataColumn(label: Text('Company Name')),
            DataColumn(label: Text('NAICS')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Company Type')),
            DataColumn(label: Text('Invitation Status')),
            DataColumn(label: Text('Joined Date')),
          ],
          rows: accountList
              .map(
                (report) => DataRow(
                  cells: [
                    DataCell(Text(report.accountname)),
                    DataCell(Text(report.accounttype)),
                    DataCell(Text(report.categoryname)),
                    DataCell(Text(report.email)),
                    DataCell(Text(report.companyname)),
                    DataCell(Text(report.naicscode)),
                    DataCell(Text(report.phonenumber)),
                    DataCell(Text(report.companytype)),
                    DataCell(Text(report.invitationstatus)),
                    DataCell(Text(report.joineddate)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
