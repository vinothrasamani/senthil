import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleListShimmer extends StatelessWidget {
  const SimpleListShimmer({super.key, required this.isDark});
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < 15; i++)
              ListTile(
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Expanded(child: shimmer(28, null)),
                  ],
                ),
                trailing: shimmer(25, 25),
              ),
          ],
        ),
      ),
    );
  }
}
