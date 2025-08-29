import 'package:contextmenu/contextmenu.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_entry_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_entry_model.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/view/feedback_screen.dart';
import 'package:senthil/widgets/my_chip.dart';

class FeedbackEntryScreen extends ConsumerStatefulWidget {
  const FeedbackEntryScreen({super.key});

  @override
  ConsumerState<FeedbackEntryScreen> createState() =>
      _FeebackEntryScreenState();
}

class _FeebackEntryScreenState extends ConsumerState<FeedbackEntryScreen> {
  String? selectedType, selectedYear, selectedSchool, selectedSession;
  bool isDark = false;
  final formKey = GlobalKey<FormState>();
  final controller = FeedbackEntryController();
  final cardKey = GlobalKey<ExpansionTileCoreState>();
  final scroll = ScrollController();

  @override
  void initState() {
    controller.setData(ref, 'feedback-entry-init', {});
    super.initState();
  }

  void search() async {
    ref.read(controller.searching.notifier).state = true;
    final data = {
      "year": selectedYear,
      "type": selectedType,
      "school": selectedSchool,
      "session": selectedSession,
    };
    cardKey.currentState?.collapse();
    await ref.read(feedbackEntryProvider.notifier).fetchData(data);
    ref.read(controller.searching.notifier).state = false;
  }

  @override
  void dispose() {
    scroll.dispose();
    cardKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final snap = ref.watch(feedbackEntryProvider);

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(controller.years)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Year',
            prefixIcon: Icon(
              TablerIcons.calendar_smile,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedYear = val;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedType,
        items: ref
            .watch(controller.schoolTypes)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School Type',
            prefixIcon: Icon(TablerIcons.category, color: Colors.grey)),
        onChanged: (val) {
          selectedType = val;
          controller.setData(
            ref,
            'feedback-entry-schl',
            {'year': selectedYear, 'type': val},
          );
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedSchool,
        items: ref
            .watch(controller.schools)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School',
            prefixIcon: Icon(TablerIcons.school, color: Colors.grey)),
        onChanged: (val) {
          selectedSchool = val;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedSession,
        items: ref
            .watch(controller.sessions)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Session',
            prefixIcon: Icon(TablerIcons.timeline, color: Colors.grey)),
        onChanged: (val) {
          selectedSession = val;
        },
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(controller.searching);
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: searching ? null : search,
            child: Text(searching ? 'Searching...' : 'Search'),
          ),
        );
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Entry'),
        actions: [
          IconButton(
            onPressed: () {
              scroll.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.easeIn);
              cardKey.currentState?.expand();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          controller: scroll,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(controller.years).isNotEmpty)
              Form(
                key: formKey,
                child: ExpansionTileItem.outlined(
                  expansionKey: cardKey,
                  title: AppController.heading(
                      'Search', isDark, TablerIcons.search),
                  children: [
                    Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      children: dropdownList
                          .map((child) => SizedBox(
                                width: size.width < 500
                                    ? null
                                    : size.width < 1020
                                        ? (size.width / 2) - 30
                                        : (size.width / 3) - 30,
                                child: child,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
            else
              SearchShimmer(isDark: isDark),
            SizedBox(height: 20),
            if (ref.watch(controller.years).isNotEmpty)
              ref.watch(controller.searching)
                  ? ListShimmer(isDark: isDark)
                  : snap.isEmpty
                      ? SizedBox(
                          height: 200,
                          child: Center(
                              child:
                                  Text('Search to Get feedback entry list!')),
                        )
                      : Column(
                          children: [
                            AppController.heading('Feedback Entry List', isDark,
                                TablerIcons.message_2_check),
                            SizedBox(height: 10),
                            for (var item in snap)
                              Builder(builder: (context) {
                                final index = snap.indexOf(item) + 1;
                                return myCard(item, index);
                              }),
                          ],
                        ),
          ],
        ),
      ),
    );
  }

  Widget myCard(FeedbackEntry item, int index) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withAlpha(100), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppController.lightBlue,
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MyChip(item.entryDate.toIso8601String().split('T')[0],
                  AppController.darkGreen),
              Chip(
                avatar: Icon(TablerIcons.id),
                label: Text('${item.id}'),
                padding: EdgeInsets.all(0),
              )
            ],
          ),
          Wrap(
            spacing: 15,
            children: [
              myRow('Class Name', '${item.classname},'),
              myRow('Section', '${item.section},'),
              myRow('Ref Group', item.refgroup.toString()),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Text('Count : '),
                  GestureDetector(
                    onTapDown: (details) {
                      showContextMenu(
                        details.globalPosition,
                        context,
                        (ctx) => [
                          for (var l in item.feed.list)
                            ListTile(title: Text(l ?? '-')),
                        ],
                        40.0,
                        200.0,
                      );
                    },
                    child: Chip(
                      label: Text(
                        '${item.feed.fCount} - ${item.feed.eCount < 10 ? '0${item.feed.eCount}' : item.feed.eCount}',
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
              Spacer(),
              myButton(
                TablerIcons.eye,
                AppController.headColor,
                ontap: () {
                  Get.to(
                    () => FeedbackScreen(
                      index: item.schooltype == "CBSE" ? 0 : 1,
                      userId: ref.read(LoginController.userProvider)!.data!.id,
                      feedback: item,
                    ),
                  );
                },
              ),
              myButton(
                TablerIcons.trash,
                AppController.red,
                ontap: () =>
                    ref.read(feedbackEntryProvider.notifier).onDelete(item.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget myRow(String myKey, String val) {
    return Text.rich(
      TextSpan(
        text: '$myKey ',
        style: TextStyle(color: Colors.grey),
        children: [
          TextSpan(
            text: ': $val',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget myButton(IconData icon, Color color, {Function()? ontap}) {
    return IconButton(
      onPressed: ontap,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          color.withAlpha(20),
        ),
      ),
      icon: Icon(icon, color: color),
    );
  }
}
