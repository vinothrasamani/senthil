import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key, required this.isDark, required this.id});
  final bool isDark;
  final int id;

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
    final width = MediaQuery.of(context).size.width;
    Column column = Column();
    Center center = const Center();

    column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmer(20, null),
        const SizedBox(
          height: 10,
        ),
        for (var s = 0; s < 10; s++)
          Column(
            children: [
              shimmer(12, s == 5 ? 200 : null),
              const SizedBox(height: 5)
            ],
          ),
        const SizedBox(
          height: 25,
        ),
        shimmer(10, 150),
        const SizedBox(
          height: 10,
        ),
      ],
    );

    center = Center(
      child: shimmer(250, 250),
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[isDark ? 800 : 300]!,
      highlightColor: Colors.grey[isDark ? 700 : 100]!,
      child: Builder(builder: (context) {
        if (id == 1) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: width >= 500 ? 8 : 20),
            margin: EdgeInsets.symmetric(
                horizontal: 20, vertical: width >= 500 ? 8 : 20),
            width: width >= 500 ? null : double.infinity,
            child: width >= 500
                ? Row(
                    children: [
                      Flexible(
                          flex: 5, child: SingleChildScrollView(child: column)),
                      Flexible(
                        flex: 3,
                        child: center,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      column,
                      center,
                    ],
                  ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Column(
              children: [
                for (var i = 0; i < 5; i++) shimmer(130, null, 5),
              ],
            ),
          );
        }
      }),
    );
  }
}
