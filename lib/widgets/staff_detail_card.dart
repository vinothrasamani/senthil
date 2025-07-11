import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/staff_details_model.dart';
import 'package:senthil/view/staff_details/staff_info_screen.dart';

class StaffDetailCard extends StatefulWidget {
  const StaffDetailCard({super.key, required this.staff});

  final StaffDetail staff;

  @override
  State<StaffDetailCard> createState() => _StaffDetailCardState();
}

class _StaffDetailCardState extends State<StaffDetailCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => StaffInfoScreen(staff: widget.staff),
          transition: Transition.zoom),
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.withAlpha(80)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isLoading)
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                Checkbox(
                  activeColor: AppController.lightGreen,
                  value: widget.staff.showhide == 1,
                  onChanged: (val) async {
                    setState(() {
                      isLoading = true;
                    });
                    final result = await AppController.fetch(
                        'staff-toggle-check/${widget.staff.id}');
                    final res = jsonDecode(result);
                    if (res != null) {
                      if (res['success']) {
                        widget.staff.showhide = res['data'];
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    widget.staff.staffName ?? "No name available!",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 6),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.download),
                ),
              ],
            ),
            Wrap(
              spacing: 5,
              children: [
                Chip(
                  avatar: Icon(
                    TablerIcons.category,
                    color: AppController.headColor,
                  ),
                  label: Text(widget.staff.catPres ?? 'None'),
                ),
                Chip(
                  avatar: Icon(
                    TablerIcons.building_store,
                    color: AppController.yellow,
                  ),
                  label: Text(widget.staff.department ?? 'None'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
