import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key}) : super(key: key);

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  Client _client = Get.find<Client>();

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
      appBar: appBar("체크인"),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: (controller) {
              qrController = controller;
              controller.scannedDataStream.listen((scanData) {
                setState(() async {
                  result = scanData;
                  try {
                    await _client.checkIn(result!.code);
                    Get.back();
                  } catch (e) {
                    showError(context, e.toString());
                  }
                });
              });
            },
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderWidth: 10.r,
              borderRadius: 10.r,
              borderLength: 20.r,
              cutOutSize: 400.r,
            ),
          ),
          Positioned(
            bottom: 10.r,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                result != null ? "Complete!" : "Scan a code",
                style: TextStyle(fontSize: 20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
