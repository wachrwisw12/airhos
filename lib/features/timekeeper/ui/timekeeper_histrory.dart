import 'package:flutter/material.dart';

class TimekeeperHistroryScreen extends StatelessWidget {
  const TimekeeperHistroryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการลงเวลา'),
        backgroundColor: Color(0xFF227C9D),
      ),
      body: const Center(child: Text('แสดงรายการประวัติการลงเวลา')),
    );
  }
}
