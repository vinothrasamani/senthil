import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/home_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/home_shimme.dart';
import 'package:senthil/widgets/app_drawer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Column column = Column(mainAxisSize: MainAxisSize.min);
    final size = MediaQuery.of(context).size;
    Center center = const Center();
    final user = ref.watch(LoginController.userProvider);
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final listenNotice = ref.watch(HomeController.noticeData(user!.data.id));
    final listenBanner = ref.watch(HomeController.bannerData);
    final amounttitles = [
      'Target',
      'Concussion',
      'Net',
      'Paid',
      'Refund',
      'Balance'
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            listenNotice.when(
              data: (snap) => Builder(builder: (context) {
                column = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      snap.data.noticetitle,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: baseColor),
                    ),
                    const SizedBox(height: 8),
                    Text(snap.data.noticetext),
                    const SizedBox(height: 25),
                    Text(snap.data.noticeby),
                    const SizedBox(height: 10),
                  ],
                );
                center = Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image:
                        'https://senthil.ijessi.com/public/assets/img/illustrations/man-with-laptop.png',
                    width: size.width < 365
                        ? size.width < 340
                            ? 120
                            : 150
                        : null,
                    height: size.width < 365
                        ? size.width < 340
                            ? 120
                            : 150
                        : null,
                  ),
                );
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: size.width >= 500 ? 8 : 10),
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: size.width >= 500 ? 8 : 5),
                  width: size.width >= 500 ? null : double.infinity,
                  child: size.width >= 450
                      ? Row(
                          children: [
                            Flexible(flex: 5, child: column),
                            SizedBox(width: 10),
                            Flexible(flex: 3, child: center),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            column,
                            SizedBox(height: 15),
                            center,
                            SizedBox(height: 15)
                          ],
                        ),
                );
              }),
              error: (e, _) => SizedBox(
                height: 200,
                child: Center(
                    child: Text('Something went wrong! try again later!')),
              ),
              loading: () => HomeShimmer(isDark: isDark, id: 1),
            ),
            listenBanner.when(
                data: (schools) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.attach_money,
                                color: Colors.green, size: 25),
                          ),
                          title: Text(
                            'Collection Details',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: baseColor),
                          ),
                        ),
                        for (var item in schools.data)
                          ExpansionTile(
                            title: Text(item.name),
                            subtitle: Row(
                              children: [
                                Text(
                                  amounttitles[0],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
                error: (error, _) => SizedBox.shrink(),
                loading: () => HomeShimmer(isDark: isDark, id: 2))
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
