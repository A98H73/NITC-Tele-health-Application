import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListBookedSlot {
  Dio dio = new Dio();

  findSlot(date, slot, doc_spec_in) async {
    try {
      return await dio.post(
        'https://nitc-tele-health-app.herokuapp.com/searchslot',
        data: {
          "date": date,
          "slot": slot,
          "doc_spec_in": doc_spec_in,
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

  bookAnAppointment(_id, date, slot, start_time, end_time, doc_name, doc_email,
      doc_spec_in, descreption, app_booked, user_name, user_email) async {
    try {
      return await dio.put(
        'https://nitc-tele-health-app.herokuapp.com/updateslot/$_id',
        data: {
          "date": date,
          "slot": slot,
          "start_time": start_time,
          "end_time": end_time,
          "doc_name": doc_name,
          "doc_email": doc_email,
          "doc_spec_in": doc_spec_in,
          "descreption": descreption,
          "app_booked": app_booked,
          "user_name": user_name,
          "user_email": user_email
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
