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

  void _calculate() {
    if (electricityUsageController.text.isEmpty ||
        electricityCostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

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
              if (showResult)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '😊',
                        style: TextStyle(fontSize: 40),
                      ),
                      Text(
                        'Solar Rooftop 100 kW',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '3,001,400 บาท',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
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
