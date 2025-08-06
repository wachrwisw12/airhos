import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

bool _isDialogShowing = false;

Future<void> showCheckInDialog(BuildContext context, String mode) async {
  if (_isDialogShowing) return; // ป้องกันเปิดซ้อน
  _isDialogShowing = true;

  try {
    // ขอสิทธิ์ตำแหน่ง
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('ไม่มีสิทธิ์เข้าถึงตำแหน่ง');
      }
    }

    // ดึงตำแหน่ง GPS ปัจจุบัน
    final position = await Geolocator.getCurrentPosition();
    final LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    final timeStr = DateFormat.Hm().format(now);
    final dateStr = DateFormat.yMMMMEEEEd(locale).format(now);

    final isCheckIn = mode == 'in';
    final confirmText = isCheckIn ? 'ลงเวลาเข้างาน' : 'ลงเวลาออกงาน';

    if (!context.mounted) return;

    final mapController = MapController();

    // แสดง dialog
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(confirmText),
        content: SizedBox(
          width: 320,
          height: 370,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dateStr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('เวลา: $timeStr'),
              const SizedBox(height: 10),
              Expanded(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    // ไม่มี zoom หรือ center ที่นี่
                    // ตั้งค่าผ่าน mapController.move()
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80,
                          height: 80,
                          point: currentLatLng,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.pop(context, 'OK');

              print(
                'ลงเวลา $mode ที่ตำแหน่ง $currentLatLng เวลา $timeStr วันที่ $dateStr',
              );
            },
            child: const Text('ตกลง'),
          ),
        ],
      ),
    ).then((_) {
      _isDialogShowing = false;
    });

    // เลื่อนแผนที่ไปตำแหน่งปัจจุบันและตั้ง zoom หลัง dialog แสดงแล้ว
    mapController.move(currentLatLng, 16);
  } catch (e) {
    _isDialogShowing = false;
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }
}
