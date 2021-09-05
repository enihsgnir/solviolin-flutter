import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

Future showError(String message) {
  return Get.dialog(
    CupertinoAlertDialog(
      title: Text("Error", style: TextStyle(fontSize: 32.r)),
      content: Text(message, style: TextStyle(fontSize: 20.r)),
      actions: [
        CupertinoDialogAction(
          onPressed: Get.back,
          child: Text("확인", style: TextStyle(fontSize: 24.r)),
        ),
      ],
    ),
    barrierDismissible: false,
    barrierColor: Colors.black26,
  );
}

Widget mySearch({
  EdgeInsetsGeometry? padding,
  required List<Widget> contents,
}) {
  return Container(
    padding: padding ?? EdgeInsets.symmetric(vertical: 8.r),
    decoration: myDecoration,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        contents.length,
        (index) => Padding(
          padding: EdgeInsets.fromLTRB(24.r, 3.r, 0, 3.r),
          child: contents[index],
        ),
      ),
    ),
  );
}

Widget myActionButton({
  required void Function() onPressed,
  String action = "검색",
}) {
  return Padding(
    padding: EdgeInsets.only(left: 24.r),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: symbolColor),
      child: Text(action, style: TextStyle(fontSize: 20.r)),
    ),
  );
}

Widget myCard({
  List<Widget>? slideActions,
  EdgeInsetsGeometry? padding,
  required List<Widget> children,
}) {
  return Slidable(
    actionPane: const SlidableScrollActionPane(),
    actionExtentRatio: 1 / 5,
    secondaryActions: slideActions,
    child: Container(
      padding: padding ?? EdgeInsets.symmetric(vertical: 16.r),
      decoration: myDecoration,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white, fontSize: 24.r), //TODO
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    ),
  );
}

Widget mySlideAction({
  required IconData icon,
  required String item,
  required void Function() onTap,
  bool borderLeft = false,
  bool borderRight = false,
}) {
  return SlideAction(
    child: Row(
      children: [
        borderLeft
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 8.r),
                color: Colors.white,
                width: 0.25.r,
              )
            : Container(),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48.r),
                Text(
                  item,
                  style: TextStyle(color: Colors.white, fontSize: 20.r),
                )
              ],
            ),
          ),
        ),
        borderRight
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 8.r),
                color: Colors.white,
                width: 0.25.r,
              )
            : Container(),
      ],
    ),
    onTap: onTap,
  );
}

Widget myDialog({
  String? title,
  required List<Widget> contents,
  required void Function() onPressed,
  required String action,
}) {
  return AlertDialog(
    title: title == null
        ? null
        : Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 28.r),
          ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        contents.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 3.r, horizontal: 12.r),
          child: contents[index],
        ),
      ),
    ),
    actions: [
      OutlinedButton(
        onPressed: Get.back,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
        ),
        child: Text(
          "취소",
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ),
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: symbolColor,
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
        ),
        child: Text(action, style: TextStyle(fontSize: 20.r)),
      ),
    ],
  );
}

Future showMyDialog({
  required BuildContext context,
  String? title,
  required List<Widget> contents,
  required void Function() onPressed,
  String action = "확인",
  bool isScrolling = false,
}) {
  return Get.dialog(
    isScrolling
        ? GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: myDialog(
                    title: title,
                    contents: contents,
                    onPressed: onPressed,
                    action: action,
                  ),
                ),
              ],
            ),
          )
        : myDialog(
            title: title,
            contents: contents,
            onPressed: onPressed,
            action: action,
          ),
    barrierColor: Colors.black26,
  );
}

PreferredSizeWidget myAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      onPressed: Get.back,
      icon: Icon(CupertinoIcons.chevron_back, size: 28.r),
    ),
    title: Text(title, style: TextStyle(fontSize: 28.r)),
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}

Widget label(String item, bool isMandatory) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: item,
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
        TextSpan(
          text: isMandatory ? " *" : "",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.r,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget textInput(
  String item,
  TextEditingController controller, [
  String? validator,
]) {
  bool isMandatory = validator != null;

  return Row(
    children: [
      Container(
        width: 110.r,
        child: label(item, isMandatory),
      ),
      Container(
        width: 220.r,
        child: TextFormField(
          controller: controller,
          validator: (value) {
            return value == "" ? validator : null;
          },
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ),
    ],
  );
}

Widget check({
  String? tag,
  required String item,
  required String trueName,
  required String falseName,
  bool reverse = false,
  bool isMandatory = false,
}) {
  bool trueValue = false;
  bool falseValue = false;

  Get.find<CheckController>(tag: tag);

  return GetBuilder<CheckController>(
    tag: tag,
    builder: (controller) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            children: [
              Container(
                width: 120.r,
                child: label(item, isMandatory),
              ),
              Checkbox(
                value: trueValue,
                onChanged: (value) {
                  setState(() {
                    trueValue = value!;

                    if (trueValue && falseValue) {
                      controller.updateResult(null);
                    } else if (trueValue && !falseValue) {
                      controller.updateResult(reverse ? 0 : 1);
                    } else if (!trueValue && falseValue) {
                      controller.updateResult(reverse ? 1 : 0);
                    } else {
                      controller.updateResult(null);
                    }
                  });
                },
              ),
              Text(
                trueName,
                style: TextStyle(color: Colors.white, fontSize: 20.r),
              ),
              Checkbox(
                value: falseValue,
                onChanged: (value) {
                  setState(() {
                    falseValue = value!;

                    if (trueValue && falseValue) {
                      controller.updateResult(null);
                    } else if (trueValue && !falseValue) {
                      controller.updateResult(reverse ? 0 : 1);
                    } else if (!trueValue && falseValue) {
                      controller.updateResult(reverse ? 1 : 0);
                    } else {
                      controller.updateResult(null);
                    }
                  });
                },
              ),
              Text(
                falseName,
                style: TextStyle(color: Colors.white, fontSize: 20.r),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget myRadio<T>({
  String? tag,
  required String item,
  required List<String> names,
  required List<T> values,
  required T groupValue,
}) {
  RadioController<T> radio = Get.find<RadioController<T>>(tag: tag);
  radio.type = values[0];

  return StatefulBuilder(
    builder: (context, setState) {
      return DefaultTextStyle(
        style: TextStyle(color: Colors.white, fontSize: 20.r),
        child: Row(
          children: [
            Container(
              width: 120.r,
              child: label(item, true),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                names.length,
                (index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.r),
                  width: 65.r,
                  child: Column(
                    children: [
                      Text(names[index]),
                      Radio<T>(
                        value: values[index],
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });

                          radio.type = value!;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
