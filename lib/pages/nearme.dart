import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearMePage extends StatefulWidget {
  const NearMePage({super.key});

  void _onNavigatePressed(BuildContext context) {
    // แค่แสดง SnackBar ว่ายังกดได้
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ฟีเจอร์กำลังพัฒนา...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  State<NearMePage> createState() => _NearMePageState();
}

class _NearMePageState extends State<NearMePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(13.8600, 100.5140); // พิกัดนนทบุรี

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('ร้านโซล่าเซลล์ใกล้ฉัน'),
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/map.png',
                height: 246,
                width: 322,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Solar Expert',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('5.0 / 5 คะแนน'),
                        Text('อำเภอปากเกร็ด นนทบุรี'),
                        Text('เปิด 24 ชั่วโมง'),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.navigation_outlined),
                  //   // onPressed: () => _onNavigatePressed(context),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
