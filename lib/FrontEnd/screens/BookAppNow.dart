// import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nitc_telehealth_application/FrontEnd/services/bookslot.dart';
import 'package:nitc_telehealth_application/FrontEnd/services/createSchedule.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookAppNow extends StatefulWidget {
  final String problemtype = "";
  const BookAppNow({Key? key, @required problemtype}) : super(key: key);

  @override
  State<BookAppNow> createState() => _BookAppNowState();
}

class _BookAppNowState extends State<BookAppNow> {
  bool isAPICallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  String? user_name;
  String? user_rollno;
  String? user_email;
  String? slot;
  String? date;
  String? description;

  Future<List<UserValue>>? _futureData;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Morning"), value: "morning"),
      DropdownMenuItem(child: Text("Afternoon"), value: "afternoon"),
      DropdownMenuItem(child: Text("Evening"), value: "evening"),
    ];
    return menuItems;
  }

  // String? _setDate;

  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = new TextEditingController();

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
        date = _dateController.text;
        // print("value of: " + _dateController.text);
        date = _dateController.text;
      });
    return _dateController.text;
  }

  Future<List<UserValue>> _getSlots(String date, String slot) async {
    Dio dio = new Dio();

    var value = await dio.post(
      'https://nitc-tele-health-app.herokuapp.com/searchslot',
      data: {
        "date": date,
        "slot": slot,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    // final value = await http.post(
    //   Uri.parse('https://nitc-tele-health-app.herokuapp.com/searchslot'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{'date': date, 'slot': slot}),
    // );

    if (value.statusCode == 200) {
      //List<LoadSlot> slot_book = [];
      List<UserValue> sloting = [];
      print(date);
      print(slot);
      print("date value: " + _dateController.text);

      List<dynamic> str = value.data['user'];
      // print(str[1]['doc_name']);

      for (var u in str) {
        UserValue usr = new UserValue(
            u['date'],
            u['slot'],
            u['start_time'],
            u['end_time'],
            u['doc_name'],
            u['doc_email'],
            u['doc_spec_in'],
            u['descreption'],
            u['app_booked'],
            u['user_name'],
            u['user_email']);

        sloting.add(usr);
      }

      print(sloting.length);

      return sloting;
    } else {
      throw Exception('Failed to load album');
    }
  }

  void _printdate() {
    print("The Date is: ${date}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Book An Appointment",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: HexColor("#283B71"),
        ),
        backgroundColor: HexColor("#283B71"),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _appointmentUI(context),
          ),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _appointmentUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/schedule.jpg",
                    width: 245,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 85,
              bottom: 30,
            ),
            child: Text(
              "Book Appointment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.red)),
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _dateController,
                    onChanged: (value) {
                      _printdate();
                      date = _dateController.text;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Date",
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.date_range,
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: DropdownButtonFormField(
              items: dropdownItems,
              value: slot,
              onChanged: (String? newValue) {
                setState(() {
                  slot = newValue!;
                });
              },
              dropdownColor: HexColor('#283B71'),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Select Slot",
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                //fillColor: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
                child: Text("SEARCH"),
                onPressed: () {
                  if (globalFormKey.currentState!.validate()) {
                    //Navigator.pushNamed(context, MyRoutings.homeRoute);
                    setState(() {
                      print(date);
                      print(slot);
                      _futureData = _getSlots(date!, slot!);
                    });
                  } else {
                    "problem signin- check";
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: HexColor("#283B71"),
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: FutureBuilder(
                future: _futureData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text("Loading...."),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index].doc_name),
                        );
                      },
                    );
                  }
                },
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                    ]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: description),
              onChanged: (value) {
                description = value;
              },
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Give Problem Description (Optional)",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
                child: Text("REGISTER"),
                onPressed: () {
                  if (globalFormKey.currentState!.validate()) {
                    //Navigator.pushNamed(context, MyRoutings.homeRoute);

                    // AddNewUser()
                    //     .AddUser(name, type, branch, rollno, email, password)
                    //     .then((val) {
                    //   if (val.data['success']) {
                    //     //token = val.data['token'];
                    //     Fluttertoast.showToast(
                    //       msg: 'New user Added Successfully',
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.BOTTOM,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Colors.green,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0,
                    //     );
                    //   }
                    // });
                  } else {
                    "problem signin- check";
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: HexColor("#283B71"),
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ))),
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}

class LoadSlot {
  final List<UserValue> allvalue;

  LoadSlot(this.allvalue);
}

class UserValue {
  final String date;
  final String slot;
  final String start_time;
  final String end_time;
  final String doc_name;
  final String doc_email;
  final String doc_spec_in;
  final bool app_booked;
  final String descreption;
  final String user_name;
  final String user_email;

  UserValue(
    this.date,
    this.slot,
    this.start_time,
    this.end_time,
    this.doc_name,
    this.doc_email,
    this.doc_spec_in,
    this.descreption,
    this.app_booked,
    this.user_name,
    this.user_email,
  );
}
