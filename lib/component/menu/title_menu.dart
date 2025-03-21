import 'package:flutter/material.dart';

titleMenu({
  BuildContext? context,
  String imageUrl = '',
  String title = '',
  Function? callback,
  bool showButton = true,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          // Container(
          //   padding: EdgeInsets.all(6.0),
          //   margin: EdgeInsets.only(left: 15, right: 5.0),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //         Theme.of(context).accentColor,
          //         Theme.of(context).primaryColor,
          //       ],
          //       begin: Alignment.topLeft,
          //       end: new Alignment(1, 0.0),
          //     ),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   height: 30,
          //   width: 30,
          //   child: Container(
          //     child: Image.network(
          //       imageUrl,
          //     ),
          //   ),
          // ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 15, bottom: 5),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1B6CA8),
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ],
      ),
      showButton
          ? InkWell(
              onTap: () {
                callback!();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 15),
                margin: const EdgeInsets.only(bottom: 5),
                child: const Text(
                  'ดูทั้งหมด',
                  style: TextStyle(
                    color: Color(0xFFED6B2D),
                    // decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            )
          : Container(),
    ],
  );
}
