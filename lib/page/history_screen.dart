import 'package:absensi/model/save_model.dart';
import 'package:absensi/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen  extends StatelessWidget {
  const HistoryScreen ({super.key});

@override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<SaveModel>(context);
    final history = absenProvider.history;
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absen'),
        centerTitle: true,
        backgroundColor: bg,
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
                        style: ElevatedButton.styleFrom(backgroundColor: tiga),
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
          ? const Center(
              child: Text(
                'Belum ada riwayat absen.',
                style: TextStyle(fontSize: 18, color: dua),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: isWideScreen
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: history.length,
                      itemBuilder: (context, index) =>
                          _buildCard(context, absenProvider, history.length - 1 - index, history),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) =>
                          _buildCard(context, absenProvider, history.length - 1 - index, history),
                    ),
            ),
    );
  }

Widget _buildCard(BuildContext context, SaveModel absenProvider, int index, List history) {
  final item = history[index]; // Pastikan ini adalah objek AbsenHistoryItem
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
              style: ElevatedButton.styleFrom(backgroundColor: tiga),
              child: const Text('Hapus'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
    },
    onDismissed: (_) {
      absenProvider.removeHistoryAt(index);
    },
    child: Card(
      color: lima,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: item.status == 'masuk' ? empat : tiga,
          child: Icon(
            item.status == 'masuk' ? Icons.login : Icons.logout,
            color: Colors.white,
          ),
        ),
        title: Text(
          item.status.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.alasan != null && item.alasan!.isNotEmpty)
              Text('Alasan: ${item.alasan}'),
              Text('Waktu: ${item.waktu}'),
            if (item.checkInLat != null && item.checkInLng != null)
              Text('Check-in Lat: ${item.checkInLat?.toStringAsFixed(6)}, Lng: ${item.checkInLng?.toStringAsFixed(6)}'),
            if (item.checkOutLat != null && item.checkOutLng != null)
              Text('Check-out Lat: ${item.checkOutLat?.toStringAsFixed(6)}, Lng: ${item.checkOutLng?.toStringAsFixed(6)}'),
          ],
        ),
      ),
    ),
  );
}

  // Widget _buildCard(BuildContext context, SaveModel absenProvider, int index, List history) {
  //   final item = history[index];
  //   return Dismissible(
  //     key: UniqueKey(),
  //     direction: DismissDirection.endToStart,
  //     background: Container(
  //       padding: const EdgeInsets.only(right: 20),
  //       alignment: Alignment.centerRight,
  //       color: Colors.red,
  //       child: const Icon(Icons.delete, color: Colors.white),
  //     ),
  //     confirmDismiss: (_) async {
  //       return await showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: const Text('Hapus Riwayat'),
  //           content: const Text('Yakin ingin menghapus riwayat ini?'),
  //           actions: [
  //             TextButton(
  //               child: const Text('Batal'),
  //               onPressed: () => Navigator.pop(context, false),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(backgroundColor: tiga),
  //               child: const Text('Hapus'),
  //               onPressed: () => Navigator.pop(context, true),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     onDismissed: (_) {
  //       absenProvider.removeHistoryAt(index);
  //     },
  //     child: Card(
  //       color: lima,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       elevation: 4,
  //       child: ListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         leading: CircleAvatar(
  //           backgroundColor: item.status == 'masuk' ? empat : tiga,
  //           child: Icon(
  //             item.status == 'masuk' ? Icons.login : Icons.logout,
  //             color: Colors.white,
  //           ),
  //         ),
  //         title: Text(
  //           item.status.toUpperCase(),
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //         subtitle: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             if (item.alasan != null && item.alasan!.isNotEmpty)
  //               Text('Alasan: ${item.alasan}'),
  //             Text('Waktu: ${item.waktu}'),
  //             const SizedBox(height: 4),
  //             Text('Latitude: ${item.latitude?.toStringAsFixed(6) ?? '-'}'),
  //             Text('Longitude: ${item.longitude?.toStringAsFixed(6) ?? '-'}'),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}