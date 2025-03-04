import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:flutter/material.dart';

class ShowDialogDeletChat extends StatelessWidget {
  final String chatId;
  const ShowDialogDeletChat({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Hapus Chat?'),
      content: Text(
        'Apakah Anda yakin ingin menghapus chat ini? Semua histori chat akan dihapus.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Tidak'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await FirebaseService().deleteChat(chatId);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Chat berhasil dihapus')));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menghapus chat: $e')),
              );
            }
            Navigator.pop(context);
          },
          child: Text('Ya'),
        ),
      ],
    );
  }
}
