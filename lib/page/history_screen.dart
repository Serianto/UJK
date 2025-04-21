import 'package:absensi/model/save_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen  extends StatelessWidget {
  const HistoryScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<SaveModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absen'),
      ),
      body: absenProvider.history.isEmpty
          ? const Center(child: Text('Belum ada riwayat absen.'))
          : ListView.builder(
              itemCount: absenProvider.history.length,
              itemBuilder: (context, index) {
                final item = absenProvider.history[index];
                return ListTile(
                  leading: Icon(
                    item.status == 'masuk' ? Icons.login : Icons.info,
                    color: item.status == 'masuk' ? Colors.green : Colors.orange,
                  ),
                  title: Text(item.status.toUpperCase()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.alasan != null) Text('Alasan: ${item.alasan}'),
                      Text('Waktu: ${item.waktu}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}