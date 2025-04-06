import 'package:flutter/material.dart';

class ResidentPage extends StatefulWidget {
  @override
  _ResidentScreenState createState() => _ResidentScreenState();
}

class _ResidentScreenState extends State<ResidentPage> {
  final List<Map<String, dynamic>> appliances = [
    {'name': 'หลอดไฟ', 'icon': Icons.lightbulb},
    {'name': 'ตู้เย็น', 'icon': Icons.kitchen},
    {'name': 'พัดลม', 'icon': Icons.toys},
    {'name': 'แอร์', 'icon': Icons.ac_unit},
    {'name': 'ทีวี', 'icon': Icons.tv},
    {'name': 'ไมโครเวฟ', 'icon': Icons.microwave},
  ];

  final Map<String, Map<String, TextEditingController>> selectedAppliances = {};
  Widget? _resultWidget;

  void addAppliance(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition.translate(1, 1),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: appliances.map((appliance) {
        return PopupMenuItem<String>(
          value: appliance['name'] as String,
          child: ListTile(
            leading: Icon(appliance['icon'] as IconData),
            title: Text(appliance['name'] as String),
          ),
        );
      }).toList(),
    ).then((value) {
      if (value is String && !selectedAppliances.containsKey(value)) {
        setState(() {
          selectedAppliances[value] = {
            'quantity': TextEditingController(),
            'hours': TextEditingController(),
          };
        });
      }
    });
  }

  void _clearAll() {
    setState(() {
      selectedAppliances.forEach((key, controllers) {
        controllers['quantity']?.dispose();
        controllers['hours']?.dispose();
      });
      selectedAppliances.clear();
      _resultWidget = null;
    });
  }

  void _calculate() {
    Map<String, double> powerRates = {
      'หลอดไฟ': 0.02,
      'ตู้เย็น': 0.15,
      'พัดลม': 0.07,
      'แอร์': 1.2,
      'ทีวี': 0.1,
      'ไมโครเวฟ': 1.2,
    };

    double totalKWhPerDay = 0.0;

    selectedAppliances.forEach((name, controllers) {
      // ตรวจสอบว่า controllers['quantity'] และ controllers['hours'] ไม่เป็น null
      int quantity = int.tryParse(controllers['quantity']?.text ?? '0') ?? 0;
      int hours = int.tryParse(controllers['hours']?.text ?? '0') ?? 0;
      double power = powerRates[name] ?? 0.0;

      totalKWhPerDay += quantity * hours * power;
    });

    if (totalKWhPerDay == 0.0) {
      // ถ้าคำนวณออกมาเป็น 0.0 (ยังไม่ได้กรอกข้อมูล), ไม่แสดงผล
      setState(() {
        _resultWidget = null;
      });
    } else {
      double estimatedKW = (totalKWhPerDay / 4).ceilToDouble();

      final List<Map<String, dynamic>> solarOptions = [
        {'kw': 3, 'price': 98000},
        {'kw': 5, 'price': 135000},
        {'kw': 10, 'price': 215000},
        {'kw': 15, 'price': 300000},
        {'kw': 20, 'price': 390000},
        {'kw': 30, 'price': 530000},
        {'kw': 60, 'price': 1200000},
        {'kw': 100, 'price': 2000000},
      ];

      final matched = solarOptions.firstWhere(
        (option) => option['kw'] >= estimatedKW,
        orElse: () => solarOptions.last,
      );

      setState(() {
        _resultWidget = Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Solar Rooftop \n ${matched['kw']} kW',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'ราคา ${matched['price'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')} บาท',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'เหมาะกับคุณ!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('บ้านพักอาศัย'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTapDown: (details) => addAppliance(context, details),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.add_circle_outline),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 47.0, right: 16.0, top: 16.0, bottom: 50.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 87,
                      alignment: Alignment.center,
                      child: Text('จำนวน', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(width: 35),
                    Container(
                      width: 87,
                      alignment: Alignment.center,
                      child: Text('ชั่วโมง', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Expanded(
                  child: ListView(
                    children: selectedAppliances.keys.map((key) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.5),
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  selectedAppliances[key]?['quantity']
                                      ?.dispose();
                                  selectedAppliances[key]?['hours']?.dispose();
                                  selectedAppliances.remove(key);
                                });
                              },
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(key, style: TextStyle(fontSize: 16)),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 87,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border:
                                        Border.all(color: Color(0xFFD9D9D9)),
                                  ),
                                  child: TextField(
                                    controller:
                                        selectedAppliances[key]!['quantity'],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 35),
                                Container(
                                  width: 87,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border:
                                        Border.all(color: Color(0xFFD9D9D9)),
                                  ),
                                  child: TextField(
                                    controller:
                                        selectedAppliances[key]!['hours'],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 260,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  onPressed: _clearAll,
                  child: Text('Clear'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  onPressed: () {
                    bool allFieldsFilled = true;

                    selectedAppliances.forEach((name, controllers) {
                      // ตรวจสอบว่า 'quantity' และ 'hours' มีค่าไม่เป็น null และไม่ว่าง
                      if ((controllers['quantity']?.text.isEmpty ?? true) ||
                          (controllers['hours']?.text.isEmpty ?? true)) {
                        allFieldsFilled = false;
                      }
                    });

                    if (allFieldsFilled) {
                      _calculate();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
                      );
                    }
                  },
                  child: Text('Calculate'), // ตรวจสอบว่าใส่ ',' ก่อนหน้านี้
                ),
              ],
            ),
          ),
          if (_resultWidget != null)
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: _resultWidget!,
            ),
        ],
      ),
    );
  }
}
