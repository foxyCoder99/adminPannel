// paymentdetail_report.dart
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/paymentreport_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final TextEditingController _searchController = TextEditingController();

class PaymentReportDetails extends StatelessWidget {
  const PaymentReportDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentReportProvider = Provider.of<PaymentReportProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Report Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => paymentReportProvider.exportToExcel(context),
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
                _buildDateFilter(context, paymentReportProvider),
                const SizedBox(height: 16.0),
                _buildSearchBar(paymentReportProvider),
                const SizedBox(height: 16.0),
                if (paymentReportProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child:
                        _buildPaymentDataTable(context, paymentReportProvider),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(PaymentReportProvider paymentReportProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: defaultPadding,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          paymentReportProvider.searchQuery = value;
        },
        decoration: const InputDecoration(
          labelText: 'Search by invoice number, account name, etc.',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    PaymentReportProvider paymentReportProvider,
  ) {
    return Consumer<PaymentReportProvider>(
        builder: (context, paymentReportProvider, _) {
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
                  paymentReportProvider.updateDateRange(fromDate, toDate);
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
                      .format(paymentReportProvider.fromDate),
                  style: const TextStyle(color: Colors.black),
                ),
                const TextSpan(
                  text: ' To ',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: DateFormat('MM-dd-yyyy')
                      .format(paymentReportProvider.toDate),
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
      BuildContext context, PaymentReportProvider paymentReportProvider) {
    final paymentList = paymentReportProvider.filteredPayments;
    if (paymentList.isEmpty) {
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
            DataColumn(label: Text('Invoice Number')),
            DataColumn(label: Text('Subscription Name')),
            DataColumn(label: Text('Account Name')),
            DataColumn(label: Text('Email Id')),
            DataColumn(label: Text('Company Name')),
            DataColumn(label: Text('Paid Amount')),
            DataColumn(label: Text('Paid Date')),
          ],
          rows: paymentList
              .map(
                (reports) => DataRow(
                  cells: [
                    DataCell(Text(reports.invoicenumber)),
                    DataCell(Text(reports.subscriptionname)),
                    DataCell(Text(reports.accountname)),
                    DataCell(Text(reports.emailid)),
                    DataCell(Text(reports.companyname)),
                    DataCell(
                        Text('${reports.paidamount} ${reports.unitamount}')),
                    DataCell(Text(reports.paiddate)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
