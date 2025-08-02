import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/home/dashboard_model.dart';
import 'package:senthil/widgets/home/indicator.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key, required this.data});
  final DashboardData data;

  @override
  State<PieChartWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartWidget> {
  int total = 0;
  int touchedIndex = -1;
  final amounttitles = ['Paid', 'Concussion', 'Exclusion', 'Balance'];
  final colors = [
    AppController.headColor,
    AppController.darkGreen,
    AppController.lightBlue,
    AppController.yellow,
  ];

  @override
  void initState() {
    final data = widget.data;
    total = data.banner.concussionamount +
        data.banner.balanceamount +
        data.banner.exclusionamount +
        data.banner.paidamount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: 450,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (var t = 0; t < amounttitles.length; t++)
                Indicator(
                  color: colors[t],
                  text: amounttitles[t],
                  isSquare: true,
                ),
              SizedBox(height: 18),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 13.0;
      final radius = isTouched ? 60.0 : 50.0;
      TextStyle style = TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: const Color.fromARGB(255, 0, 0, 0), blurRadius: 2),
        ],
      );
      final data = widget.data;
      switch (i) {
        case 0:
          final value = (data.banner.paidamount / total) * 100;
          return PieChartSectionData(
            color: AppController.headColor,
            value: value.toDouble(),
            title: '${value.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: style,
          );
        case 1:
          final value = (data.banner.concussionamount / total) * 100;
          return PieChartSectionData(
            color: AppController.darkGreen,
            value: value.toDouble(),
            title: '${value.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: style,
          );
        case 2:
          final value = (data.banner.exclusionamount / total) * 100;
          return PieChartSectionData(
            color: AppController.lightBlue,
            value: value.toDouble(),
            title: '${value.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: style,
          );
        case 3:
          final value = (data.banner.balanceamount / total) * 100;
          return PieChartSectionData(
            color: AppController.yellow,
            value: value.toDouble(),
            title: '${value.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: style,
          );
        default:
          throw Error();
      }
    });
  }
}
