import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InformationPage(),
  ));
}

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text(
                'โลซ่าเซลล์ที่เรารัก!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/informationpic1.jpg',
                        width: 299,
                        height: 312,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('✅ เพิ่มพื้นที่สีเขียว ช่วยดูดซับก๊าซคาร์บอนไดออกไซด์'),
                          SizedBox(height: 8),
                          Text('✅ ไม่ก่อให้เกิดมลพิษหรือปล่อยก๊าซคาร์บอนไดออกไซด์'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Infographic Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/informationpic2.png',
                        width: 309,
                        height: 124,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Green Text Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'รู้หมือไร่!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            text:
                                'การติดตั้ง Solar Roof 1 กิโลวัตต์\nช่วยลดการปล่อยก๊าซคาร์บอนไดออกไซด์\nได้มากถึง ',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '901.3 กิโลกรัมต่อปี',
                                style: TextStyle(color: Color(0xFFEA1624)),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
