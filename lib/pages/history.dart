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
    final size = dataLines.firstWhere((line) => line.contains('Solar Rooftop'),
        orElse: () => '');
    final price =
        dataLines.firstWhere((line) => line.contains('ราคา'), orElse: () => '');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'บริษัท โลซ่าเซลล์ จำกัด',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1.2),
              _receiptRow('ชื่อ', item['name']),
              if (size.isNotEmpty)
                _receiptRow('Solar Rooftop', size.replaceAll('Solar Rooftop ', '')),
              if (price.isNotEmpty)
                _receiptRow(
                    'ราคา',
                    price
                        .replaceFirst('ราคา', '')
                        .replaceFirst(':', '')
                        .trim()),
              const Divider(thickness: 1.2),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE6E6E6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'ปิด',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
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
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              height: 68,
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
          );
        },
      ),
    );
  }
}
