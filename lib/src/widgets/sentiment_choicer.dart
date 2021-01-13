import 'package:flutter/material.dart';

class SentimentChoicer extends StatefulWidget {
  SentimentChoicer(
      {Key key, @required this.moodChanger, this.currSentiment = 2})
      : super(key: key);
  final Function moodChanger;
  final int currSentiment;

  @override
  _SentimentChoicerState createState() => _SentimentChoicerState();
}

class _SentimentChoicerState extends State<SentimentChoicer> {
  @override
  Widget build(BuildContext context) {
    var currSentiment = widget.currSentiment;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.sentiment_very_dissatisfied),
            onPressed: () => setState(() {
              widget.moodChanger(0);
              currSentiment = 0;
            }),
            iconSize: currSentiment == 0 ? 40.0 : 30.0,
            color: Colors.red,
            splashRadius: 20.0,
            splashColor: Colors.red[200],
            focusColor: Colors.red[200],
          ),
          IconButton(
            icon: Icon(Icons.sentiment_dissatisfied),
            onPressed: () => setState(() {
              widget.moodChanger(1);
              currSentiment = 1;
            }),
            iconSize: currSentiment == 1 ? 40.0 : 30.0,
            color: Colors.orange,
            splashRadius: 20.0,
            splashColor: Colors.orange[200],
            focusColor: Colors.orange[200],
          ),
          IconButton(
            icon: Icon(Icons.sentiment_neutral),
            onPressed: () => setState(() {
              widget.moodChanger(2);
              currSentiment = 2;
            }),
            iconSize: currSentiment == 2 ? 40.0 : 30.0,
            color: Colors.yellow,
            splashRadius: 20.0,
            splashColor: Colors.yellow[200],
            focusColor: Colors.yellow[200],
          ),
          IconButton(
            icon: Icon(Icons.sentiment_satisfied),
            onPressed: () => setState(() {
              widget.moodChanger(3);
              currSentiment = 3;
            }),
            iconSize: currSentiment == 3 ? 40.0 : 30.0,
            color: Colors.lightGreen,
            splashRadius: 20.0,
            splashColor: Colors.lightGreen[200],
            focusColor: Colors.lightGreen[200],
          ),
          IconButton(
            icon: Icon(Icons.sentiment_very_satisfied),
            onPressed: () => setState(() {
              widget.moodChanger(4);
              currSentiment = 4;
            }),
            iconSize: currSentiment == 4 ? 40.0 : 30.0,
            color: Colors.green,
            splashRadius: 20.0,
            splashColor: Colors.green[200],
            focusColor: Colors.green[200],
          ),
        ],
      ),
    );
  }
}
