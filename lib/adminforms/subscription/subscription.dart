import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_text_decoration.dart';
import 'package:advisorapp/providers/subscription_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionFormPage extends StatelessWidget {
  const SubscriptionFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    if (subscriptionProvider.selectedType.isEmpty &&
        subscriptionProvider.types.isNotEmpty) {
      subscriptionProvider.setSelectedType(subscriptionProvider.types.first);
    }

    if (subscriptionProvider.selectedPriceunit.isEmpty &&
        subscriptionProvider.priceunits.isNotEmpty) {
      subscriptionProvider
          .setSelectedPriceunit(subscriptionProvider.priceunits.first);
    }

    if (subscriptionProvider.selectedDisplayPeriodUnit.isEmpty &&
        subscriptionProvider.displayPeriodunits.isNotEmpty) {
      subscriptionProvider
          .setSelectedPeriodunit(subscriptionProvider.displayPeriodunits.first);
    }
    double defaultwidth = SizeConfig.screenWidth;
    return Background(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.screenHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        subscriptionProvider.showForm();
                        subscriptionProvider.resetForm();
                      },
                      child: const Text(
                        '+ Add a new subscription',
                        style: appstyle,
                      )),
                  /* ElevatedButton(
                    style: buttonStyleGrey,
                    onPressed: () {
                      subscriptionProvider.showForm();
                      subscriptionProvider.resetForm();
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '+ add a new subscription',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ), */
                  const SizedBox(height: 16.0),
                  if (subscriptionProvider.isFormVisible)
                    _buildSubscriptionForm(context, subscriptionProvider),
                  SizedBox(
                    width: defaultwidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          subscriptionProvider.searchQuery = value;
                        },
                        decoration: const InputDecoration(
                          labelText:
                              'Search by subscription type, subscription name ...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (subscriptionProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildSubscriptionList(context, subscriptionProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionForm(
      BuildContext context, SubscriptionProvider subscriptionProvider) {
    double defaultwidth = SizeConfig.screenWidth;
    return SizedBox(
      width: defaultwidth / 3,
      child: Form(
        key: subscriptionProvider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: DropdownButtonFormField(
                value: subscriptionProvider.selectedType,
                items: subscriptionProvider.types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  subscriptionProvider.setSelectedType(value ?? '');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select subscription type';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Subscription Type',
                  const Icon(
                    Icons.type_specimen,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: TextFormField(
                controller: subscriptionProvider.subscriptionnameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter Subscription Name';
                  }
                  return null;
                },
                decoration: CustomTextDecoration.textDecoration(
                  'Subscription Name',
                  const Icon(
                    Icons.subscriptions,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: subscriptionProvider.selectedPriceunit,
                      items: subscriptionProvider.priceunits.map((priceunit) {
                        return DropdownMenuItem(
                          value: priceunit,
                          child: Text(priceunit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        subscriptionProvider.setSelectedPriceunit(value ?? '');
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select price unit';
                        }
                        return null;
                      },
                      decoration: CustomTextDecoration.textDecoration(
                        'Price Unit',
                        const Icon(
                          Icons.price_change_sharp,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: subscriptionProvider.priceController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter Price';
                        }
                        return null;
                      },
                      decoration: CustomTextDecoration.textDecoration(
                        'Price',
                        const Icon(
                          Icons.price_change,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: subscriptionProvider.selectedDisplayPeriodUnit,
                      items: subscriptionProvider.displayPeriodunits
                          .map((periodunit) {
                        return DropdownMenuItem(
                          value: periodunit,
                          child: Text(periodunit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        subscriptionProvider
                            .setSelectedDisplayPeriodUnit(value ?? '');
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select period unit';
                        }
                        return null;
                      },
                      decoration: CustomTextDecoration.textDecoration(
                        'Period Unit',
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: subscriptionProvider.periodController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter Period';
                        }
                        return null;
                      },
                      decoration: CustomTextDecoration.textDecoration(
                        'Period',
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
              width: 250,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: buttonStyleGreen,
                  onPressed: () {
                    subscriptionProvider.formKey.currentState?.validate();
                    if (subscriptionProvider.validateSubscriptionForm()) {
                      subscriptionProvider.saveSubscription(context);
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: buttonStyleBlue,
                  onPressed: () {
                    subscriptionProvider.cancelSubscriptionForm(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionList(
      BuildContext context, SubscriptionProvider subscriptionProvider) {
    double defaultwidth = SizeConfig.screenWidth;

    final subscriptionList = subscriptionProvider.filteredSubscriptionList;
    if (subscriptionList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: defaultwidth / 1.8,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Subscription Type')),
              DataColumn(label: Text('Subscription Name')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Period')),
              DataColumn(label: Text('Actions')),
            ],
            rows: subscriptionList
                .map(
                  (subscription) => DataRow(
                    cells: [
                      DataCell(Text(subscription.type)),
                      DataCell(Text(subscription.subscriptionname)),
                      DataCell(Text(
                          '${subscription.price.toString()} ${subscription.priceunit}')),
                      DataCell(Text(
                          '${subscription.period} ${(subscription.periodunit == 'MM' ? 'Monthly' : subscription.periodunit == 'YY' ? 'Yearly' : 'Days')}')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                subscriptionProvider.editSubscription(
                                    context, subscription);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                          "Are you sure you want to delete this user?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            subscriptionProvider
                                                .deleteAdvisorAdminSubscription(
                                                    subscription
                                                        .subscriptioncode);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
