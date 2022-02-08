import 'package:flutter/material.dart';

GestureDetector SimpleButtonMethodWidget(fuct(), h, w, s, size) {
  return GestureDetector(
    onTap: () {
      fuct();
    },
    child: Container(
      child: Center(
        child: Text(
          s,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF646464),
            fontSize: size,
          ),
        ),
      ),
      height: h,
      width: w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Color(0xFF646464))),
    ),
  );
}
