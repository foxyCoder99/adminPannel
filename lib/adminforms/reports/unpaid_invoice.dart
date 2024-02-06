// unpaid_invoice.dart
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/unpaidinvoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final TextEditingController _searchController = TextEditingController();

class UnpaidInvoice extends StatelessWidget {
  const UnpaidInvoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unpaidInvoiceProvider = Provider.of<UnpaidInvoiceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unpaid Invoice Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(unpaidInvoiceProvider),
                const SizedBox(height: 16.0),
                Expanded(
                  child: _buildinvoiceDataTable(context, unpaidInvoiceProvider),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(UnpaidInvoiceProvider unpaidInvoiceProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: defaultPadding,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          unpaidInvoiceProvider.fetchUnpaidInvoiceList();
        },
        decoration: const InputDecoration(
          labelText: 'Search by ID, Account Code, etc.',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildinvoiceDataTable(
      BuildContext context, UnpaidInvoiceProvider unpaidInvoiceProvider) {
    final invoiceList = unpaidInvoiceProvider
        .getFilteredInvoiceList(unpaidInvoiceProvider.searchQuery);
    if (invoiceList.isEmpty) {
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
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Account Code')),
            DataColumn(label: Text('From Date')),
            DataColumn(label: Text('To Date')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Logged In User')),
          ],
          rows: invoiceList
              .map(
                (reports) => DataRow(
                  cells: [
                    DataCell(Text(reports.id)),
                    DataCell(Text(reports.accountcode)),
                    DataCell(Text(reports.fromdate)),
                    DataCell(Text(reports.todate)),
                    DataCell(Text(reports.status)),
                    DataCell(Text(reports.loggedinuser)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
