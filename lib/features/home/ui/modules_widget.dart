import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModulesWidget extends StatelessWidget {
  const ModulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          // child: Text(
          //   'โปรแกรม',
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              LearningStatus(
                icon: Icons.access_time,
                title: 'ลงเวลาปฏิบัติงาน',
                path: '/timekeeper',
              ),
              LearningStatus(
                icon: Icons.play_circle_outline,
                title: 'จองห้องประชุม',
                path: '/meeting',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LearningStatus extends StatelessWidget {
  final IconData icon;
  final String title;
  final String path;

  const LearningStatus({
    super.key,
    required this.icon,
    required this.title,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(path);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(icon, color: Colors.purple, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
