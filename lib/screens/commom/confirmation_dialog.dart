import 'package:flutter/material.dart';

String title = "Atenção!";
String content = "Você deseja executar esta ação ?";
String affirmativeOption = "Confirmar";

Future<dynamic> showConfirmationDialog(BuildContext context, {required String content, required String affirmativeOption}) {

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          content: Text(content),
          //Actions são os botões do dialog e as respectivas ações.
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                affirmativeOption.toUpperCase(),
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}
