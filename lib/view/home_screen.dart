import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/home_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/settings_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/home/dashboard_model.dart';
import 'package:senthil/model/home/exam_results_model.dart';
import 'package:senthil/shimmer/home_shimme.dart';
import 'package:senthil/view/image_viewer_screen.dart';
import 'package:senthil/widgets/app_drawer.dart';
import 'package:senthil/widgets/home/collection_card.dart';
import 'package:senthil/widgets/common_error_widget.dart';
import 'package:senthil/widgets/popup_menu.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<ExamResult>> future;

  List<Widget> cardList(DashboardModel banner) => [
        for (var item in banner.data)
          CollectionCard(
            data: item,
            index: ref.watch(SettingsController.defaultPayment),
          ),
      ];

  @override
  void initState() {
    future = HomeController.fetchResults();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SettingsController.loadSettings(ref);
      SettingsController.loadControls(ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Column column = Column(mainAxisSize: MainAxisSize.min);
    final size = MediaQuery.of(context).size;
    Center center = const Center();
    final user = ref.watch(LoginController.userProvider);
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final listenNotice = ref.watch(HomeController.noticeData(user!.data!.id));
    final listenBanner = ref.watch(HomeController.bannerData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [PopupMenu(user: user), SizedBox(width: 8)],
      ),
      body: Row(
        children: [
          if (size.width > 900) ...[
            AppDrawer(),
            SizedBox(width: 1, child: VerticalDivider(width: 0.5)),
          ],
          Expanded(
            child: SafeArea(
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
                                color: isDark
                                    ? AppController.lightBlue
                                    : baseColor),
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
                            horizontal: 10,
                            vertical: size.width >= 500 ? 8 : 10),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: size.width >= 500 ? 8 : 5),
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
                    error: (e, _) => CommonErrorWidget(),
                    loading: () => HomeShimmer(isDark: isDark, id: 1),
                  ),
                  if (ref.watch(SettingsController.canShowCollection))
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
                  if (ref.watch(SettingsController.canShowResult))
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
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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
                                          child: Builder(builder: (context) {
                                            final url =
                                                '${AppController.baseResultImageUrl}/${snap.data![index].image}';
                                            return GestureDetector(
                                              onTap: () => Get.to(
                                                  () => ImageViewerScreen(
                                                      url: url,
                                                      name: snap
                                                          .data![index].title,
                                                      from: 'network'),
                                                  transition: Transition
                                                      .rightToLeftWithFade),
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    padding: EdgeInsets.all(20),
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.red[400],
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  autoPlay: true,
                                  height: kIsWeb
                                      ? size.height * 0.80
                                      : size.height < size.width
                                          ? size.width * 0.75
                                          : size.height * 0.75,
                                  clipBehavior: Clip.hardEdge,
                                  viewportFraction: kIsWeb && size.width > 500
                                      ? kIsWeb && size.width > 1000
                                          ? 0.3
                                          : 0.6
                                      : 1.0,
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
          ),
        ],
      ),
      drawer: size.width > 900 ? null : AppDrawer(),
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
