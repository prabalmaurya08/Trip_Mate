import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:trip_mate/features/itinerary/data/itinerary_item.dart';

final itineraryProvider =
    StateNotifierProvider<ItineraryNotifier, List<ItineraryPlan>>((ref) {
      return ItineraryNotifier();
    });

class ItineraryNotifier extends StateNotifier<List<ItineraryPlan>> {
  final Box<ItineraryPlan> _box = Hive.box<ItineraryPlan>('itineraryBox');

  ItineraryNotifier() : super([]) {
    _loadPlans();
  }

  void _loadPlans() {
    state = _box.values.toList();
  }

  void addPlan(String title, String day, String time) {
    final plan = ItineraryPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      day: day,
      time: time,
    );
    _box.put(plan.id, plan);
    state = [...state, plan];
  }

  void removePlan(String id) {
    _box.delete(id);
    state = state.where((p) => p.id != id).toList();
  }
}
