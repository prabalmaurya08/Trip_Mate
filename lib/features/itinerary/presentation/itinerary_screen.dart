import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_mate/core/notification_helper.dart';
import 'package:trip_mate/features/itinerary/data/itinerary_item.dart';

import '../data/itinerary_provider.dart';

class ItineraryScreen extends ConsumerStatefulWidget {
  const ItineraryScreen({super.key});

  @override
  ConsumerState<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  String selectedDay = "Day 1";

  final List<String> days = ["Day 1", "Day 2", "Day 3", "Day 4"];

  @override
  Widget build(BuildContext context) {
    final plans =
        ref
            .watch(itineraryProvider)
            .where((p) => p.day == selectedDay)
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Trip Itinerary",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          const SizedBox(height: 12),
          Expanded(
            child:
                plans.isEmpty
                    ? const Center(
                      child: Text(
                        "No plans for this day yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        return _buildPlanCard(plan);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlanSheet(),
        icon: const Icon(Icons.add),
        label: const Text("Add Plan"),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: days.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = day == selectedDay;
            return ChoiceChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedDay = day),
              selectedColor: Colors.teal,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlanCard(ItineraryPlan plan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.schedule, color: Colors.teal),
        title: Text(
          plan.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(plan.time),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed:
              () => ref.read(itineraryProvider.notifier).removePlan(plan.id),
        ),
      ),
    );
  }

  void _showAddPlanSheet() {
    final titleController = TextEditingController();
    TimeOfDay? selectedTime;

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
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Itinerary Plan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Plan Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime == null
                                ? "Select Time"
                                : selectedTime!.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final title = titleController.text.trim();
                      final time = selectedTime?.format(context);

                      if (title.isEmpty || time == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter both title and time."),
                          ),
                        );
                        return;
                      }

                      // Step 1: Add to provider (Hive will save it)
                      ref
                          .read(itineraryProvider.notifier)
                          .addPlan(title, selectedDay, time);

                      // Step 2: Schedule Notification
                      final now = DateTime.now();
                      final timeParts = time.split(":");
                      int planHour = int.tryParse(timeParts[0]) ?? now.hour;
                      int planMinute =
                          int.tryParse(timeParts[1].split(' ')[0]) ??
                          now.minute;

                      // Convert to 24-hour format if needed (e.g., PM)
                      if (time.contains("PM") && planHour < 12) planHour += 12;
                      if (time.contains("AM") && planHour == 12) planHour = 0;

                      final planDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        planHour,
                        planMinute,
                      );
                      final reminderTime = planDateTime.subtract(
                        const Duration(minutes: 30),
                      );

                      await NotificationHelper.scheduleNotification(
                        id:
                            DateTime.now().millisecondsSinceEpoch ~/
                            1000, // unique ID
                        title: 'Upcoming: $title',
                        body: 'Scheduled for $time',
                        dateTime: reminderTime,
                      );

                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Add Plan"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
