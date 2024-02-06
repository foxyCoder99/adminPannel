import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/providers/report_providers/empaction_provider.dart';
import 'package:excel/excel.dart';

class EmpActionPage extends StatelessWidget {
  const EmpActionPage({Key? key}) : super(key: key);

  Future<void> exportToExcel(BuildContext context) async {
    final provider = Provider.of<EmpActionProvider>(context, listen: false);

    try {
      // Create an Excel document
      var excel = Excel.createExcel();
      var sheet = excel['Employerwise Action Item'];
      // Add header row
      sheet.appendRow([
        const TextCellValue('Account Name'),
        const TextCellValue('Company Type'),
        const TextCellValue('Role'),
        const TextCellValue('Contact'),
      ]);

      // Add data rows
      for (var account in provider.filteredAccounts) {
        sheet.appendRow([
          TextCellValue(account.accountName),
          TextCellValue(account.companyType),
          TextCellValue(account.role),
          TextCellValue(account.contact),
        ]);
      }
      // Save the Excel file
      var filePath = 'empaction_data.xlsx'; // Adjust file path as needed
      excel.save(fileName: filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Excel file saved at: $filePath'),
        ),
      );
    } catch (e) {
      print('Error exporting to Excel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmpActionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employerwise Action Item'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton.icon(
              style: buttonStyleBlue,
              onPressed: () => exportToExcel(context),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: defaultPadding,
              horizontal: defaultPadding,
            ),
            child: TextField(
              onChanged: (value) {
                provider.searchQuery = value;
              },
              decoration: const InputDecoration(
                labelText: 'Search by account name, role name ',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildAccountDataTable(context, provider),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildAccountDataTable(
      BuildContext context, EmpActionProvider provider) {
    final accountList = provider.filteredAccounts;
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
                (account) => DataRow(
                  cells: [
                    DataCell(Text(account.accountName)),
                    DataCell(Text(account.companyType)),
                    DataCell(Text(account.role)),
                    DataCell(Text(account.contact)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
