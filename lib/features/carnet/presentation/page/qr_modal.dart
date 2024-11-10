import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:maqueta/core/providers/token_storage.dart';

class QrModal extends StatelessWidget {
  final TokenStorage tokenStorage = TokenStorage();

  QrModal({super.key});

  Future<String?> _getToken() async {
    // Obtener el token almacenado
    return await tokenStorage.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('Error retrieving token'),
          );
        }

        final token = snapshot.data!;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: PrettyQr(
            data: token, // Enviar solo el token en el código QR
            size: 200,
            roundEdges: true,
            elementColor: Colors.black,
            image: const AssetImage('images/logo_sena_negro.png'),
            errorCorrectLevel: QrErrorCorrectLevel.M,
          ),
        );
      },
    );
  }
}
