import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrmovie/screens/cartelera_screen.dart';

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
      print(_qrCode);
      if (_qrCode != '-1')
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CarteleraScreen()));
    } on PlatformException {
      _qrCode = "Fail";
    }
  }
}