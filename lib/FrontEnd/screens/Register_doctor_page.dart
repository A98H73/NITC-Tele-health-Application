import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nitc_telehealth_application/FrontEnd/services/adduser.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RegisterDoctor extends StatefulWidget {
  const RegisterDoctor({Key? key}) : super(key: key);

  @override
  State<RegisterDoctor> createState() => _RegisterDoctorState();
}

class _RegisterDoctorState extends State<RegisterDoctor> {
  bool isAPICallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? name;
  String? type;
  String? college_id;
  String? spec_in;
  String? email;
  String? password;

  List<DropdownMenuItem<String>> get dropdownItemsSpec {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Mental Health Care"), value: "Mental Health"),
      DropdownMenuItem(
          child: Text("Dental Health Care"), value: "Dental Health"),
      DropdownMenuItem(
          child: Text("Labooratory and diagnostic care"),
          value: "Diagnostic Care"),
      DropdownMenuItem(
          child: Text("Prevensive Care"), value: "Prevensive Care"),
      DropdownMenuItem(
          child: Text("Physical and occupational therapy"),
          value: "Physical therapy"),
      DropdownMenuItem(
          child: Text("Nutritional Care"), value: "Nutritional Care"),
      DropdownMenuItem(child: Text("Mild Problems"), value: "Mild Problems"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/NITC_logo.jpg",
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              bottom: 30,
            ),
            child: Text(
              "Register Doctor",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: name),
              onChanged: (value) {
                name = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Field cannot be empty';
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Name",
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: type),
              onChanged: (value) {
                type = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Field cannot be empty';
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Type",
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: college_id),
              onChanged: (value) {
                college_id = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Field cannot be empty';
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "College_ID",
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
              top: 10,
            ),
            child: DropdownButtonFormField(
              items: dropdownItemsSpec,
              value: spec_in,
              onChanged: (String? newValue) {
                setState(() {
                  spec_in = newValue!;
                });
              },
              dropdownColor: HexColor('#283B71'),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Specilist In",
                labelStyle: TextStyle(color: Colors.white),
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: email),
              onChanged: (value) {
                email = value;
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
                labelText: "Email",
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: TextFormField(
              controller: TextEditingController(text: password),
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value == null) {
                  return "Password can't be empty";
                } else {
                  return null;
                }
              },
              obscureText: hidePassword,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
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

                    AddNewUser()
                        .AddDoc(
                            name, type, college_id, spec_in, email, password)
                        .then((val) {
                      if (val.data['success']) {
                        //token = val.data['token'];
                        Fluttertoast.showToast(
                          msg: 'New Doctor Added Successfully',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Something Went Wrong',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
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
          SizedBox(
            height: 10,
          ),
          // Center(
          //   child: Text(
          //     "OR",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 80,
          //   ),
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: RichText(
          //       text: TextSpan(
          //         style: const TextStyle(
          //           color: Colors.grey,
          //           fontSize: 14,
          //         ),
          //         children: <TextSpan>[
          //           TextSpan(
          //             text: "Login to the application?",
          //           ),
          //           TextSpan(
          //             text: " LOGIN",
          //             style: TextStyle(
          //               color: Colors.white,
          //               decoration: TextDecoration.underline,
          //             ),
          //             recognizer: TapGestureRecognizer()
          //               ..onTap = () {
          //                 Navigator.pushNamed(context, "/");
          //               },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
