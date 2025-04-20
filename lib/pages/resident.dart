import 'package:flutter/material.dart';
import 'package:project/model/db_helper.dart';

class ResidentPage extends StatefulWidget {
  @override
  _ResidentScreenState createState() => _ResidentScreenState();
}

class _ResidentScreenState extends State<ResidentPage> {
  final List<Map<String, dynamic>> appliances = [
    {'name': 'หลอดไฟ', 'icon': Icons.lightbulb},
    {'name': 'ตู้เย็น', 'icon': Icons.kitchen},
    {'name': 'พัดลม', 'icon': Icons.wind_power},
    {'name': 'แอร์', 'icon': Icons.ac_unit},
    {'name': 'ทีวี', 'icon': Icons.tv},
    {'name': 'ไมโครเวฟ', 'icon': Icons.microwave},
  ];

  final Map<String, Map<String, TextEditingController>> selectedAppliances = {};
  Widget? _resultWidget;
  double? _lastEstimatedKW;
  int? _lastPrice;

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
      int quantity = int.tryParse(controllers['quantity']?.text ?? '0') ?? 0;
      int hours = int.tryParse(controllers['hours']?.text ?? '0') ?? 0;
      double power = powerRates[name] ?? 0.0;
      totalKWhPerDay += quantity * hours * power;
    });

    if (totalKWhPerDay == 0.0) {
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

      _lastEstimatedKW = matched['kw'].toDouble();
      _lastPrice = matched['price'];

      // เรียกถามชื่อและบันทึกทันที
      _showSaveDialog(context, _lastEstimatedKW!, _lastPrice!);

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
              const Text('😊', style: TextStyle(fontSize: 40)),
              Text(
                'Solar Rooftop \n ${matched['kw']} kW',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'ราคา ${matched['price'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')} บาท',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'เหมาะกับคุณ!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.green[700]),
              ),
            ],
          ),
        );
      });
    }
  }

  void _showSaveDialog(BuildContext context, double estimatedKW, int price) {
    final TextEditingController nameController = TextEditingController();

    final detail = selectedAppliances.entries.map((entry) {
      final name = entry.key;
      final quantity = entry.value['quantity']?.text ?? '0';
      final hours = entry.value['hours']?.text ?? '0';
      return '$name: $quantity ชิ้น, $hours ชม.';
    }).join('\n');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('ตั้งชื่อบ้าน'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'เช่น บ้าน A',
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // กำหนดสีของเส้นใต้
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue), // เปลี่ยนสีเส้นใต้เมื่อฟอร์มถูกเลือก
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final data =
                    'Solar Rooftop $estimatedKW kW\nราคา: ${price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')} บาท';
                await DBHelper().insertHistory(
                  name,
                  data,
                  detail, // บันทึกข้อมูลรายการเครื่องใช้ไฟฟ้า
                );

                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('บันทึกข้อมูลเรียบร้อยแล้ว')),
                );
              }
            },
            child: Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('บ้านพักอาศัย'),
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
                                icon: Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedAppliances[key]?['quantity']
                                        ?.dispose();
                                    selectedAppliances[key]?['hours']
                                        ?.dispose();
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
            bottom: 150,
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
                    backgroundColor: Color(0xFF31D176),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  onPressed: () {
                    bool allFieldsFilled = true;
                    bool allFieldsAreNumbers = true;

                    selectedAppliances.forEach((name, controllers) {
                      final quantityText = controllers['quantity']?.text ?? '';
                      final hoursText = controllers['hours']?.text ?? '';

                      if (quantityText.isEmpty || hoursText.isEmpty) {
                        allFieldsFilled = false;
                      } else {
                        if (int.tryParse(quantityText) == null ||
                            int.tryParse(hoursText) == null) {
                          allFieldsAreNumbers = false;
                        }
                      }
                    });

                    if (!allFieldsFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กรอกข้อมูลให้ครบทุกช่อง')),
                      );
                    } else if (!allFieldsAreNumbers) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กรอกเฉพาะตัวเลขเท่านั้น')),
                      );
                    } else {
                      _calculate();
                    }
                  },

                  child: Text('Calculate'), // ตรวจสอบว่าใส่ ',' ก่อนหน้านี้
                ),
              ],
            ),
          ),
          if (_resultWidget != null)
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: _resultWidget!,
            ),
        ],
      ),
    );
  }
}
