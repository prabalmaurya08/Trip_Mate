import 'package:hive/hive.dart';

part 'checklist_item.g.dart'; // This will be generated

@HiveType(typeId: 0)
class ChecklistItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final bool isChecked;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.category,
    this.isChecked = false,
  });

  ChecklistItem copyWith({
    String? id,
    String? title,
    String? category,
    bool? isChecked,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
