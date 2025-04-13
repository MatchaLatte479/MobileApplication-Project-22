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
    final detailLines = (item['detail'] as String?)?.split(', ') ?? [];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...dataLines.map((line) =>
                Text('- $line', style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(height: 10),
            ...detailLines.map((line) => Text('- $line')).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ประวัติการคำนวณ')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return InkWell(
            onTap: () => _showDetail(item),
            child: SizedBox(
              width: 336,
              height: 68,
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE6E6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['name']}',
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_outlined,
                          color: Colors.red),
                      onPressed: () => _deleteEntry(item['id']),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
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
