import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:progress_tracker/src/models/Report.dart';
import 'package:progress_tracker/src/widgets/drawer.dart';

class MainView extends StatefulWidget {
  static String routeName = 'home';

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Box _repbox;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    loadReports();
    super.initState();
  }

  Future<void> loadReports() async {
    _repbox = await Hive.openBox('reports');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Productivity Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (_repbox != null && _repbox.length > 0)
                ? () => deleteAllRecords(context: context)
                : null,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Report',
        child: Icon(Icons.add),
        onPressed: () async {
          await _reportCreator(context: context);
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
          );
          setState(() {});
        },
      ),
      body: SafeArea(
        child: _repbox != null
            ? CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 4
                          : 5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) {
                        if (_repbox.length == 0) {
                          return Center(
                            child: Text(
                                'Report your day so we have something to show here!'),
                          );
                        }
                        return _reportSquare(
                          context: context,
                          report: _repbox.getAt(i) as Report,
                          repKey: _repbox.keyAt(i),
                        );
                      },
                      childCount: _repbox.length,
                    ),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void deleteAllRecords({@required BuildContext context}) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Delete all records'),
        content: Text(
            'Are you sure you want to proceed to the deletion of ${_repbox.length} records?'),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlinedButton(
                child: Text('Delete'),
                autofocus: false,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                  primary: Colors.white,
                ),
                onPressed: () async {
                  await _repbox?.clear();
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _reportSquare(
      {@required BuildContext context,
      @required Report report,
      @required dynamic repKey}) {
    return Material(
      color: _reportColor(colorId: report.mood),
      child: InkWell(
        onTap: () =>
            _reportInfo(context: context, report: report, repKey: repKey),
        onLongPress: () {},
        child: Container(
          child: Center(
            child: Text(report.toString()),
          ),
        ),
      ),
    );
  }

  Color _reportColor({@required colorId}) {
    switch (colorId) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return Colors.lightBlue;
    }
  }

  void _reportInfo({
    @required BuildContext context,
    @required Report report,
    @required dynamic repKey,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        report.description,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _reportCreator(
                          context: context, tmprep: {repKey: report});
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: () => setState(() {
                      _repbox.delete(repKey);
                      Navigator.of(context).pop();
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reportCreator(
      {@required BuildContext context, Map<dynamic, Report> tmprep}) {
    TextEditingController _txtController = TextEditingController();
    Report _newrep;
    int _currKey;
    int _currMood;

    if (tmprep == null) {
      _currKey = null;
      _newrep = Report(mood: 2, description: '');
      _currMood = 2;
    } else {
      _currKey = tmprep.keys.first;
      _newrep = tmprep.values.first;
      _currMood = _newrep.mood;
      _txtController.text = _newrep.description;
    }

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SimpleDialog(
              children: [
                Text(
                  _newrep.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.sentiment_very_dissatisfied,
                          color: Colors.red),
                      onPressed: () => setState(() => _currMood = 0),
                      iconSize: _currMood == 0 ? 40.0 : 30.0,
                      splashRadius: 25.0,
                      splashColor: Colors.red[200],
                      focusColor: Colors.red[200],
                    ),
                    IconButton(
                      icon: Icon(Icons.sentiment_dissatisfied,
                          color: Colors.orange),
                      onPressed: () => setState(() => _currMood = 1),
                      iconSize: _currMood == 1 ? 40.0 : 30.0,
                      splashRadius: 25.0,
                      splashColor: Colors.orange[200],
                      focusColor: Colors.orange[200],
                    ),
                    IconButton(
                      icon: Icon(Icons.sentiment_neutral, color: Colors.yellow),
                      onPressed: () => setState(() => _currMood = 2),
                      iconSize: _currMood == 2 ? 40.0 : 30.0,
                      splashRadius: 25.0,
                      splashColor: Colors.yellow[200],
                      focusColor: Colors.yellow[200],
                    ),
                    IconButton(
                      icon: Icon(Icons.sentiment_satisfied,
                          color: Colors.lightGreen),
                      onPressed: () => setState(() => _currMood = 3),
                      iconSize: _currMood == 3 ? 40.0 : 30.0,
                      splashRadius: 25.0,
                      splashColor: Colors.lightGreen[200],
                      focusColor: Colors.lightGreen[200],
                    ),
                    IconButton(
                      icon: Icon(Icons.sentiment_very_satisfied,
                          color: Colors.green),
                      onPressed: () => setState(() {
                        _currMood = 4;
                      }),
                      iconSize: _currMood == 4 ? 40.0 : 30.0,
                      splashRadius: 25.0,
                      splashColor: Colors.green[200],
                      focusColor: Colors.green[200],
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextField(
                    controller: _txtController,
                    key: UniqueKey(),
                    maxLength: 350,
                    autofocus: false,
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        _newrep.description = _txtController.text;
                        _newrep.mood = _currMood;
                        if (_currKey != null) {
                          await _newrep.save();
                        } else {
                          await _repbox.add(_newrep);
                        }
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('home'));
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}
