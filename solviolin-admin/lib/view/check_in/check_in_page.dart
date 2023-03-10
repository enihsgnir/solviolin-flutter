import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/single.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key}) : super(key: key);

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  var _client = Get.find<Client>();

  final qrKey = GlobalKey(debugLabel: "QR");
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
      appBar: myAppBar("QR 체크인"),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: (controller) {
              qrController = controller;
              controller.scannedDataStream.listen((scanData) async {
                setState(() {
                  result = scanData;
                });

                await controller.pauseCamera();

                await showLoading(() async {
                  try {
                    await _client.checkIn(result!.code!);

                    await controller.stopCamera();
                    Get.back();
                    await showMySnackbar(message: "체크인에 성공했습니다.");
                  } catch (e) {
                    Get.snackbar(
                      "",
                      "",
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: Text(
                        "Error",
                        style: TextStyle(color: Colors.white, fontSize: 28.r),
                      ),
                      messageText: Text(
                        e.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 24.r),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 2), () async {
                      await controller.resumeCamera();
                    });
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
        ],
      ),
    );
  }
}
