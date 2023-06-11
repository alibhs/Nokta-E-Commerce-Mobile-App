import 'package:flutter/material.dart';

import 'detail_product_image.dart';

class DetailProductImageCard extends StatelessWidget {
  final String imgUrl;
  final int index;
  const DetailProductImageCard({Key? key, required this.imgUrl, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.36,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailProductImage(
                  imgUrl: imgUrl,
                  index: index,
                ),
              ),
            );
          },
          child: Hero(
            tag: 'detail_image' '$index',
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
      ),
    );
  }
}
