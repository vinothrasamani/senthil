import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_entry_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/shimmer/search_shimmer.dart';

class FeedbackEntryScreen extends ConsumerStatefulWidget {
  const FeedbackEntryScreen({super.key});

  @override
  ConsumerState<FeedbackEntryScreen> createState() =>
      _FeebackEntryScreenState();
}

class _FeebackEntryScreenState extends ConsumerState<FeedbackEntryScreen> {
  String? selectedType, selectedYear, selectedSchool, selectedSession;
  Object? data;
  final formKey = GlobalKey<FormState>();
  final controller = FeedbackEntryController();
  final cardKey = GlobalKey<ExpansionTileCoreState>();

  @override
  void initState() {
    controller.setData(ref, 'feedback-entry-init', {});
    super.initState();
  }

  void search() async {
    ref.read(controller.searching.notifier).state = true;
    data = {
      "year": selectedYear,
      "type": selectedType,
      "school": selectedSchool,
      "session": selectedSession,
    };
    cardKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener =
        data == null ? null : ref.watch(controller.fetchData(data!));

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
            labelText: 'Course Group',
            prefixIcon: Icon(Icons.group, color: Colors.grey)),
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
            labelText: 'stream group',
            prefixIcon: Icon(Icons.group, color: Colors.grey)),
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
            labelText: 'Ref group',
            prefixIcon: Icon(Icons.group, color: Colors.grey)),
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
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
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
              listener == null
                  ? SizedBox(
                      height: 200,
                      child: Center(
                          child: Text('Search to Get feedback entry list!')),
                    )
                  : listener.when(
                      data: (snap) {
                        return Column(
                          children: [],
                        );
                      },
                      error: (e, _) => SizedBox(
                        height: 200,
                        child: Center(child: Text('Something went wrong!')),
                      ),
                      loading: () => ListShimmer(isDark: isDark),
                    ),
          ],
        ),
      ),
    );
  }
}
