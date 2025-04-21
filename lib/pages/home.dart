import 'package:flutter/material.dart';
import 'evaluation.dart';
import 'calculator.dart';
import 'history.dart';
import 'nearme.dart';
import 'information.dart';
import 'package:project/model/user_model.dart'; // เพิ่มการ import User

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/Solar.png"),
        ),
        title: const Text("Welcome Back!"),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ทักทายผู้ใช้ด้วยชื่อ
            Text(
              "สวัสดี คุณ ${widget.user.username}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InformationPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 199, 230, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: const [
                    Text("ติดตั้ง Solar Cell", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("1 kW = ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("101 ต้น",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "เมนูทั้งหมด",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 140,
              ),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.assessment_outlined,
                  title: "ประเมิน",
                  color: const Color(0xFF1B74BB),
                  page: const EvaluationPage(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.calculate_outlined,
                  title: "คำนวณ",
                  color: const Color(0xFF28A8E4),
                  page: const CalculatorPage(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.history_outlined,
                  title: "ประวัติ",
                  color: const Color(0xFFFBAF3F),
                  page: const HistoryPage(),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: "ใกล้ฉัน",
                  color: const Color(0xFFE8C61C),
                  page: const NearMePage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
