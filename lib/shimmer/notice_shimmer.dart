import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NoticeShimmer extends StatelessWidget {
  const NoticeShimmer({super.key, required this.isDark});
  final bool isDark;

  Widget shimmer(double h, double? w, [double p = 5]) {
    return Container(
      width: w ?? double.infinity,
      height: h,
      margin: EdgeInsets.all(p),
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
          shimmer(35, 150),
          SizedBox(height: 10),
          for (var i = 0; i < 3; i++)
            Row(
              children: [shimmer(30, 200, 5), Spacer(), shimmer(35, 50, 5)],
            ),
          SizedBox(height: 10),
          shimmer(35, 150),
          for (var j = 0; j < 3; j++) shimmer(50.0 * j, null, 5),
        ],
      ),
    );
  }
}
