import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StaffScreenShimmer extends StatelessWidget {
  const StaffScreenShimmer({super.key, required this.isDark});
  final bool isDark;

  Widget shimmer(double h, double? w, [double p = 5]) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmer(30, 200),
          SizedBox(height: 20),
          for (var i = 0; i < 15; i++)
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      shimmer(30, 30),
                      SizedBox(width: 4),
                      shimmer(26, 120),
                      SizedBox(width: 4),
                      Spacer(),
                      shimmer(36, 36),
                      SizedBox(width: 4),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      shimmer(33, 120),
                      SizedBox(width: 5),
                      shimmer(33, 180),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
