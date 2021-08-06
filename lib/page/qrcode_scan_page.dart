import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:solviolin/util/network.dart';
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.chevron_left, size: 28.r),
        ),
        title: Text("코드스캔", style: TextStyle(fontSize: 28.sp)),
        backgroundColor: Colors.transparent,
      ),
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
                    await Get.put(Client()).checkIn(result!.code);
                    Get.back();
                  } catch (e) {
                    showErrorMessage(context, e.toString());
                  }
                });
              });
            },
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderWidth: 10,
              borderRadius: 10,
              borderLength: 20,
              cutOutSize: 0.8.sw,
            ),
          ),
          Positioned(
            bottom: 10.h,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result != null ? "Complete!" : "Scan a code",
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() async {
                    await qrController?.toggleFlash();
                  });
                },
                icon: FutureBuilder<bool?>(
                  future: qrController?.getFlashStatus(),
                  builder: (context, snapshot) => snapshot.data != null
                      ? Icon(snapshot.data! ? Icons.flash_on : Icons.flash_off)
                      : Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
