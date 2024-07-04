import 'dart:async';

import 'package:flutter/material.dart';

Future infoDialog(
    {required BuildContext context,
    required String title,
    required String information}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20.0), // Ajusta el valor según el radio de redondeo deseado
        ),
        title: Text(title),
        content: Text(information),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

Future<bool?> decisionDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
}) async {
  final completer = Completer<bool?>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Stack(
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        content: SizedBox(
            width: screenSize.width * 0.75,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
            )),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              completer.complete(false);

              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              completer.complete(true);

              Navigator.of(context).pop();
            },
            child: const Text('Sí'),
          ),
        ],
      );
    },
  );

  return completer.future;
}
