import 'package:flutter/material.dart';
import 'package:project/model/db_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];

  Future<void> loadHistory() async {
    final data = await DBHelper().getHistory();
    setState(() {
      history = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void _deleteEntry(int id) async {
    await DBHelper().deleteHistory(id);
    loadHistory();
  }

  void _showDetail(Map<String, dynamic> item) {
    final dataLines = item['data'].toString().split('\n');
    final detailLines = item['detail'].toString().split('\n');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          item['name'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Center(
          child: SingleChildScrollView(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: [
                if (dataLines.isNotEmpty) ...[
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('ขนาด'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dataLines.first.replaceAll('Solar Rooftop ', ''),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('ราคา'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dataLines.last.replaceAll('ราคา ', ''),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ],

                if (detailLines.any((line) => line.contains('ประหยัดเดือนละ'))) ...[
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('ประหยัดเดือนละ'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        detailLines
                            .firstWhere((line) => line.contains('ประหยัดเดือนละ'))
                            .replaceAll('ประหยัดเดือนละ ', ''),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ] else ...[
                  for (int i = 0; i < detailLines.length; i += 2)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          i == 0 ? 'เครื่องใช้ไฟฟ้า' : 'จำนวนชั่วโมงที่ใช้',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          detailLines[i].trim(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติการคำนวณ')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return InkWell(
            onTap: () => _showDetail(item),
            child: SizedBox(
              width: 336,
              height: 68,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_outlined,
                          color: Colors.red),
                      onPressed: () => _deleteEntry(item['id']),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
