import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ResultsPage.dart';
import 'globalVariables.dart';

void main() => runApp(
      MaterialApp(home: MyApp()),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _prediction;
  var _confidence;
  TextEditingController complaintController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mailController = new TextEditingController();
  bool _validateComplaint = false;
  bool _validateName = false;
  bool _validateMail = false;

  loadModel() async {}

  @override
  void initState() {
    super.initState();

    loadModel().then((val) {
      setState(() {});
    });
  }

  Future predict(String complaint) async {
    String url = GlobalData.host + "/complaintFromFlutter";
    print("url" + url);
    http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(<String, dynamic>{
              'complaint': complaintController.text,
            }))
        .then((response) {
      setState(() {
        this._prediction = json.decode(response.body)['prediction'];
        this._confidence = json.decode(response.body)['confidence'];
        print(this._confidence + " " + this._prediction);
      });
    }).catchError((error) {
      throw error;
    });
  }

// send complaint to predict class
  sendComplaint(String complaint) async {
    if (complaint == null) return;
    await predict(complaint).then((val) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  new ResultsPage(this._prediction, this._confidence)),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    List<Widget> stackChildren = [];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Flutter Consumer Complaint Classification",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent[100],
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Container(
              height: 50,
              child: Center(
                  child: Text(
                'Let us know what s troubling you',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              )),
            ),
            Container(
                height: 250,
                child: Image.asset(
                  'assets/images/complaint_image.png',
                )),
            Container(
                height: 70,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: new BorderSide(color: Colors.grey)),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.purple,
                    ),
                    filled: true,
                    fillColor: Colors.grey[290],
                    hintText: 'Name',
                    errorText: _validateComplaint ? '' : null,
                  ),
                )),
            Container(
                height: 70,
                child: TextField(
                  controller: mailController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: new BorderSide(color: Colors.grey)),
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.purple,
                    ),
                    filled: true,
                    fillColor: Colors.grey[290],
                    hintText: 'Email',
                    errorText: _validateComplaint ? '' : null,
                  ),
                )),
            Container(
                height: 100.0,
                child: TextField(
                  controller: complaintController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: new BorderSide(color: Colors.grey)),
                    prefixIcon: const Icon(
                      Icons.text_fields,
                      color: Colors.purple,
                    ),
                    filled: true,
                    fillColor: Colors.grey[290],
                    hintText: 'Please type your complaint ...',
                    errorText: _validateComplaint ? '' : null,
                  ),
                )),
            Container(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.deepPurpleAccent[100],
                child: Text("Send"),
                onPressed: () {
                  //reservation
                  setState(() {
                    if (complaintController.text.isEmpty ||
                        nameController.text.isEmpty ||
                        mailController.text.isEmpty) {
                      complaintController.text.isEmpty
                          ? _validateComplaint = true
                          : _validateComplaint = false;
                      mailController.text.isEmpty
                          ? _validateMail = true
                          : _validateMail = false;
                      nameController.text.isEmpty
                          ? _validateName = true
                          : _validateName = false;
                    } else {
                      sendComplaint(complaintController.text);
                      this.complaintController.clear();
                      this.nameController.clear();
                      this.mailController.clear();
                    }
                  });
                },
              ),
            ),
          ],
        ));
  }
}
