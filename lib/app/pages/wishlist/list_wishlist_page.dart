import 'package:e_commerce_app/app/pages/wishlist/widgets/wishlist_container.dart';
import 'package:e_commerce_app/app/providers/wishlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/order_by_value.dart';
import '../../widgets/app_bar_search.dart';
import '../../widgets/count_and_option.dart';
import '../../widgets/sort_filter_chip.dart';

class ListWishlistPage extends StatefulWidget {
  const ListWishlistPage({Key? key}) : super(key: key);

  @override
  State<ListWishlistPage> createState() => _ListWishlistPageState();
}

class _ListWishlistPageState extends State<ListWishlistPage> {
  String accountId = FirebaseAuth.instance.currentUser!.uid;

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
          context.read<WishlistProvider>().loadWishlist(
                accountId: accountId,
                search: _txtSearch.text,
                orderByEnum: orderByEnum,
              );
        },
        controller: _txtSearch,
        hintText: 'İstek Listesinde Ara',
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, value, child) {
          if (value.isLoadData) {
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
                  count: value.listWishlist.length,
                  itemName: 'İstek Listesi',
                  isSort: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SortFilterChip(
                              dataEnum: OrderByEnum.values.take(4).toList(),
                              onSelected: (value) {
                                setState(() {
                                  orderByEnum = value;
                                  orderByValue = getEnumValue(value);
                                  context.read<WishlistProvider>().loadWishlist(
                                        accountId: accountId,
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
                if (value.listWishlist.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'İstek Listesi boş, burada istek listesi gösterilecek',
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (value.listWishlist.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('İstek Listesi bulunamadı'),
                  ),
                if (value.listWishlist.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<WishlistProvider>().loadWishlist(
                              accountId: accountId,
                              search: _txtSearch.text,
                              orderByEnum: orderByEnum,
                            );
                      },
                      child: ListView.builder(
                        itemCount: value.listWishlist.length,
                        itemBuilder: (_, index) {
                          final item = value.listWishlist[index];

                          return WishlistContainer(
                            wishlist: item,
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
