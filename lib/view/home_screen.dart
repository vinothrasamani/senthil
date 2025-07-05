import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/home_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/dashboard_model.dart';
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

    Widget amountCard(String title, TextStyle style, String amt) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              Expanded(child: Text(title, style: style)),
              SizedBox(width: 10),
              Text(AppController.convertToCurrency(amt), style: style),
            ],
          ),
        );

    List<Widget> cardList(DashboardModel banner) => [
          for (var item in banner.data)
            Builder(builder: (context) {
              final index = 3;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                child: Builder(builder: (context) {
                  TextStyle style =
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
                  return ExpansionTileItem.outlined(
                    isHasTrailing: false,
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(item.school.name)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                            child: Text(amounttitles[index], style: style)),
                        SizedBox(width: 10),
                        Builder(builder: (context) {
                          final amt = int.parse(switch (index) {
                            0 => item.banner.targetamount.toString(),
                            1 => item.banner.concussionamount.toString(),
                            2 => item.banner.netamount.toString(),
                            3 => item.banner.paidamount.toString(),
                            4 => item.banner.exclusionamount.toString(),
                            5 => item.banner.balanceamount.toString(),
                            _ => '00',
                          });

                          return TweenAnimationBuilder<int>(
                              duration: Duration(seconds: 2),
                              tween: IntTween(
                                  begin: amt > 50 ? amt - 50 : amt, end: amt),
                              builder: (context, value, child) {
                                return Text(
                                    AppController.convertToCurrency('$value'),
                                    style: style);
                              });
                        }),
                      ],
                    ),
                    children: [
                      if (index != 0)
                        amountCard(amounttitles[0], style,
                            item.banner.targetamount.toString()),
                      if (index != 1)
                        amountCard(amounttitles[1], style,
                            item.banner.concussionamount.toString()),
                      if (index != 2)
                        amountCard(amounttitles[2], style,
                            item.banner.netamount.toString()),
                      if (index != 3)
                        amountCard(amounttitles[3], style,
                            item.banner.paidamount.toString()),
                      if (index != 4)
                        amountCard(amounttitles[4], style,
                            item.banner.exclusionamount.toString()),
                      if (index != 5)
                        amountCard(amounttitles[5], style,
                            item.banner.balanceamount.toString()),
                    ],
                  );
                }),
              );
            }),
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
                          color: isDark ? AppController.lightBlue : baseColor),
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
                data: (banner) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: isDark ? Colors.grey.withAlpha(50) : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 216, 194, 0),
                              child: Icon(Icons.attach_money,
                                  color: Colors.white, size: 25),
                            ),
                            title: Text(
                              'Collection Details',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppController.lightBlue
                                      : baseColor),
                            ),
                          ),
                          if (size.width < 800)
                            ...cardList(banner)
                          else
                            LayoutBuilder(builder: (context, cons) {
                              return Wrap(
                                spacing: 5,
                                children: cardList(banner)
                                    .map((card) => SizedBox(
                                          width: (cons.maxWidth / 2) - 15,
                                          child: card,
                                        ))
                                    .toList(),
                              );
                            }),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, _) => SizedBox.shrink(),
                loading: () => HomeShimmer(isDark: isDark, id: 2)),
            SizedBox(height: 10),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
