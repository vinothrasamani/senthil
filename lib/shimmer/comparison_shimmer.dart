import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ComparisonShimmer extends StatelessWidget {
  const ComparisonShimmer({super.key, required this.isDark});
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmer(20, 160),
          SizedBox(height: 10),
          for (var i = 0; i < 4; i++) shimmer(50, null, 5),
          SizedBox(height: 10),
          shimmer(30, null),
          SizedBox(height: 50),
          shimmer(20, 120),
          SizedBox(height: 30),
          Column(
            children: [
              for (var i = 0; i < 4; i++) shimmer(15, null, 4),
            ],
          ),
        ],
      ),
    );
  }
}
