import 'package:arihos/features/auth/controller/auth_controller.dart';
import 'package:arihos/features/home/ui/modules_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_appbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

Future<void> _refresh() async {
  // ใส่โค้ดรีเฟรชข้อมูล เช่น ดึงข้อมูลใหม่จาก server
  // ตัวอย่างหน่วงเวลา 1 วิ
  await Future.delayed(const Duration(seconds: 1));
  // หรือเรียก provider เพื่อโหลดข้อมูลใหม่
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                ModulesWidget(),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).logout();
                  },
                  child: const Text("logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
