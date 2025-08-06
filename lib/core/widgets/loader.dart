import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ตัวแปรสำหรับเก็บ OverlayEntry เพื่อให้สามารถปิด Loader ได้
OverlayEntry? _loadingOverlayEntry;

// ฟังก์ชันสำหรับแสดง Loading Overlay
void showLoadingOverlay(BuildContext context) {
  // ตรวจสอบว่ามี Overlay แสดงอยู่แล้วหรือไม่ เพื่อป้องกันการแสดงซ้อน
  if (_loadingOverlayEntry != null) {
    return;
  }

  _loadingOverlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Modal Barrier (พื้นหลังทึบ/โปร่งแสง)
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5), // สีดำโปร่งแสง
          ),
        ),
        // Loading Indicator
        Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            elevation: 8.0,
            child: Container(
              width: 100, // กำหนดให้เป็นสี่เหลี่ยมจัตุรัส
              height: 100,
              padding: const EdgeInsets.all(20.0),
              child: SpinKitRing(
                color: const Color(0xFFE4402F),
                lineWidth: 4.0,
                size: 50.0,
              ),
            ),
          ),
        ),
      ],
    ),
  );
  // ป้องกันซ้อนกันกรณีมี async delay แทรก
  final overlay = Navigator.of(context).overlay;
  if (_loadingOverlayEntry != null && overlay != null) {
    overlay.insert(_loadingOverlayEntry!);
  }
  // เพิ่ม OverlayEntry เข้าไปใน Overlay ของ Navigator
  Navigator.of(context).overlay?.insert(_loadingOverlayEntry!);
}

// ฟังก์ชันสำหรับซ่อน Loading Overlay
void hideLoadingOverlay() {
  if (_loadingOverlayEntry != null) {
    _loadingOverlayEntry?.remove();
    _loadingOverlayEntry = null; // ตั้งค่าเป็น null เพื่อให้สามารถแสดงใหม่ได้
  }
}
