import 'package:e_commerce_app/themes/custom_color.dart';
import 'package:flutter/material.dart';

class DetailRatingReview extends StatelessWidget {
  final double rating;
  final int totalReview;
  final Function() onTapSeeAll;
  const DetailRatingReview(
      {Key? key,
      required this.rating,
      required this.totalReview,
      required this.onTapSeeAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              size: 24,
              color: CustomColor.warning,
            ),
            const SizedBox(width: 8),
            Text(
              '$rating ($totalReview Yorum)',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            onTapSeeAll();
          },
          child: Text(
            'Yorumları Görüntüle',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
