import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_mate/features/checklist/data/checklist_provider.dart';
import 'package:trip_mate/features/checklist/presentation/checklist_screen.dart';
import 'package:trip_mate/features/itinerary/data/itinerary_provider.dart';
import 'package:trip_mate/features/itinerary/presentation/itinerary_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklist = ref.watch(checklistProvider);
    final itinerary = ref.watch(itineraryProvider);

    final completedItems = checklist.where((item) => item.isChecked).length;
    final totalItems = checklist.length;

    final nextEvent =
        itinerary.isNotEmpty
            ? (itinerary..sort((a, b) => a.time.compareTo(b.time))).first
            : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Trip Dashboard"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to your Trip!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Checklist Card
            _DashboardCard(
              title: "Checklist Progress",
              subtitle:
                  totalItems > 0
                      ? "$completedItems of $totalItems items completed"
                      : "No checklist items yet",
              icon: Icons.check_circle_outline,
              color: Colors.teal,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChecklistScreen()),
                  ),
            ),

            const SizedBox(height: 12),

            // Itinerary Card
            _DashboardCard(
              title: "Next Itinerary",
              subtitle:
                  nextEvent != null
                      ? "${nextEvent.title} • ${nextEvent.time}"
                      : "No events added yet",

              icon: Icons.calendar_today,
              color: Colors.indigo,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ItineraryScreen()),
                  ),
            ),

            const Spacer(),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ChecklistScreen()),
                        ),
                    icon: const Icon(Icons.list),
                    label: const Text("Checklist"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ItineraryScreen()),
                        ),
                    icon: const Icon(Icons.schedule),
                    label: const Text("Itinerary"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
