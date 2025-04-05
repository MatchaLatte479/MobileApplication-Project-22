import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset("assets/logo.png"), // โลโก้มุมซ้ายบน
        ),
        title: Text("Welcome Back!"),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.png"), // รูปโปรไฟล์
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "สวัสดี Solar Cell",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text("ติดตั้ง Solar Cell", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("1 kW = ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("101 ต้น", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "เมนูทั้งหมด",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 140,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                List<Map<String, dynamic>> menuItems = [
                  {"icon": "assets/solar_power.png", "title": "ประเมิน", "color": Color(0xFF1B74BB)},
                  {"icon": "assets/calculate.png", "title": "คำนวณ", "color": Color(0xFF28A8E4)},
                  {"icon": "assets/history.png", "title": "ประวัติ", "color": Color(0xFFFBAF3F)},
                  {"icon": "assets/location_on.png", "title": "ใกล้ฉัน", "color": Color(0xFFE8C61C)},
                ];
                return _buildMenuItem(
                  menuItems[index]["icon"],
                  menuItems[index]["title"],
                  menuItems[index]["color"],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String iconPath, String title, Color color) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 50, height: 50),
          SizedBox(height: 10),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}