// to do
//
// option to change theme color: deepOrange, blue, red, yellow, green, white
//   see https://docs.flutter.io/flutter/material/Colors-class.html
//       https://stackoverflow.com/questions/49164592/flutter-how-to-change-the-materialapp-theme-at-runtime
// vertical (or maybe horizontal) graph of oil/fuel mix, different coloured
//   bars or something.

// https://pub.dartlang.org/packages/numberpicker
// use showAboutDialog widget

import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_picker/flutter_picker.dart';

void main() => runApp(new PremixCalculator());

class PremixCalculator extends StatelessWidget {
  // This widget is the root of your application.
  Color themeColor = Colors.white;

  Future<Color> getThemeColor() async {
    Color _c = Colors.green;
    String col = 'red';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    col = prefs.getString('theme') ?? 'black';

    print(col);
    switch (col) {
      case 'red':
        {
          _c = Colors.red;
        }
        break;
      case 'blue':
        {
          _c = Colors.blue;
        }
        break;
      case 'orange':
        {
          _c = Colors.orange;
        }
        break;
      default:
        {
          _c = Colors.white;
        }
        break;
    }
    return _c;
  }

  void updateThemeColor(Color col) {
    //  setState(() {
    this.themeColor = col;
    //  });
  }

  @override
  void initState() {
    getThemeColor().then(updateThemeColor);
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getThemeColor() {
      return (Colors.blue);
    }

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Premix Calculator',
      theme: new ThemeData(
        // primarySwatch: Colors.red,
        // primaryColor: themeColor,
        primarySwatch: getThemeColor(),
      ),
      home: new MyHomePage(title: 'Premix Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController fuelController = TextEditingController();
  TextEditingController oilController = TextEditingController();

  // fixme: ?? had to initialise due to null
  double fuel = 0;
  double oil = 0;
  int _fuelRatio = 0;
  int _oilRatio = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedRatios();
  }

  //Loading ratio values on start
  _loadSavedRatios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fuel = prefs.getDouble('fuel') ?? 0.0;
      oil = prefs.getDouble('oil') ?? 0.0;
      _fuelRatio = prefs.getInt('fuelRatio') ?? 50;
      _oilRatio = prefs.getInt('oilRatio') ?? 1;
      fuelController.text = fuel.toString();
      oilController.text = oil.toString();
      // also read last changed value (fuel or oil)
    });
  }

  //Loading ratio values on start
  _saveRatios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fuel', fuel);
    prefs.setDouble('oil', oil);
    prefs.setInt('fuelRatio', _fuelRatio);
    prefs.setInt('oilRatio', _oilRatio);
    // save last changed value fuel or oil
  }

//  double _currentDoubleValue = 3.0;
//  NumberPicker integerNumberPicker;
//  NumberPicker decimalNumberPicker;
//  double _currentPrice = 1.0;

//  _handleValueChanged(num value) {
//    if (value != null) {
//      if (value is int) {
//        setState(() => _currentIntValue = value);
//      } else {
//        setState(() => _currentDoubleValue = value);
//      }//   }
//  }

  _handleFuelRatioChangedExternally(num value) {
    if (value != null) {
      if (value is int) {
        setState(() => _fuelRatio = value);
//        integerNumberPicker.animateInt(value);
      }
    }
  }

  _handleOilRatioChangedExternally(num value) {
    if (value != null) {
      if (value is int) {
        setState(() => _oilRatio = value);
//        integerNumberPicker.animateInt(value);
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    fuelController.dispose();
    oilController.dispose();
    super.dispose();
    ;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

//    integerNumberPicker = new NumberPicker.integer(
//      initialValue: _currentIntValue,
//      minValue: 2,
//      maxValue: 100,
//      step: 1,
//      onChanged: _handleValueChanged,
//    );

    final newTextTheme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.green,
          displayColor: Colors.pink,
        );

    //int ratioPrimary = 50;
    //int ratioSecondary = 1;
    //double fuel = 10.0;
    //double oil = 0.0;

    String validateFuel(String value) {
      // return "";

      if (value == "") {
        return "";
      }

      if (value == null) {
        return "";
      }
      final result = num.tryParse(value);
      if (result == null) {
        return '"$value" is not a valid number';
      }
      fuel = double.parse(value);
      return "";

      if (value.length > 0) {
        return "";
      } else {
        return "Enter amount of litres";
      }
      var numValue = int.tryParse(value);

      if (numValue == null) {
        return ("Litres must be > 0 and < 999");
      }
      if (numValue > 0 && numValue < 999) {
        return "";
      } else {
        return ("Litres must be > 0 and < 999");
      }

      String pattern = r'(^[0-9]*$)';
      RegExp regExp = new RegExp(pattern);
      if (value.length == 0) {
        return "Age is required.";
      } else if (!regExp.hasMatch(value)) {
        return "Age cannot contain characters other than numbers.";
      }
    }

    String validateOil(String value) {
      //return "";

      if (value == "") {
        return "";
      }

      if (value == null) {
        return "";
      }
      final result = num.tryParse(value);
      if (result == null) {
        return '"$value" is not a valid number';
      }
      oil = double.parse(value);
      return "";

      if (value.length > 0) {
        return "";
      } else {
        return "Enter amount of litres";
      }
      var numValue = int.tryParse(value);

      if (numValue == null) {
        return ("Litres must be ? 0 and < 999");
      }
      if (numValue > 0 && numValue < 999) {
        return "";
      } else {
        return ("Litres must be > 0 and < 999");
      }

      String pattern = r'(^[0-9]*$)';
      RegExp regExp = new RegExp(pattern);
      if (value.length == 0) {
        return "Age is required.";
      } else if (!regExp.hasMatch(value)) {
        return "Age cannot contain characters other than numbers.";
      }
    }

// commented out to satisfy null issues
//    ValueChanged fuelChanged(String value) {
//      //print("fuelChanged = ${validateOil(value)Controller.text}");
//      // oil = value;
//      //return ""; //added for null compatipility
//    }

//    ValueChanged oilChanged(String value) {
//      //fuel = value;
//    }

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'oil ratio',
            ),

//            TextField(
//              controller: fuelController,
//              decoration: new InputDecoration(labelText: "litres of fuel"),
//              keyboardType: TextInputType.number,
//              onSubmitted: (text) {
//                oil = double.parse(text)*(ratioPrimary/ratioSecondary);
//                oilController.text = oil.toString();
//
//              },
//              textAlign: TextAlign.left,
//              maxLines: 1,
//              maxLengthEnforced: true,
//              maxLength: 6,
//              autofocus: false,
//            ),
// b nv
//            TextField(
//              controller: oilController,
//              decoration: new InputDecoration(labelText: "mm of oil"),
//              keyboardType: TextInputType.number,
//              onSubmitted: (text) {
//                fuel = double.parse(text)/(ratioPrimary/ratioSecondary);
//                fuelController.text = fuel.toString();
//              },
//              textAlign: TextAlign.left,
//              maxLines: 1,
//              maxLengthEnforced: true,
//              maxLength: 6,
//              autofocus: false,
//            ),

//          //   integerNumberPicker,
//            new RaisedButton(
//              onPressed: () => _showRatioPrimaryDialog(),
//              child: new Text("Fuel/Oil Ratio: $_currentRatioPrimary"),
//            ),

//            // integerNumberPicker,
//            new RaisedButton(
//              onPressed: () => _showRatioSecondaryDialog(),
//              child: new Text(": $_currentRatioSecondary"),
//            ),

            new ElevatedButton(
              onPressed: () => FORatio(),
              child: new Text("$_fuelRatio : $_oilRatio"),
            ),

            TextFormField(
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              autovalidateMode: AutovalidateMode.always,
              controller: fuelController,
              decoration: new InputDecoration(labelText: "litres of fuel"),
              keyboardType: TextInputType.number,
              //initialValue: "5.6",
              onFieldSubmitted: (text) {
                oil = (double.parse(text) / (_fuelRatio / _oilRatio)) * 1000;
                oilController.text = oil.toString();
                _saveRatios();
              },
              textAlign: TextAlign.left,
              // fixme: validator: validateFuel,
              maxLines: 1,
              maxLength: 6,
              autofocus: false,
            ),

            TextFormField(
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              autovalidateMode: AutovalidateMode.always,
              controller: oilController,
              decoration: new InputDecoration(labelText: "mm of oil"),
              keyboardType: TextInputType.number,
              //initialValue: oil.toString(),
              onFieldSubmitted: (text) {
                fuel = (double.parse(text) * (_fuelRatio / _oilRatio)) / 1000;
                fuelController.text = fuel.toString();
                _saveRatios();
              },
              textAlign: TextAlign.left,
              // fixme: validator: validateOil,
              maxLines: 1,
              maxLength: 6,
              autofocus: false,
            ),
          ],
        ),
      ),
    );
  }

//  Future _showRatioPrimaryDialog() async {
//    await showDialog<int>(
//      context: context,
//      builder: (BuildContext context) {
//        return new NumberPickerDialog.integer(
//          minValue: 1,
//          maxValue: 100,
//          step: 1,
//          title: Text('Fuel Ratio'),
//          initialIntegerValue: _currentRatioPrimary,
//        );
//      },
//    ).then(_handleRatioPrimaryChangedExternally);
//  }

//  Future _showRatioSecondaryDialog() async {
//    await showDialog<int>(
//      context: context,
//      builder: (BuildContext context) {
//        return new NumberPickerDialog.integer(
//          minValue: 1,
//          maxValue: 100,
//          step: 1,
//          title: Text('Oil Ratio'),
//          initialIntegerValue: _currentRatioSecondary,
//        );
//      },
//    ).then(_handleRatioSecondaryChangedExternally);
//  }

//  Future _FORatio() async {
//    await showDialog<void>(
//        context: context,
//        builder: (BuildContext context) {
//        return Picker(
//          adapter: NumberPickerAdapter(data: [
//            NumberPickerColumn(begin: 0, end: 999),
//            NumberPickerColumn(begin: 100, end: 200),
//          ]),
//          delimiter: [
//            PickerDelimiter(child: Container(
//              width: 30.0,
//              alignment: Alignment.center,
//              child: Icon(Icons.more_vert),
//            ))
//          ],
//          hideHeader: true,
//          title: new Text("Please Select"),
//          onConfirm: (Picker picker, List value) {
//            print(value.toString());
//            print(picker.getSelectedValues());
  //         }
//      ).showDialog(context);
//    },
//   ).then(_handleRatioSecondaryChangedExternally);
//  }

  FORatio() {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 100, initValue: _fuelRatio),
          NumberPickerColumn(begin: 1, end: 10, initValue: _oilRatio),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          _handleFuelRatioChangedExternally(value[0] + 1);
          _handleOilRatioChangedExternally(value[1] + 1);
          _saveRatios();
        }).showDialog(context);
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => new SettingsScreenWindow();
}

// class SettingsScreen extends StatelessWidget {
class SettingsScreenWindow extends State<SettingsScreen> {
  int? _measurement_selected = 0;

  void onChangedMeasurement(int? value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _measurement_selected = value;
    });
    prefs.setInt('measurement', value!);
  }

  String? _theme_selected = 'white';

  void onChangedTheme(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme_selected = value;
    });
    prefs.setString('theme', value!);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new ListView(
        padding: new EdgeInsets.all(5.0),
        children: <Widget>[
          const Text('Measurement Units'),
          RadioListTile(
            value: 1,
            title: new Text('Metric'),
            groupValue: _measurement_selected,
            onChanged: (int? value) {
              onChangedMeasurement(value);
            },
            activeColor: Colors.black,
            subtitle: new Text('Litres/Millilitres.'),
          ),
          RadioListTile(
            value: 2,
            title: new Text('US'),
            groupValue: _measurement_selected,
            onChanged: (int? value) {
              onChangedMeasurement(value);
            },
            activeColor: Colors.black,
            subtitle: new Text('Gallons/Ozs - 8 US liquid pints per gallon.'),
          ),
          RadioListTile(
            value: 3,
            title: new Text('Imperial'),
            groupValue: _measurement_selected,
            onChanged: (int? value) {
              onChangedMeasurement(value);
            },
            activeColor: Colors.black,
            subtitle: new Text('Gallons/Ozs - 8 imperial pints per gallon.'),
          ),
          const Text('Theme'),
          RadioListTile(
            value: 'red',
            title: new Text('Red'),
            groupValue: _theme_selected,
            onChanged: (String? value) {
              onChangedTheme(value);
            },
            activeColor: Colors.red,
            subtitle: new Text('Honda.'),
          ),
          RadioListTile(
            value: 'white',
            title: new Text('White'),
            groupValue: _theme_selected,
            onChanged: (String? value) {
              onChangedTheme(value);
            },
            activeColor: Colors.white,
            subtitle: new Text('Husqvana.'),
          ),
          RadioListTile(
            value: 'yellow',
            title: new Text('Yellow'),
            groupValue: _theme_selected,
            onChanged: (String? value) {
              onChangedTheme(value);
            },
            activeColor: Colors.yellow,
            subtitle: new Text('Suzuki.'),
          ),
          RadioListTile(
            value: 'orange',
            title: new Text('Orange'),
            groupValue: _theme_selected,
            onChanged: (String? value) {
              onChangedTheme(value);
            },
            activeColor: Colors.orange,
            subtitle: new Text('KTM.'),
          ),
          RadioListTile(
            value: 'green',
            title: new Text('Green'),
            groupValue: _theme_selected,
            onChanged: (String? value) {
              onChangedTheme(value);
            },
            activeColor: Colors.green,
            subtitle: new Text('Kawasaki.'),
          ),
          RadioListTile(
            value: 'blue',
            title: new Text('Blue'),
            groupValue: _theme_selected,
            onChanged: (String? value) {
              onChangedTheme(value);
            },
            activeColor: Colors.blue,
            subtitle: new Text('Yamaha.'),
          ),
        ],
      ),
    );
  }
}

//               makeMeasurementRadios(),
