// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrmovie/screens/misentradasscreen.dart';
import 'package:qrmovie/screens/showtimes_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String _qrCode = 'nada';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EntradasReservadas()));
              },
              child: Row(
                children: [
                  Text('Mis entradas'),
                  Image.asset('assets/entrada-de-cine.png')
                ],
              ))
        ],
        title: Text('QR SCANNER'),
      ),
      body: Center(
          child: GestureDetector(
              onTap: () {
                qrScann();
              },
              child: Image(
                image: AssetImage('assets/qrimg.png'),
              ))),
    );
  }

  Future<void> qrScann() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (!mounted) return;
      setState(() {
        _qrCode = qrCode;
      });

      if (_qrCode != '-1')
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CinemaShowtime(cine: _qrCode)));
    } on PlatformException {
      _qrCode = "Fail";
    }
  }
}
