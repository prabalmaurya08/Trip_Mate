import 'package:flutter/material.dart';

import 'dashboard/dashboard_screen.dart';


class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: DashboardScreen(),
    );
  }
}
