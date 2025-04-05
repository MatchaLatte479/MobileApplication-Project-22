import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'โซล่าเซลล์ที่เรารัก!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '✓ เพิ่มพื้นที่สีเขียว ช่วยดูดซับก๊าซคาร์บอนไดออกไซด์\n'
                '✓ ไม่ก่อให้เกิดมลพิษหรือปล่อยก๊าซคาร์บอนไดออกไซด์',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/informationpic2.jpg',
                  width: 309,
                  height: 124,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'รู้หรือไม่!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'การติดตั้ง Solar Roof 1 กิโลวัตต์\nช่วยลดการปล่อยก๊าซคาร์บอนไดออกไซด์ได้มากถึง',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '901.3 กิโลกรัมต่อปี',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
