import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/data_sf_timeslot.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SfTimeslotReserved extends StatefulWidget {
  final Stream<DateTime> stream;

  const SfTimeslotReserved({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  _SfTimeslotReservedState createState() => _SfTimeslotReservedState();
}

class _SfTimeslotReservedState extends State<SfTimeslotReserved> {
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
    return SfCalendar(
      view: CalendarView.day,
      minDate: _selectedDay,
      maxDate: _selectedDay.add(Duration(milliseconds: 100)),
      headerHeight: 0,
      viewHeaderHeight: 0,
      // timeZone: "Korea Standard Time",
      selectionDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      dataSource: ReservationDataSource(getDataSource()),
      specialRegions: getTimeRegions(),
      timeSlotViewSettings: TimeSlotViewSettings(
        startHour: 8.5,
        endHour: 18.5,
        timeFormat: "h:mm",
        timeInterval: Duration(minutes: 30),
        timeTextStyle: TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: Colors.greenAccent,
        ),
      ),
      onTap: (details) {
        _showReserveDialog(context, details);
      },
    );
  }

  Future<void> _showReserveDialog(
      BuildContext context, CalendarTapDetails details) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return details.appointments == null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 300,
                  margin:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: SizedBox.expand(
                    child: FlutterLogo(),
                  ),
                ),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
                  margin:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
      barrierLabel: "Reserve",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
