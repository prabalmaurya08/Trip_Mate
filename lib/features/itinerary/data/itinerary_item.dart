import 'package:hive/hive.dart';

part 'itinerary_item.g.dart';

@HiveType(typeId: 1) // Use a different typeId than Checklist
class ItineraryPlan {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String day;

  @HiveField(3)
  final String time;

  ItineraryPlan({
    required this.id,
    required this.title,
    required this.day,
    required this.time,
  });

  ItineraryPlan copyWith({
    String? id,
    String? title,
    String? day,
    String? time,
  }) {
    return ItineraryPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }
}
