import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ConsistencyShimmer extends StatelessWidget {
  const ConsistencyShimmer({super.key, required this.isDark});
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
          shimmer(30, null),
          shimmer(25, null),
          shimmer(25, 160),
          SizedBox(height: 10),
          Row(
            children: [
              for (var k = 0; k < 3; k++) shimmer(25, 120),
            ],
          ),
          SizedBox(height: 10),
          Table(
            columnWidths: {
              0: FlexColumnWidth(0.3),
              1: FlexColumnWidth(0.7),
            },
            border: TableBorder.all(color: Colors.grey),
            children: [
              TableRow(
                children: [
                  shimmer(30, null),
                  shimmer(30, null),
                ],
              ),
              for (var i = 0; i < 20; i++)
                TableRow(
                  children: [
                    shimmer(25, null),
                    shimmer(25, null),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
