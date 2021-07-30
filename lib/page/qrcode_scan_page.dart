import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/notification.dart';

class QRCodeScanPage extends StatefulWidget {
  const QRCodeScanPage({Key? key}) : super(key: key);

  @override
  _QRCodeScanPageState createState() => _QRCodeScanPageState();
}

class _QRCodeScanPageState extends State<QRCodeScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? qrController;

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: (controller) {
              // this.qrController = controller;
              controller.scannedDataStream.listen((scanData) {
                setState(() async {
                  result = scanData;
                  try {
                    await Get.put(Client()).checkIn(result!.code);
                    Get.back();
                  } catch (e) {
                    showErrorMessage(context, e.toString());
                  }
                });
              });
            },
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).accentColor,
              borderWidth: 10,
              borderRadius: 10,
              borderLength: 20,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(result != null ? "Complete!" : "Scan a code"),
              // "Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}"
            ),
          ),
          Positioned(
            top: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await qrController?.toggleFlash();
                      // setState(() {});
                    },
                    icon: FutureBuilder<bool?>(
                      future: qrController?.getFlashStatus(),
                      builder: (context, snapshot) => snapshot.data != null
                          ? Icon(
                              snapshot.data! ? Icons.flash_on : Icons.flash_off)
                          : Container(),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await qrController?.flipCamera();
                      // setState(() {});
                    },
                    icon: FutureBuilder(
                      future: qrController?.getCameraInfo(),
                      builder: (context, snapshot) => snapshot.data != null
                          ? Icon(Icons.switch_camera)
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
