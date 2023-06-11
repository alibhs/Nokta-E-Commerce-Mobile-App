import 'package:e_commerce_app/app/pages/customer/widgets/customer_container.dart';
import 'package:e_commerce_app/app/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/order_by_value.dart';
import '../../widgets/app_bar_search.dart';
import '../../widgets/count_and_option.dart';
import '../../widgets/sort_filter_chip.dart';

class ListCustomerPage extends StatefulWidget {
  const ListCustomerPage({Key? key}) : super(key: key);

  @override
  State<ListCustomerPage> createState() => _ListCustomerPageState();
}

class _ListCustomerPageState extends State<ListCustomerPage> {
  final TextEditingController _txtSearch = TextEditingController();

  OrderByEnum orderByEnum = OrderByEnum.newest;
  OrderByValue orderByValue = getEnumValue(OrderByEnum.newest);

  String search = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearch(
        onChanged: (value) {
          context.read<AccountProvider>().getListAccount(
                search: _txtSearch.text,
                orderByEnum: orderByEnum,
              );
        },
        controller: _txtSearch,
        hintText: 'Müşteri Ara',
      ),
      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          if (value.isLoadListAccount) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              children: [
                CountAndOption(
                  count: value.listAccount.length,
                  itemName: 'Müşteri',
                  isSort: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SortFilterChip(
                              dataEnum: OrderByEnum.values.take(2).toList(),
                              onSelected: (value) {
                                setState(() {
                                  orderByEnum = value;
                                  orderByValue = getEnumValue(value);
                                  context
                                      .read<AccountProvider>()
                                      .getListAccount(
                                        search: _txtSearch.text,
                                        orderByEnum: value,
                                      );
                                });
                              },
                              selectedEnum: orderByEnum,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (value.listAccount.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Müşteri boş,\nmüşteri burada gösterilecek',
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (value.listAccount.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('Müşteri bulunamadı'),
                  ),
                if (value.listAccount.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<AccountProvider>().getListAccount(
                              search: _txtSearch.text,
                              orderByEnum: orderByEnum,
                            );
                      },
                      child: ListView.builder(
                        itemCount: value.listAccount.length,
                        itemBuilder: (_, index) {
                          final customer = value.listAccount[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CustomerContainer(customer: customer),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
