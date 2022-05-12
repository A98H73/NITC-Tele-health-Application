import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nitc_telehealth_application/FrontEnd/services/addMedLeave.dart';
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
  String? _id;
  String? doc_name;
  String? doc_email;
  String? doc_spec_in;
  String? user_name;
  String? user_email;
  String? user_rollno;
  String? user_branch;
  bool? doc_isaccepted;
  bool admin_isaccepted = false;
  bool _selectSlotValue = false;

  Future<List<UserValue>>? _futureData;

  Future<List<UserValue>> _getSlots() async {
    Dio dio = new Dio();

    var value = await dio.post(
      'https://nitc-tele-health-app.herokuapp.com/searchmedleave',
      data: {"doc_email": doc_email, "user_email": user_email},
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
      print("Doctor mail: $doc_email");
      print("User Email: $user_email");
      List<dynamic> str = value.data['user'];
      // print(str[1]['doc_name']);

      for (var u in str) {
        UserValue usr = new UserValue(
            u['_id'],
            u['doc_name'],
            u['doc_email'],
            u['doc_spec_in'],
            u['user_name'],
            u['user_email'],
            u['user_rollno'],
            u['user_branch'],
            u['doc_isaccepted'],
            u['admin_isaccepted']);

        sloting.add(usr);
      }

      print(sloting.length);

      return sloting;
    } else {
      throw Exception('Failed to load album');
    }
  }

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
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Patient Email",
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
                setState(() {
                  _futureData = _getSlots();
                });
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
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
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
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Center(
                                child: Text(
                                  "Doctor Name: ${snapshot.data[index].doc_name}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                children: <Widget>[
                                  Text(
                                    "Doctor Email: ${snapshot.data[index].doc_email}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Doctor Specilist In: ${snapshot.data[index].doc_spec_in}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "User Name: ${snapshot.data[index].user_name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "User Email: ${snapshot.data[index].user_email}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "User Branch: ${snapshot.data[index].user_branch}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "User RollNo: ${snapshot.data[index].user_rollno}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Doctor Accepted: ${snapshot.data[index].doc_isaccepted}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Admin Accepted: ${snapshot.data[index].admin_isaccepted}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              //tileColor: bgcolor,
                              onTap: () {
                                _id = snapshot.data[index]._id;
                                doc_email = snapshot.data[index].doc_email;
                                doc_name = snapshot.data[index].doc_name;
                                doc_spec_in = snapshot.data[index].doc_spec_in;
                                user_name = snapshot.data[index].user_name;
                                user_email = snapshot.data[index].user_email;
                                user_branch = snapshot.data[index].user_branch;
                                user_rollno = snapshot.data[index].user_rollno;
                                doc_isaccepted =
                                    snapshot.data[index].doc_isaccepted;
                                print(
                                    "user Name Is: ${snapshot.data[index].user_name}");

                                setState(() {
                                  _selectSlotValue = true;
                                });
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                                "Appointments are not being created for this day yet...."),
                          ),
                        ),
                      );
                    }
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
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(20),
                //   bottomRight: Radius.circular(20),
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
              ),
            ),
          ),
          if (_selectSlotValue)
            Center(
                child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Text(
                "Selected id: $_id",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),

          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 30,
              right: 30,
            ),
            child: Row(
              children: [
                Text(
                  "Accept Request",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  width: 110,
                ),
                Transform.scale(
                  scale: 2.0,
                  child: Checkbox(
                      value: admin_isaccepted,
                      shape: CircleBorder(),
                      tristate: false,
                      splashRadius: 30,
                      //activeColor: Colors.white,
                      onChanged: (bool? value) {
                        setState(() {
                          admin_isaccepted = value!;
                        });
                      }),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                      onTap: () {
                        if (admin_isaccepted) {
                          MedicalLeaveReq()
                              .updateMedRequest(
                                  _id,
                                  doc_name,
                                  doc_email,
                                  doc_spec_in,
                                  user_name,
                                  user_email,
                                  user_rollno,
                                  user_branch,
                                  doc_isaccepted,
                                  admin_isaccepted)
                              .then((val) {
                            print(val.data);
                            if (val.data['success']) {
                              Fluttertoast.showToast(
                                msg: val.data['msg'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PrintMedicalCertificate()));
                            } else {
                              Fluttertoast.showToast(
                                msg: val.data['msg'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: "Enter All The Fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "ACCEPT REQUEST",
                          style: TextStyle(color: Colors.white),
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
                      onTap: () {
                        print(_id);
                        print("hello");
                        print(doc_email);
                        print(user_email);
                        print(admin_isaccepted);
                        if (_id!.isNotEmpty) {
                          MedicalLeaveReq().removeMedRequest(_id).then((val) {
                            print(val.data);
                            if (val.data['deletecount'] >= 1) {
                              Fluttertoast.showToast(
                                msg: "Request Data Removed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              setState(() {});
                            }
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "REMOVE REQUEST",
                          style: TextStyle(color: Colors.white),
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

class LoadSlot {
  final List<UserValue> allvalue;

  LoadSlot(this.allvalue);
}

class UserValue {
  final String? _id;
  final String? doc_name;
  final String? doc_email;
  final String? doc_spec_in;
  final String? user_name;
  final String? user_email;
  final String? user_rollno;
  final String? user_branch;
  final bool doc_isaccepted;
  final bool admin_isaccepted;

  UserValue(
      this._id,
      this.doc_email,
      this.doc_name,
      this.doc_spec_in,
      this.user_email,
      this.user_name,
      this.user_branch,
      this.user_rollno,
      this.doc_isaccepted,
      this.admin_isaccepted);
}
