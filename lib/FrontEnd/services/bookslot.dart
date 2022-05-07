import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListBookedSlot {
  Dio dio = new Dio();

  findSlot(date, slot) async {
    try {
      return await dio.post(
        'https://nitc-tele-health-app.herokuapp.com/searchslot',
        data: {
          "date": date,
          "slot": slot,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: e.response?.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
