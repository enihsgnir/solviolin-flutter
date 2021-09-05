// import 'package:flutter/material.dart';
// import 'package:solviolin_admin/util/constant.dart';
// import 'package:solviolin_admin/util/data_source.dart';

// class SwipeableList extends StatefulWidget {
//   final int currentPage;
//   final List<dynamic> items;
//   final Widget content;
//   final double height;

//   const SwipeableList({
//     Key? key,
//     required this.currentPage,
//     required this.items,
//     required this.content,
//     required this.height,
//   }) : super(key: key);

//   @override
//   _SwipeableListState createState() => _SwipeableListState();
// }

// class _SwipeableListState extends State<SwipeableList> {
//   late int _currentPage;

//   @override
//   void initState() {
//     super.initState();
//     _currentPage = widget.currentPage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         Container(
//           height: widget.height,
//           child: PageView.builder(
//             controller: PageController(),
//             physics: ClampingScrollPhysics(),
//             onPageChanged: (page) {
//               setState(() {
//                 _currentPage = page;
//               });
//             },
//             itemCount: widget.items.length,
//             itemBuilder: (context, index) {
//               return DefaultTextStyle(
//                 style: TextStyle(fontSize: 28.r),
//                 child: Container(
//                   decoration: myDecoration,
//                   margin: EdgeInsets.all(8.r),
//                   child: widget.content,
//                 ),
//               );
//             },
//           ),
//         ),
//         Stack(
//           alignment: AlignmentDirectional.topStart,
//           children: [
//             Container(
//               margin: EdgeInsets.only(bottom: 16.r),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List<Widget>.generate(
//                   widget.items.length,
//                   (index) => index == _currentPage
//                       ? indicator(isActive: true)
//                       : indicator(isActive: false),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }

//   Widget indicator({required bool isActive}) {
//     return AnimatedContainer(
//       decoration: BoxDecoration(
//         color: isActive ? symbolColor : Colors.grey,
//         shape: BoxShape.circle,
//       ),
//       width: isActive ? 12.r : 8.r,
//       height: isActive ? 12.r : 8.r,
//       margin: EdgeInsets.symmetric(horizontal: 8.r),
//       duration: const Duration(milliseconds: 150),
//     );
//   }
// }
