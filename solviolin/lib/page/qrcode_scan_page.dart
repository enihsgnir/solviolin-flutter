import 'package:flutter/material.dart';

class QRCodeScanPage extends StatefulWidget {
  const QRCodeScanPage({Key? key}) : super(key: key);

  @override
  _QRCodeScanPageState createState() => _QRCodeScanPageState();
}

class _QRCodeScanPageState extends State<QRCodeScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue.shade100,
        child: Text(
          "QRCode\nScan\nPage",
          style: TextStyle(
            fontSize: 75,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
