import 'package:flutter/material.dart';

class OfficeScreen extends StatefulWidget {
  @override
  _OfficeScreenState createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  final TextEditingController electricityUsageController =
      TextEditingController();
  final TextEditingController electricityCostController =
      TextEditingController();
  bool showResult = false;
  Map<String, dynamic>? selectedSystem;

  // ข้อมูลระบบโซลาร์จากตาราง
  final List<Map<String, dynamic>> solarSystems = [
    {
      'kw': 40,
      'price': 680000,
      'phase': '3 เฟส',
      'roof_cost': 40000,
      'saving': 24000
    },
    {
      'kw': 50,
      'price': 960000,
      'phase': '3 เฟส',
      'roof_cost': 45000,
      'saving': 30000
    },
    {
      'kw': 60,
      'price': 1200000,
      'phase': '3 เฟส',
      'roof_cost': 50000,
      'saving': 36000
    },
    {
      'kw': 70,
      'price': 1420000,
      'phase': '3 เฟส',
      'roof_cost': 55000,
      'saving': 42000
    },
    {
      'kw': 80,
      'price': 1650000,
      'phase': '3 เฟส',
      'roof_cost': 60000,
      'saving': 48000
    },
    {
      'kw': 90,
      'price': 1800000,
      'phase': '3 เฟส',
      'roof_cost': 65000,
      'saving': 54000
    },
    {
      'kw': 100,
      'price': 2000000,
      'phase': '3 เฟส',
      'roof_cost': 70000,
      'saving': 60000
    },
    {
      'kw': 200,
      'price': 3650000,
      'phase': '3 เฟส',
      'roof_cost': 120000,
      'saving': 120000
    },
    {
      'kw': 300,
      'price': 5400000,
      'phase': '3 เฟส',
      'roof_cost': 180000,
      'saving': 180000
    },
    {
      'kw': 400,
      'price': 7200000,
      'phase': '3 เฟส',
      'roof_cost': 240000,
      'saving': 240000
    },
    {
      'kw': 500,
      'price': 9000000,
      'phase': '3 เฟส',
      'roof_cost': 300000,
      'saving': 300000
    },
  ];

  // ฟังก์ชันจัดรูปแบบตัวเลข
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  void _calculate() {
    if (electricityUsageController.text.isEmpty ||
        electricityCostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    final double monthlyUsage = double.parse(electricityUsageController.text);
    final double monthlyCost = double.parse(electricityCostController.text);

    // คำนวณกำลังไฟฟ้าที่ต้องการ (ใช้ค่าเฉลี่ย 4.5 ชั่วโมงแสงอาทิตย์ต่อวัน)
    final double requiredKw = monthlyUsage / (30 * 4.5);

    // หาระบบที่ใกล้เคียงที่สุด
    selectedSystem = solarSystems.reduce((a, b) {
      return (a['kw'] - requiredKw).abs() < (b['kw'] - requiredKw).abs()
          ? a
          : b;
    });

    setState(() {
      showResult = true;
    });
  }

  @override
  void dispose() {
    electricityUsageController.dispose();
    electricityCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Text('อาคารสำนักงาน'),
            SizedBox(width: 8),
            Icon(Icons.edit, size: 18),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1. ปริมาณไฟฟ้าที่ใช้ต่อเดือน (kWh)'),
              const SizedBox(height: 8),
              SizedBox(
                width: 217,
                height: 48,
                child: TextField(
                  controller: electricityUsageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('2. อัตราค่าไฟต่อเดือน (บาท)'),
              const SizedBox(height: 8),
              SizedBox(
                width: 217,
                height: 48,
                child: TextField(
                  controller: electricityCostController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/bill.png',
                  width: 300,
                  height: 193,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 300,
                    height: 193,
                    color: Colors.grey[200],
                    child: const Icon(Icons.receipt, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      setState(() {
                        electricityUsageController.clear();
                        electricityCostController.clear();
                        showResult = false;
                        selectedSystem = null;
                      });
                    },
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(150, 50),
                    ),
                    onPressed: _calculate,
                    child: const Text('Calculate'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (showResult && selectedSystem != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '😊',
                        style: TextStyle(fontSize: 40),
                      ),
                      Text(
                        'Solar Rooftop ${selectedSystem!['kw']} kW',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_formatNumber(selectedSystem!['price'] + selectedSystem!['roof_cost'])} บาท',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'ลดค่าไฟได้ ${_formatNumber(selectedSystem!['saving'])} บาทต่อเดือน',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ระยะเวลาคืนทุนประมาณ ${((selectedSystem!['price'] + selectedSystem!['roof_cost']) / selectedSystem!['saving']).toStringAsFixed(1)} เดือน',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'เหมาะกับคุณ!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
