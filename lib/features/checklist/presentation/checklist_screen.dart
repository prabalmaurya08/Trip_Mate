import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../checklist/data/checklist_item.dart';
import '../../checklist/data/checklist_provider.dart';

class ChecklistScreen extends ConsumerWidget {
  final uuid = Uuid();

  ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklist = ref.watch(checklistProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Trip Checklist",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          checklist.isEmpty
              ? const Center(
                child: Text(
                  "No items. Add some!",
                  style: TextStyle(color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: checklist.length,
                itemBuilder: (context, index) {
                  final item = checklist[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(item.category),
                      value: item.isChecked,
                      onChanged: (_) {
                        ref
                            .read(checklistProvider.notifier)
                            .toggleItem(item.id);
                      },
                      secondary: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          ref
                              .read(checklistProvider.notifier)
                              .removeItem(item.id);
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBottomSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
      ),
    );
  }

  void _showAddBottomSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Checklist Item",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  final title = titleController.text.trim();
                  final category = categoryController.text.trim();

                  if (title.isEmpty || category.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields.")),
                    );
                    return;
                  }

                  final newItem = ChecklistItem(
                    id: uuid.v4(),
                    title: title,
                    category: category,
                  );
                  ref.read(checklistProvider.notifier).addItem(newItem);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text("Add Item"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
