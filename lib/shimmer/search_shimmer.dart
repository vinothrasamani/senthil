import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key, required this.isDark});
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
          shimmer(50, null),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    shimmer(25, 120),
                    Spacer(),
                    shimmer(25, 25),
                  ],
                ),
                SizedBox(height: 5),
                for (var i = 0; i < 4; i++) shimmer(50, null, 5),
              ],
            ),
          ),
          SizedBox(height: 15),
          shimmer(25, 220),
          SizedBox(
            height: 300,
            child: Center(
              child: shimmer(20, 200),
            ),
          ),
        ],
      ),
    );
  }
}
