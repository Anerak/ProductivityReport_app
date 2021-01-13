import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'Report.g.dart';

@HiveType(typeId: 0)
class Report extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  int mood;
  @HiveField(2)
  String description;

  Report({@required this.mood, @required this.description})
      : date = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

  @override
  String toString() => '${date.day}/${date.month}/${date.year}';
}
