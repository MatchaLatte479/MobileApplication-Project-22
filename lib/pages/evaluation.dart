import 'package:flutter/material.dart';

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
    [
      "มากกว่า 3,500 บาท",
      "1,500 – 3,500 บาท",
      "ต่ำกว่า 1,500 บาท"
    ],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Solar Rooftop\nเหมาะกับคุณ!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCheckedOption(options[0][answers[0]!]),
          _buildCheckedOption(options[1][answers[1]!]),
          _buildCheckedOption(options[2][answers[2]!]),
          const SizedBox(height: 16),
          const Text(
            "ใช้ไฟช่วงกลางวันเยอะ = คุ้มค่า\n"
            "ค่าไฟเกิน 1,500 บาท/เดือน = น่าลงทุน\n"
            "หลังคาได้รับแดดเต็มที่ = ประสิทธิภาพดี",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text("คำนวณ solar cell"),
          ),
        ],
      ),
    );
  }

  Widget _buildMediumResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ยินดีด้วย! Solar Rooftop คุ้มค่ากับท่าน :)",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCheckedOption(options[0][answers[0]!]),
          _buildCheckedOption(options[1][answers[1]!]),
          _buildCheckedOption(options[2][answers[2]!]),
          const SizedBox(height: 16),
          const Text(
            "ใช้ไฟช่วงกลางวันเยอะ = คุ้มค่า\n"
            "ค่าไฟเกิน 1,500 บาท/เดือน = น่าลงทุน\n"
            "หลังคาได้รับแดดเต็มที่ = ประสิทธิภาพดี",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text("คำนวณ solar cell"),
          ),
        ],
      ),
    );
  }

  Widget _buildLowResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Solar Rooftop",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCheckedOption(options[0][answers[0]!]),
          _buildCheckedOption(options[1][answers[1]!]),
          _buildCheckedOption(options[2][answers[2]!]),
          const SizedBox(height: 16),
          const Text(
            "ใช้ไฟช่วงกลางวันเยอะ = คุ้มค่า\n"
            "ค่าไฟเกิน 1,500 บาท/เดือน = น่าลงทุน\n"
            "หลังคาได้รับแดดเต็มที่ = ประสิทธิภาพดี",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text("กลับไปหน้าหลัก"),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckedOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.check, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ประเมินว่าท่านควรติดตั้ง Solar Rooftop หรือไม่?"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showResult) ...[
              for (int i = 0; i < questions.length; i++) ...[
                Text(
                  "${i + 1}. ${questions[i]}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (int j = 0; j < options[i].length; j++)
                  RadioListTile<int>(
                    title: Text(options[i][j]),
                    value: j,
                    groupValue: answers[i],
                    onChanged: (value) {
                      setState(() {
                        answers[i] = value;
                      });
                    },
                  ),
                if (i < questions.length - 1) const SizedBox(height: 16),
              ],
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: evaluate,
                  child: const Text("ยืนยัน"),
                ),
              ),
            ] else ...[
              _buildResult(),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showResult = false;
                      answers = [null, null, null];
                    });
                  },
                  child: const Text("ทำแบบประเมินอีกครั้ง"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}