import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TopperListShimmer extends StatelessWidget {
  const TopperListShimmer({super.key, required this.isDark});
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
          shimmer(26, null),
          shimmer(26, null),
          shimmer(26, 200),
          SizedBox(height: 20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    shimmer(26, 120),
                    shimmer(26, 120),
                    shimmer(26, 120),
                  ],
                ),
                SizedBox(height: 10),
                for (var i = 0; i < 3; i++)
                  Column(
                    children: [
                      shimmer(30, null),
                      for (var j = 0; j < i + 1; j++) shimmer(40, null),
                      SizedBox(height: 15),
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
