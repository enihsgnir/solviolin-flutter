import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:solviolin/extensions/dio_exception_description_extension.dart';
import 'package:solviolin/widgets/custom_snack_bar.dart';

extension LoadingOverlayExtension<T> on Future<T> {
  Future<T> withLoadingOverlay(BuildContext context) async {
    final overlay = OverlayEntry(
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Overlay.of(context).insert(overlay);

    try {
      final value = await this;

      if (!context.mounted) return value;
      showCustomSnackBar(context, message: "요청에 성공했습니다");

      return value;
    } catch (e) {
      final message = e is DioException ? e.description : null;
      showErrorSnackBar(context, message: message ?? "요청에 실패했습니다");

      rethrow;
    } finally {
      overlay.remove();
    }
  }
}
