import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class ControlForTeacherPage extends StatefulWidget {
  const ControlForTeacherPage({Key? key}) : super(key: key);

  @override
  _ControlForTeacherPageState createState() => _ControlForTeacherPageState();
}

class _ControlForTeacherPageState extends State<ControlForTeacherPage> {
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/control");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: myAppBar("오픈/클로즈"),
        body: SafeArea(
          child: Column(
            children: [
              _controlSearch(),
              myDivider(),
              Expanded(
                child: _controlList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlSearch() {
    return mySearch(
      contents: [
        pickDate(
          context: context,
          item: "부터",
          tag: "/search/control",
          index: 0,
        ),
        Row(
          children: [
            pickDate(
              context: context,
              item: "까지",
              tag: "/search/control",
              index: 1,
            ),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await _data.getControlsForTeacherData(
                    controlStart: search.date[0],
                    controlEnd: search.date[1],
                  );

                  search.isSearched = true;

                  if (_data.controls.isEmpty) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
                } catch (e) {
                  showError(e);
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _controlList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return _data.controls.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      child: Icon(
                        CupertinoIcons.text_badge_xmark,
                        size: 48.r,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "계정 정보에 해당하는 오픈/클로즈 목록이 없습니다.",
                      style: TextStyle(color: Colors.red, fontSize: 22.r),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _data.controls.length,
                itemBuilder: (context, index) {
                  return myNormalCard(
                    children: [
                      Text(_data.controls[index].toString()),
                    ],
                  );
                },
              );
      },
    );
  }
}
