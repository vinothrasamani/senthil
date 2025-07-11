import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/staff_details_model.dart';

class StaffDetailCard extends StatelessWidget {
  const StaffDetailCard({super.key, required this.staff});

  final StaffDetail staff;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                Checkbox(
                  value: staff.showhide == 1,
                  onChanged: (val) {},
                ),
                Expanded(
                  child: Text(
                    staff.staffName ?? "No name available!",
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
                  label: Text(staff.catPres ?? 'None'),
                ),
                Chip(
                  avatar: Icon(
                    TablerIcons.building_store,
                    color: AppController.yellow,
                  ),
                  label: Text(staff.department ?? 'None'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
