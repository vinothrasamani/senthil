import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/home/dashboard_model.dart';
import 'package:senthil/widgets/home/pie_chart_widget.dart';
import 'package:senthil/widgets/my_chip.dart';

class CollectionCard extends StatefulWidget {
  const CollectionCard({super.key, required this.data, required this.index});
  final DashboardData data;
  final int index;

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  bool canExtend = false;
  final amounttitles = [
    'Target',
    'Concussion',
    'Net',
    'Paid',
    'Exclusion',
    'Balance'
  ];

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    TextStyle style = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    BoxDecoration decoration = BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 0.5),
          blurRadius: 1,
          spreadRadius: 0.4,
          color: Colors.grey.withAlpha(150),
        ),
      ],
      borderRadius: BorderRadius.circular(2),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          padding: EdgeInsets.all(10),
          decoration: decoration,
          child: InkWell(
            onTap: () {
              setState(() {
                canExtend = !canExtend;
              });
            },
            child: Row(
              children: [
                Icon(Icons.school),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.school.name.split('-')[0],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: canExtend
                            ? TextOverflow.clip
                            : TextOverflow.ellipsis,
                      ),
                      Text(
                        item.school.name.split('-')[1],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                canExtend
                    ? Icon(Icons.keyboard_arrow_down_outlined)
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyChip(amounttitles[widget.index],
                              AppController.headColor),
                          SizedBox(height: 4),
                          Builder(builder: (context) {
                            final amt = int.parse(switch (widget.index) {
                              0 => item.banner.targetamount.toString(),
                              1 => item.banner.concussionamount.toString(),
                              2 => item.banner.netamount.toString(),
                              3 => item.banner.paidamount.toString(),
                              4 => item.banner.exclusionamount.toString(),
                              5 => item.banner.balanceamount.toString(),
                              _ => '00',
                            });

                            return TweenAnimationBuilder<int>(
                                duration: Duration(seconds: 1),
                                tween: IntTween(
                                    begin: amt > 50 ? amt - 50 : amt, end: amt),
                                builder: (context, value, child) {
                                  return Text(
                                      AppController.convertToCurrency('$value'),
                                      style: style);
                                });
                          })
                        ],
                      ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: canExtend
              ? Container(
                  margin: const EdgeInsets.only(
                      top: 2, left: 8, right: 8, bottom: 8),
                  padding: EdgeInsets.all(10),
                  decoration: decoration.copyWith(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      amountCard(amounttitles[0], style,
                          item.banner.targetamount.toString()),
                      amountCard(amounttitles[1], style,
                          item.banner.concussionamount.toString()),
                      amountCard(amounttitles[2], style,
                          item.banner.netamount.toString()),
                      amountCard(amounttitles[3], style,
                          item.banner.paidamount.toString()),
                      amountCard(amounttitles[4], style,
                          item.banner.exclusionamount.toString()),
                      amountCard(amounttitles[5], style,
                          item.banner.balanceamount.toString()),
                      PieChartWidget(data: widget.data),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget amountCard(String title, TextStyle style, String amt) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            SizedBox(width: 6),
            Expanded(child: Text(title, style: style)),
            SizedBox(width: 10),
            Text(AppController.convertToCurrency(amt), style: style),
          ],
        ),
      );
}
