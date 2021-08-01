import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';

class ReservationGrid extends StatefulWidget {
  final Stream<DateTime> stream;

  const ReservationGrid({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  _ReservationGridState createState() => _ReservationGridState();
}

class _ReservationGridState extends State<ReservationGrid> {
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.stream.listen((selectedDay) {
      setState(() {
        _selectedDay = selectedDay;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return Container();
      },
    );
  }
}
