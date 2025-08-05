import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/home_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/notification_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/home/dashboard_model.dart';
import 'package:senthil/model/home/exam_results_model.dart';
import 'package:senthil/shimmer/home_shimme.dart';
import 'package:senthil/widgets/app_drawer.dart';
import 'package:senthil/widgets/home/collection_card.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<ExamResult>> future;

  List<Widget> cardList(DashboardModel banner) =>
      [for (var item in banner.data) CollectionCard(data: item, index: 3)];

  @override
  void initState() {
    future = HomeController.fetchResults();
    sendNotification('testing notification');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Column column = Column(mainAxisSize: MainAxisSize.min);
    final size = MediaQuery.of(context).size;
    Center center = const Center();
    final user = ref.watch(LoginController.userProvider);
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final listenNotice = ref.watch(HomeController.noticeData(user!.data.id));
    final listenBanner = ref.watch(HomeController.bannerData);

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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        title(
                            const Color.fromARGB(255, 216, 194, 0),
                            Icons.attach_money,
                            'Collection Details',
                            isDark,
                            banner.data[0].banner.academicYear),
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
                  );
                },
                error: (error, _) => SizedBox.shrink(),
                loading: () => HomeShimmer(isDark: isDark, id: 2)),
            SizedBox(height: 10),
            FutureBuilder(
              future: future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                }
                if (snap.hasError) {
                  return SizedBox.shrink();
                }
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      title(
                          const Color.fromARGB(255, 216, 194, 0),
                          TablerIcons.file_text,
                          'Exam Results',
                          isDark,
                          snap.data?[0].year ?? 'Year'),
                      SizedBox(height: 5),
                      CarouselSlider.builder(
                        itemCount: snap.data!.length,
                        itemBuilder: (ctx, index, child) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 0.5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  ),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    snap.data![index].title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Image.network(
                                    '${AppController.baseResultImageUrl}/${snap.data![index].image}',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          height: size.height < size.width
                              ? size.width * 0.75
                              : size.height * 0.75,
                          clipBehavior: Clip.hardEdge,
                          viewportFraction: 1.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  Widget title(
      Color color, IconData icon, String value, bool isDark, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 25),
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        value,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppController.lightBlue : baseColor),
      ),
      subtitle: Text(subtitle),
    );
  }
}
