import 'package:flutter/material.dart';

class SwipeableList extends StatefulWidget {
  final int currentPage;
  final List<dynamic> items;
  final Widget content;
  final double height;

  const SwipeableList({
    Key? key,
    required this.currentPage,
    required this.items,
    required this.content,
    required this.height,
  }) : super(key: key);

  @override
  _SwipeableListState createState() => _SwipeableListState();
}

class _SwipeableListState extends State<SwipeableList> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: widget.height,
          child: PageView.builder(
            controller: PageController(),
            physics: ClampingScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return DefaultTextStyle(
                style: TextStyle(fontSize: 28),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: widget.content,
                ),
              );
            },
          ),
        ),
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  widget.items.length,
                  (index) => index == _currentPage
                      ? indicator(isActive: true)
                      : indicator(isActive: false),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget indicator({required bool isActive}) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: isActive ? const Color.fromRGBO(96, 128, 104, 100) : Colors.grey,
        shape: BoxShape.circle,
      ),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      duration: const Duration(milliseconds: 150),
    );
  }
}
