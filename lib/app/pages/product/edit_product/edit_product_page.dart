import 'dart:io';

import 'package:e_commerce_app/app/constants/validation_type.dart';
import 'package:e_commerce_app/app/providers/product_provider.dart';
import 'package:e_commerce_app/app/widgets/error_banner.dart';
import 'package:e_commerce_app/app/widgets/pick_image_source.dart';
import 'package:e_commerce_app/core/domain/entities/product/product.dart';
import 'package:e_commerce_app/utils/compress_image.dart';
import 'package:e_commerce_app/utils/numeric_text_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'widgets/image_product_preview.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late Product dataProduct;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _txtProductName = TextEditingController();
  final TextEditingController _txtPrice = TextEditingController();
  final TextEditingController _txtDescription = TextEditingController();
  final TextEditingController _txtStock = TextEditingController();

  final FocusNode _fnProductName = FocusNode();
  final FocusNode _fnPrice = FocusNode();
  final FocusNode _fnDescription = FocusNode();
  final FocusNode _fnStock = FocusNode();

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _productImages = [];

  ValidationType validation = ValidationType.instance;

  @override
  void initState() {
    Future.microtask(() {
      setState(() {
        dataProduct = ModalRoute.of(context)!.settings.arguments as Product;

        _txtProductName.text = dataProduct.productName;
        _txtPrice.text = '${dataProduct.productPrice}';
        _txtDescription.text = dataProduct.productDescription;
        _txtStock.text = NumberFormat('#,###').format(dataProduct.stock);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _txtProductName.dispose();
    _txtPrice.dispose();
    _txtDescription.dispose();
    _txtStock.dispose();

    _fnProductName.dispose();
    _fnPrice.dispose();
    _fnDescription.dispose();
    _fnStock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünü Düzenle'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _txtProductName,
                      focusNode: _fnProductName,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.name,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnPrice),
                      decoration: const InputDecoration(
                        hintText: 'Ürün adını giriniz',
                        labelText: 'Ürün adı',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _txtPrice,
                      focusNode: _fnPrice,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnDescription),
                      decoration: const InputDecoration(
                        hintText: 'Ürün fiyatını giriniz',
                        labelText: 'Ürün fiyatı',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _txtDescription,
                      focusNode: _fnDescription,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_fnStock),
                      decoration: const InputDecoration(
                        hintText: 'Ürün açıklamasını giriniz',
                        labelText: 'Açıklama',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _txtStock,
                      focusNode: _fnStock,
                      validator: validation.emptyValidation,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumericTextFormatter(),
                      ],
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Stok Miktarını giriniz',
                        labelText: 'Stok',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ürün Fotoğrafı'),
                        TextButton(
                          onPressed: () async {
                            int countImage = dataProduct.productImage.length;
                            countImage += _productImages.length;
                            if (_productImages.isNotEmpty && countImage >= 5)
                              return;

                            ImageSource? pickImageSource = await showDialog(
                              context: context,
                              builder: (context) {
                                return const PickImageSource();
                              },
                            );

                            if (pickImageSource != null) {
                              XFile? image = await _picker.pickImage(
                                  source: pickImageSource);
                              if (image != null) {
                                setState(() {
                                  _productImages.add(image);
                                });
                              }
                            }
                          },
                          child: const Text('Fotoğraf Ekle'),
                        ),
                      ],
                    ),
                    _productImages.isEmpty && (dataProduct.productImage.isEmpty)
                        ? Text(
                            'En Fazla 5 Fotoğraf',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : Wrap(
                            children: [
                              ...dataProduct.productImage.map(
                                (e) => ImageProductPreview(
                                  image: Image.network(
                                    e,
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64,
                                    loadingBuilder:
                                        (_, child, loadingProgress) {
                                      if (loadingProgress == null) return child;

                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      dataProduct.productImage.remove(e);
                                    });
                                  },
                                ),
                              ),
                              ..._productImages.map((e) {
                                return ImageProductPreview(
                                  image: Image.file(
                                    File(e.path),
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _productImages.remove(e);
                                    });
                                  },
                                );
                              })
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Consumer<ProductProvider>(
              builder: (context, value, child) {
                if (value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  child: const Text('Ürünü Düzenle'),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (_productImages.isEmpty &&
                        (dataProduct.productImage.length +
                                _productImages.length) ==
                            0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'En az 1 en fazla 5 fotoğraf yükleyebilirsiniz.'),
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate() && !value.isLoading) {
                      try {
                        value.setLoading = true;

                        ScaffoldMessenger.of(context)
                            .removeCurrentMaterialBanner();

                        List<String> productImage = [];

                        productImage.addAll(dataProduct.productImage);

                        for (var element in _productImages) {
                          Uint8List image = await element.readAsBytes();

                          image = await CompressImage.startCompress(image);

                          Reference ref = FirebaseStorage.instance
                              .ref()
                              .child('Ürünler/${element.name}');

                          final dataImage = await ref.putData(image);

                          String imageUrl =
                              await dataImage.ref.getDownloadURL();
                          productImage.add(imageUrl);
                        }

                        Product data = Product(
                          productId: dataProduct.productId,
                          productName: _txtProductName.text,
                          productPrice:
                              NumberFormat().parse(_txtPrice.text).toDouble(),
                          productDescription: _txtDescription.text,
                          productImage: productImage,
                          totalReviews: dataProduct.totalReviews,
                          rating: dataProduct.rating,
                          isDeleted: false,
                          stock: int.parse(_txtStock.text),
                          createdAt: dataProduct.createdAt,
                          updatedAt: DateTime.now(),
                        );

                        await value.update(data: data).whenComplete(() {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ürün başarıyla düzenlendi'),
                            ),
                          );
                          value.loadDetailProduct(productId: data.productId);
                          value.loadListProduct();
                        });
                      } catch (e) {
                        value.setLoading = false;
                        ScaffoldMessenger.of(context)
                            .removeCurrentMaterialBanner();
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          errorBanner(context: context, msg: e.toString()),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
