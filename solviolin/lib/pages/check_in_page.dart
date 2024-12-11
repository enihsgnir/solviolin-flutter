import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:solviolin/providers/client_state/check_in_state_provider.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/loading_overlay.dart';

class CheckInPage extends ConsumerStatefulWidget {
  const CheckInPage({super.key});

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends ConsumerState<CheckInPage>
    with WidgetsBindingObserver {
  final controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  bool isDetected = false;
  StreamSubscription<BarcodeCapture>? subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        subscription = controller.barcodes.listen(handleBarcode);

        controller.start();
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        subscription?.cancel();
        subscription = null;
        controller.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    subscription = controller.barcodes.listen(handleBarcode);

    // Finally, start the scanner itself.
    controller.start();
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    subscription?.cancel();
    subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR 체크인"),
      ),
      body: MobileScanner(controller: controller),
    );
  }

  Future<void> handleBarcode(BarcodeCapture event) async {
    if (isDetected) return;

    isDetected = true;
    controller.stop();

    final code = event.barcodes.firstOrNull?.rawValue;
    if (code != null) {
      await showCheckIn(code);
    }

    if (!mounted) return;
    await controller.start();
    isDetected = false;
  }

  Future<void> showCheckIn(String branchCode) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("QR코드가 인식되었습니다"),
        SizedBox(height: 8),
        Text("체크인 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!mounted) return;
    await ref
        .read(checkInStateProvider.notifier)
        .checkIn(branchCode)
        .withLoadingOverlay(context);

    if (!mounted) return;
    context.pop();
  }
}
