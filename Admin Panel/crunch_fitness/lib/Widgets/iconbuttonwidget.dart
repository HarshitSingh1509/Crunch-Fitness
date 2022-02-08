import 'package:flutter/material.dart';

GestureDetector icobbuttonWidget(fuct(), h, s) {
  return GestureDetector(
    onTap: () {
      fuct();
    },
    child: Container(
      child: Center(child: s),
      height: h,
      width: h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(h / 2)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD84040), Color(0xFF940001)],
          )),
    ),
  );
}
