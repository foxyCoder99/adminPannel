import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/account_actionitem_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final TextEditingController _searchController = TextEditingController();

class AccountActionItem extends StatelessWidget {
  const AccountActionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountActionItemProvider =
        Provider.of<AccountActionItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Wise Action Items'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => accountActionItemProvider.exportToExcel(context),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateFilter(
                    context, accountActionItemProvider, _searchController),
                const SizedBox(height: 16.0),
                _buildSearchBar(accountActionItemProvider),
                const SizedBox(height: 16.0),
                Consumer<AccountActionItemProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Expanded(
                        child: _buildAccountDataTable(
                            context, accountActionItemProvider),
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

  Widget _buildSearchBar(AccountActionItemProvider accountActionItemProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: defaultPadding,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          accountActionItemProvider.searchQuery = value;
        },
        decoration: const InputDecoration(
          labelText: 'Search by account name, item name, etc.',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    AccountActionItemProvider accountActionItemProvider,
    TextEditingController searchController,
  ) {
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
                accountActionItemProvider.updateDateRange(fromDate, toDate);
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
        _buildDateRangeText(context, accountActionItemProvider),
      ],
    );
  }

  Widget _buildDateRangeText(
      BuildContext context, AccountActionItemProvider provider) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          const TextSpan(
            text: 'From ',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: DateFormat('MM-dd-yyyy').format(provider.fromDate),
            style: const TextStyle(color: Colors.black),
          ),
          const TextSpan(
            text: ' To ',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: DateFormat('MM-dd-yyyy').format(provider.toDate),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDataTable(BuildContext context,
      AccountActionItemProvider accountActionItemProvider) {
    final accountList = accountActionItemProvider.accountList;

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
      final lowerCaseQuery =
          accountActionItemProvider.searchQuery.toLowerCase();
      return account.accountname.toLowerCase().contains(lowerCaseQuery) ||
          account.itemName.toLowerCase().contains(lowerCaseQuery) ||
          account.launch.toLowerCase().contains(lowerCaseQuery) ||
          account.renewal.toLowerCase().contains(lowerCaseQuery) ||
          account.private.toLowerCase().contains(lowerCaseQuery) ||
          account.itemStatus.toLowerCase().contains(lowerCaseQuery) ||
          account.documentName.toLowerCase().contains(lowerCaseQuery) ||
          account.documentView.toLowerCase().contains(lowerCaseQuery);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Account Name')),
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Launch')),
            DataColumn(label: Text('Renewal')),
            DataColumn(label: Text('Private')),
            DataColumn(label: Text('Item Status')),
            DataColumn(label: Text('Document Name')),
            DataColumn(label: Text('Document View')),
          ],
          rows: filteredList
              .map(
                (report) => DataRow(
                  cells: [
                    DataCell(Text(report.accountname)),
                    DataCell(Text(report.itemName)),
                    DataCell(CustomCheckBox(value: report.launch)),
                    DataCell(CustomCheckBox(value: report.renewal)),
                    DataCell(CustomCheckBox(value: report.private)),
                    DataCell(Text(report.itemStatus)),
                    DataCell(Text(report.documentName)),
                    DataCell(
                      ElevatedButton(
                        style: buttonStyleInvite,
                        onPressed: () {
                          launchUrl(Uri.parse(report.documentView));
                        },
                        child: const Text('View',
                            style: TextStyle(color: Colors.white)),
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

// Custom CheckBox widget
class CustomCheckBox extends StatelessWidget {
  final String value;
  const CustomCheckBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return value == 'Y'
        ? const Icon(Icons.check, color: Colors.green)
        : const Icon(Icons.close, color: Colors.red);
  }
}
