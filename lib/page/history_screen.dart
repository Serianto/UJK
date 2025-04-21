import 'package:absensi/model/save_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen  extends StatelessWidget {
  const HistoryScreen ({super.key});

@override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<SaveModel>(context);
    final history = absenProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absen'),
        centerTitle: true,
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Hapus Semua',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Hapus Semua Riwayat'),
                    content: const Text('Apakah kamu yakin ingin menghapus semua riwayat absen?'),
                    actions: [
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: const Text('Hapus'),
                        onPressed: () {
                          absenProvider.clearHistory();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('Belum ada riwayat absen.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[history.length - 1 - index]; // urutan terbaru di atas
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Hapus Riwayat'),
                        content: const Text('Yakin ingin menghapus riwayat ini?'),
                        actions: [
                          TextButton(
                            child: const Text('Batal'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          ElevatedButton(
                            child: const Text('Hapus'),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    absenProvider.removeHistoryAt(history.length - 1 - index);
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor: item.status == 'masuk' ? Colors.green : Colors.orange,
                        child: Icon(
                          item.status == 'masuk' ? Icons.login : Icons.info_outline,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        item.status.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.alasan != null && item.alasan!.isNotEmpty)
                            Text('Alasan: ${item.alasan}'),
                          Text('Waktu: ${item.waktu}'),
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