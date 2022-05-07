import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nitc_telehealth_application/FrontEnd/services/createSchedule.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class PrintMedicalCertificate extends StatefulWidget {
  const PrintMedicalCertificate({Key? key}) : super(key: key);

  @override
  State<PrintMedicalCertificate> createState() =>
      _PrintMedicalCertificateState();
}

class _PrintMedicalCertificateState extends State<PrintMedicalCertificate> {
  bool isAPICallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? doc_email;
  String? user_email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Print Medical Certificate",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: HexColor('#283B71'),
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _MedicalCertificateUI(context),
          ),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _MedicalCertificateUI(context) {
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
                    "assets/images/print.jpg",
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(
          //       top: 20,
          //       bottom: 30,
          //     ),
          //     child: Text(
          //       "Print Medical Certificate",
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 25,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: doc_email),
              onChanged: (value) {
                doc_email = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Field cannot be empty';
                } else if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return null;
                } else {
                  return 'Enter Valid Email';
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Doctor Email",
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: user_email),
              onChanged: (value) {
                user_email = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Field cannot be empty';
                } else if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return null;
                } else {
                  return 'Enter Valid Email';
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Doctor Email",
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
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              child: Text("SEARCH"),
              onPressed: () {
                if (globalFormKey.currentState!.validate()) {
                  // RemoveUser().getData(email).then((val) {
                  //   if (val.data['success']) {
                  //     name = val.data['name'];
                  //     type = val.data['type'];
                  //     branch = val.data['branch'];
                  //     rollno = val.data['rollno'];
                  //   }
                  //   print(val.data);
                  //   setState(() {});
                  // });
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: HexColor("#283B71"),
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(80.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 20,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              //color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    // Text('Name        = $name'),
                    // Text('User Type  = $type'),
                    // Text('Branch     = $branch'),
                    // Text('Roll No      = $rollno'),
                  ],
                ),
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
              top: 30,
              bottom: 50,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 10,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 14,
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            //_setStartTime = _startTimeController.text;
                          },
                          // enabled: false,
                          // keyboardType: TextInputType.text,
                          // controller: _startTimeController,
                          decoration: InputDecoration(
                              hintText: "PRINT",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 14,
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            //_setStartTime = _startTimeController.text;
                          },
                          // enabled: false,
                          // keyboardType: TextInputType.text,
                          // controller: _startTimeController,
                          decoration: InputDecoration(
                              hintText: "CANCEL",
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
