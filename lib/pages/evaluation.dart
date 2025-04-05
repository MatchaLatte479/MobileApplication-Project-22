import 'package:flutter/material.dart';
import 'calculator.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({Key? key}) : super(key: key);

  @override
  _SolarEvaluationState createState() => _SolarEvaluationState();
}

class _SolarEvaluationState extends State<EvaluationPage> {
  List<int?> answers = [null, null, null];
  bool showResult = false;
  String resultType = '';

  final List<String> questions = [
    "พื้นที่หลังคาของท่านได้รับแสงแดดโดยตรงเป็นเวลานานหรือไม่?",
    "ค่าไฟฟ้ารายเดือนของท่านโดยเฉลี่ยอยู่ที่เท่าไหร่?",
    "รูปแบบการใช้ไฟฟ้าของคุณเป็นอย่างไร?",
  ];

  final List<List<String>> options = [
    [
      "ใช่, รับแดดเต็มที่ตลอดวัน",
      "พอมีแดดได้ แต่มีร่มเงาบ้าง",
      "ไม่ได้รับแดด มีร่มเงาตลอด"
    ],
    ["มากกว่า 3,500 บาท", "1,500 – 3,500 บาท", "ต่ำกว่า 1,500 บาท"],
    [
      "ใช้ไฟฟ้าส่วนใหญ่ตอนกลางวัน",
      "ใช้ไฟฟ้าทั้งกลางวันและกลางคืนพอ ๆ กัน",
      "ใช้ไฟฟ้าหนักช่วงกลางคืน"
    ],
  ];

  void evaluate() {
    if (answers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาตอบแบบประเมินให้ครบทุกข้อ')),
      );
      return;
    }

    setState(() {
      showResult = true;
      int option1Count = answers.where((answer) => answer == 0).length;

      if (option1Count == 3) {
        resultType = 'good';
      } else if (option1Count >= 1) {
        resultType = 'medium';
      } else {
        resultType = 'low';
      }
    });
  }

  Widget _buildResult() {
    switch (resultType) {
      case 'good':
        return _buildGoodResult();
      case 'medium':
        return _buildMediumResult();
      case 'low':
        return _buildLowResult();
      default:
        return Container();
    }
  }

Widget _buildGoodResult() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Frame 1: Main message with emoji
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFF6DFFAC),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              '😍', 
              style: TextStyle(fontSize: 40),
            ),
            Text(
              "Solar Rooftop\nเหมาะกับคุณ!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      // Frame 2: Selected options
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildColoredOption(0, options[0][answers[0]!]),
            _buildColoredOption(1, options[1][answers[1]!]),
            _buildColoredOption(2, options[2][answers[2]!]),
          ],
        ),
      ),

      // Frame 3: Recommendations and button
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF6DFFAC),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const Text(
              "ใช้ไฟช่วงกลางวันเยอะ = คุ้มค่า",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "ค่าไฟเกิน 1,500 บาท/เดือน = น่าลงทุน",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "หลังคาได้รับแดดเต็มที่ = ประสิทธิภาพดี",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD9D9D9),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorPage()),
                );
              },
              child: const Text("คำนวณ solar cell", style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildMediumResult() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // กรอบที่ 1: ข้อความหลัก
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFF95EDFF), // สีฟ้าอ่อน
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              '😊',
              style: TextStyle(fontSize: 40),
            ),
            Text(
              "มีแนวโน้มว่า \n Solar Rooftop \n คุ้มค่ากับท่าน :)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      // กรอบที่ 2: 3 ช้อยส์ที่เลือก
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9), // สีเทาอ่อน
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildColoredOption(0, options[0][answers[0]!]),
            _buildColoredOption(1, options[1][answers[1]!]),
            _buildColoredOption(2, options[2][answers[2]!]),
          ],
        ),
      ),

      // กรอบที่ 3: ข้อความแนะนำ
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF6DFFAC), // สีเขียวอ่อน
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Column(
          children: [
            Text(
              "ใช้ไฟช่วงกลางวันเยอะ = คุ้มค่า",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "ค่าไฟเกิน 1,500 บาท/เดือน = น่าลงทุน",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "หลังคาได้รับแดดเต็มที่ = ประสิทธิภาพดี",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildLowResult() {
    // ตรวจสอบว่ามีการเลือกช้อยส์ที่ 1 (index 0) ในคำถามใดคำถามหนึ่งหรือไม่

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // กรอบที่ 1: ข้อความหลัก
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF67B83),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                '😐',
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "อาจยังไม่ถึงเวลา \n สำหรับ \n Solar Rooftop",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // กรอบที่ 2: 3 ช้อยส์ที่เลือก (ปรับสีตามเงื่อนไข)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildColoredOption(0, options[0][answers[0]!]),
              _buildColoredOption(1, options[1][answers[1]!]),
              _buildColoredOption(2, options[2][answers[2]!]),
            ],
          ),
        ),

        // กรอบที่ 3: ข้อความแนะนำ
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF6DFFAC),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            children: [
              Text(
                "ใช้ไฟช่วงกลางวันเยอะ = คุ้มค่า",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "ค่าไฟเกิน 1,500 บาท/เดือน = น่าลงทุน",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "หลังคาได้รับแดดเต็มที่ = ประสิทธิภาพดี",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

// สร้าง Widget สำหรับแสดงช้อยส์พร้อมสีตามเงื่อนไข
Widget _buildColoredOption(int questionIndex, String text) {
  bool isOption1Selected = answers[questionIndex] == 0;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // เปลี่ยนเป็น start เพื่อให้ชิดซ้ายเดียวกัน
      crossAxisAlignment: CrossAxisAlignment.center, // จัดแนวตรงกลางแนวตั้ง
      children: [
        Container(
          width: 24, // ยังคงความกว้างเดิมสำหรับ alignment
          alignment: Alignment.centerLeft, // จัดชิดซ้ายภายใน container
          child: Container(
            width: 13, // ขนาดใหม่ตามที่ต้องการ
            height: 13, // ขนาดใหม่ตามที่ต้องการ
            decoration: BoxDecoration(
              color: isOption1Selected ? Color(0xFF31D176) : Color(0xFFEA1624),
              shape: BoxShape.circle, // เปลี่ยนเป็นวงกลม
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded( // เปลี่ยนจาก Flexible เป็น Expanded เพื่อความสม่ำเสมอ
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isOption1Selected ? Colors.green[800] : Colors.red[800],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildQuestionItem(int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${index + 1}. ${questions[index]}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              options[index].length,
              (j) => Padding(
                padding:
                    const EdgeInsets.only(bottom: 8), // ระยะห่างระหว่างช้อยส์
                child: RadioListTile<int>(
                  title: Text(
                    options[index][j],
                    style: const TextStyle(fontSize: 16),
                  ),
                  value: j,
                  groupValue: answers[index],
                  onChanged: (value) {
                    setState(() {
                      answers[index] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero, // ลบ padding ภายใน
                  dense: true,
                  visualDensity:
                      const VisualDensity(vertical: -4), // ชิดกันมากขึ้น
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: ElevatedButton(
        onPressed: evaluate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF31D176),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("CONFIRM", style: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildRetryButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: () {
          setState(() {
            showResult = false;
            answers = [null, null, null];
          });
        },
        child: const Text(
          "ทำแบบประเมินอีกครั้ง",
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        title: const Text("ประเมินว่าท่านควรติดตั้ง Solar Rooftop หรือไม่?",
            style: TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!showResult) ...[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildQuestionItem(0),
                    _buildQuestionItem(1),
                    _buildQuestionItem(2),
                  ],
                ),
              ),
              _buildConfirmButton(),
            ] else ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildResult(),
                      _buildRetryButton(),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
