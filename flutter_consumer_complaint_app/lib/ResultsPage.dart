import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  String prediction;
  String confidence;

  ResultsPage(this.prediction, this.confidence);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    // get the width and height of current screen the app is running on
    Size size = MediaQuery.of(context).size;

    // initialize two variables that will represent final width and height of the segmentation
    // and image preview on screen
    double finalW;
    double finalH;

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
          padding: const EdgeInsets.all(3),
          children: <Widget>[
            Container(
              height: 50,
              child: Center(
                child: Text(
                  "Prediction and Probability",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Center(
                child: Text(
                  "This complaint is of category ' " + widget.prediction + ' ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Center(
                  child: Text(
                'Confidence of this prediction is ' + widget.confidence,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              )),
            ),
          ],
        ));
  }
}
