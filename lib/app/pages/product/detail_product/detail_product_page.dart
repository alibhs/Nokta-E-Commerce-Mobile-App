import 'package:e_commerce_app/app/pages/product/detail_product/widgets/detail_action_button.dart';
import 'package:e_commerce_app/app/pages/product/detail_product/widgets/detail_product_image_card.dart';
import 'package:e_commerce_app/app/pages/product/detail_product/widgets/detail_rating_review.dart';
import 'package:e_commerce_app/app/pages/product/detail_product/widgets/detail_text_space_between..dart';
import 'package:e_commerce_app/app/pages/product/detail_product/widgets/user_action_button.dart';
import 'package:e_commerce_app/app/providers/product_provider.dart';
import 'package:e_commerce_app/app/providers/wishlist_provider.dart';
import 'package:e_commerce_app/app/widgets/cart/cart_badge.dart';
import 'package:e_commerce_app/app/widgets/product_review_card.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:e_commerce_app/core/domain/entities/cart/cart.dart';
import 'package:e_commerce_app/core/domain/entities/wishlist/wishlist.dart';
import 'package:e_commerce_app/routes.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart_provider.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({Key? key}) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final FlavorConfig _flavorConfig = FlavorConfig.instance;

  String accountId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    Future.microtask(() {
      String productId = ModalRoute.of(context)!.settings.arguments as String;

      context.read<ProductProvider>().loadDetailProduct(productId: productId);
      var wishlistProvider = context.read<WishlistProvider>();
      if (wishlistProvider.listWishlist.isEmpty) {
        wishlistProvider.loadWishlist(accountId: accountId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        actions: _flavorConfig.flavor == Flavor.user
            ? [
                const CartBadge(),
                const SizedBox(width: 32),
              ]
            : null,
      ),
      body: Consumer2<ProductProvider, WishlistProvider>(
        builder: (context, value, value2, child) {
          if (value.isLoading ||
              value.detailProduct == null ||
              value2.isLoadData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...value.detailProduct!.productImage.map((imgUrl) {
                              int index = value.detailProduct!.productImage
                                  .indexOf(imgUrl);
                              return DetailProductImageCard(
                                  imgUrl: imgUrl, index: index);
                            })
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      DetailTextSpaceBetween(
                        leftText: value.detailProduct!.productName,
                        rightText: NumberFormat.compactCurrency(
                                locale: 'tr_TR', symbol: '\₺')
                            .format(value.detailProduct!.productPrice),
                      ),
                      const SizedBox(height: 12),
                      DetailTextSpaceBetween(
                        leftText: 'Kalan Stok',
                        rightText: value.detailProduct!.stock.toNumericFormat(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Açıklama',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        value.detailProduct!.productDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      DetailRatingReview(
                        rating: value.detailProduct!.rating,
                        totalReview: value.detailProduct!.totalReviews,
                        onTapSeeAll: () {
                          NavigateRoute.toProductReview(
                              context: context,
                              productReview: value.listProductReview);
                        },
                      ),
                      const SizedBox(height: 12),
                      if (value.listProductReview.isEmpty)
                        Center(
                          child: Text(
                            "Bu ürün için henüz yorum yapılmamış",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (value.listProductReview.isNotEmpty)
                        Column(
                          children: [
                            ...value.listProductReview.map((item) {
                              return ProductReviewCard(item: item);
                            })
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              _flavorConfig.flavor == Flavor.user
                  ? Consumer2<CartProvider, WishlistProvider>(
                      builder:
                          (context, cartProvider, wishlistProvider, child) {
                        if (cartProvider.isLoading ||
                            wishlistProvider.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        bool isWishlisted = wishlistProvider.listWishlist.any(
                            (element) =>
                                element.productId ==
                                value.detailProduct!.productId);

                        return UserActionButton(
                          isWishlisted: isWishlisted,
                          onTapFavorite: () async {
                            if (isWishlisted) {
                              String wishlistId = wishlistProvider.listWishlist
                                  .where((element) =>
                                      element.productId ==
                                      value.detailProduct!.productId)
                                  .first
                                  .wishlistId;
                              await wishlistProvider.delete(
                                  accountId: accountId, wishlistId: wishlistId);
                              return;
                            }

                            var data = Wishlist(
                              wishlistId: ''.generateUID(),
                              productId: value.detailProduct!.productId,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );

                            await wishlistProvider.add(
                                accountId: accountId, data: data);
                          },
                          onTapAddToCart: value.detailProduct!.stock == 0
                              ? null
                              : () async {
                                  String accountId =
                                      FirebaseAuth.instance.currentUser!.uid;

                                  if (cartProvider.countCart != 0) {
                                    for (var element in cartProvider.listCart) {
                                      if (element.productId ==
                                          value.detailProduct!.productId) {
                                        Cart data = element;
                                        data.quantity += 1;
                                        data.total =
                                            data.product!.productPrice *
                                                data.quantity;
                                        await cartProvider.updateCart(
                                            data: data);
                                        return;
                                      }
                                    }
                                  }

                                  Cart data = Cart(
                                    cartId: ''.generateUID(),
                                    product: value.detailProduct,
                                    productId: value.detailProduct!.productId,
                                    quantity: 1,
                                    total: value.detailProduct!.productPrice,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  );
                                  await cartProvider.addCart(
                                      accountId: accountId, data: data);
                                },
                        );
                      },
                    )
                  : DetailActionButton(
                      onTapDeleteProduct: () async {
                        var response = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Ürünü Sil?'),
                              content: const Text(
                                  'Bu ürün kalıcı olarak silinecektir'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Vazgeç'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Onayla'),
                                ),
                              ],
                            );
                          },
                        );

                        if (response != null) {
                          await value
                              .delete(productId: value.detailProduct!.productId)
                              .whenComplete(() {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ürün Başarıyla Silindi'),
                              ),
                            );
                            value.loadListProduct();
                          });
                        }
                      },
                      onTapEditProduct: () {
                        NavigateRoute.toEditProduct(
                            context: context, product: value.detailProduct!);
                      },
                    ),
            ],
          );
        },
      ),
    );
  }
}
