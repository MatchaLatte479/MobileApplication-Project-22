import 'package:flutter/material.dart';

class ResidentScreen extends StatefulWidget {
  @override
  _ResidentScreenState createState() => _ResidentScreenState();
}

class _ResidentScreenState extends State<ResidentScreen> {
  final List<Map<String, dynamic>> appliances = [
    {'name': 'หลอดไฟ', 'icon': Icons.lightbulb},
    {'name': 'ตู้เย็น', 'icon': Icons.kitchen},
    {'name': 'พัดลม', 'icon': Icons.toys},
    {'name': 'แอร์', 'icon': Icons.ac_unit},
    {'name': 'ทีวี', 'icon': Icons.tv},
    {'name': 'ไมโครเวฟ', 'icon': Icons.microwave},
  ];
  final Map<String, Map<String, TextEditingController>> selectedAppliances = {};

  void addAppliance(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
          details.globalPosition, details.globalPosition.translate(1, 1)),
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
    });
  }

  void _calculate() {
    print('Calculating...');
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
            bottom: 280,
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
                  onPressed: _calculate,
                  child: Text('Calculate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
