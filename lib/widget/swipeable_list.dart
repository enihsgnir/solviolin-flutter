import 'package:flutter/material.dart';
import 'package:solviolin/util/constant.dart';

class SwipeableList extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const SwipeableList({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _SwipeableListState createState() => _SwipeableListState();
}

class _SwipeableListState extends State<SwipeableList> {
  final _key = GlobalKey();
  double? _height;
  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final _renderBox = _key.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        _height = _renderBox.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _items = List.generate(
      widget.itemCount,
      (index) => widget.itemBuilder(context, index),
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        IndexedStack(
          key: _key,
          children: [
            _height == null
                ? Container()
                : Container(
                    height: _height! + 16.r,
                    child: PageView(
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: _items,
                    ),
                  ),
            ..._items,
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.itemCount,
              (index) => _indicator(isActive: index == _currentPage),
            ),
          ),
        ),
      ],
    );
  }
}

Widget mySwipeableCard({
  EdgeInsetsGeometry? padding,
  required List<Widget> children,
}) {
  return Container(
    padding: padding ?? EdgeInsets.symmetric(vertical: 16.r),
    decoration: myDecoration,
    width: double.infinity,
    margin: EdgeInsets.all(8.r),
    child: DefaultTextStyle(
      style: TextStyle(fontSize: 28.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    ),
  );
}

Widget _indicator({required bool isActive}) {
  return AnimatedContainer(
    decoration: BoxDecoration(
      color: isActive ? symbolColor : Colors.grey,
      shape: BoxShape.circle,
    ),
    width: isActive ? 12.r : 8.r,
    height: isActive ? 12.r : 8.r,
    margin: EdgeInsets.symmetric(horizontal: 8.r),
    duration: const Duration(milliseconds: 150),
  );
}
