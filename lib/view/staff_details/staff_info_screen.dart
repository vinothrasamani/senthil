import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/staff_details_model.dart';

class StaffInfoScreen extends StatelessWidget {
  const StaffInfoScreen({super.key, required this.staff});
  final StaffDetail staff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About ${staff.staffName}'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 6),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage('${AppController.baseImageUrl}/logo.png'),
                ),
                title: Text(
                  'Senthil ${staff.schooltype == 'CBSE' ? 'Public' : 'Metric'} School - ${staff.school}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage('${AppController.baseUrl}/${staff.photo}'),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
