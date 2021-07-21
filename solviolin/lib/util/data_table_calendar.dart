import 'dart:collection';

import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:table_calendar/table_calendar.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 6, 1);
final kLastDay = DateTime(kToday.year, kToday.month + 7, 0);

LinkedHashMap<DateTime, List<Reservation>> getEvents() =>
    LinkedHashMap<DateTime, List<Reservation>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(getEventSource());

Map<DateTime, List<Reservation>> getEventSource() =>
    Get.put(MyReservationController()).reservations.groupBy((reservation) {
      DateTime date = reservation.startDate;
      return DateTime(date.year, date.month, date.day);
    });

extension _Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
