import 'package:flutter/material.dart';

GestureDetector ButtonMethodWidget(fuct(), h, w, s, size) {
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
            color: Colors.white,
            fontSize: size,
          ),
        ),
      ),
      height: h,
      width: w,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD84040), Color(0xFF940001)],
          )),
    ),
  );
}
