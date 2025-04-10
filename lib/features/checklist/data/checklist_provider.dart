import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'checklist_item.dart';

final checklistProvider =
    StateNotifierProvider<ChecklistNotifier, List<ChecklistItem>>(
      (ref) => ChecklistNotifier(),
    );

class ChecklistNotifier extends StateNotifier<List<ChecklistItem>> {
  final Box<ChecklistItem> _box = Hive.box<ChecklistItem>('checklistBox');

  ChecklistNotifier() : super([]) {
    loadChecklist();
  }

  void loadChecklist() {
    state = _box.values.toList();
  }

  void addItem(ChecklistItem item) {
    _box.put(item.id, item);
    state = [...state, item];
  }

  void toggleItem(String id) {
    final updatedList =
        state.map((item) {
          if (item.id == id) {
            final updated = item.copyWith(isChecked: !item.isChecked);
            _box.put(id, updated);
            return updated;
          }
          return item;
        }).toList();

    state = updatedList;
  }

  void removeItem(String id) {
    _box.delete(id);
    state = state.where((item) => item.id != id).toList();
  }
}
