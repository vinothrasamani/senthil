import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedbackSettingsShimmer extends StatelessWidget {
  const FeedbackSettingsShimmer({super.key, required this.isDark});
  final bool isDark;

  Widget shimmer(double h, double? w, [double p = 0]) {
    return Container(
      width: w ?? double.infinity,
      height: h,
      margin: EdgeInsets.symmetric(vertical: p),
      color: isDark ? Colors.grey[800] : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[isDark ? 800 : 300]!,
      highlightColor: Colors.grey[isDark ? 700 : 100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < 8; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmer(20, 180, 5),
                  shimmer(20, null, 5),
                  SizedBox(height: 10),
                  if (i == 3)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var j = 0; j < 3; j++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              shimmer(25, 180, 3),
                              SizedBox(width: 5),
                              shimmer(35, j == 0 ? 100 : 50, 3),
                            ],
                          ),
                        SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
