import 'dart:async';

import 'package:Yahrzeit/service/graphQLConf.dart';
import 'package:Yahrzeit/service/queryMutation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'homeScreen.dart';

class CreateYahrzeitAccountScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CreateYahrzeitAccountScreen(),
    );
  }

  @override
  _CreateYahrzeitAccountScreenState createState() =>
      _CreateYahrzeitAccountScreenState();
}

class _CreateYahrzeitAccountScreenState
    extends State<CreateYahrzeitAccountScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();

  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = new RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String txtMail;
  String _contrasena;
  String mensaje = '';
  String _value = '';
  String txtFirstName;
  String txtLastName;
  String txtBirthDate;
  String txtDeathDay;
  String txtTimeZone;
  String txtHebrewNme;
  String txtRelationShipType;
  TextEditingController _txtDeathDay = TextEditingController();
  TextEditingController _txtBirthDate = TextEditingController();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  bool _logueado = false;
  initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    //    Descomentar las siguientes lineas para generar un efecto de "respiracion"
//    animation.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
//        controller.reverse();
//      } else if (status == AnimationStatus.dismissed) {
//        controller.forward();
//      }
//    });

    controller.forward();
  }

  dispose() {
    // Es importante SIEMPRE realizar el dispose del controller.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(119, 173, 222, 10),
      body:
          _logueado ? HomeScreen() : SingleChildScrollView(child: loginForm()),
    );
  }

  void _showDialog(tittleText, contentText, buttonText, isCreated) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(tittleText),
          content: new Text(contentText),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(buttonText),
              onPressed: () {
                if (isCreated) {
                  Navigator.of(context)
                      .pushReplacement(CreateYahrzeitAccountScreen.route());
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future _selectDateForBirth() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1900),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2020));
    if (picked != null) setState(() => _txtBirthDate.text = DateFormat('yyyy-MM-dd').format(picked));
  }

  Future _selectDateForDeath() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1900),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2020));
    if (picked != null) setState(() => _txtDeathDay.text = DateFormat('yyyy-MM-dd').format(picked));
  }

  Widget loginForm() {
    QueryMutation addMutation = QueryMutation();
    TextEditingController _lastName = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedLogo(animation: animation),
          ],
        ),
        Container(
          width: 300.0, //size.width * .6,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                        }),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    hintText: 'First Name',
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    counterText: '',
                  ),
                  onSaved: (text) => txtFirstName = text,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _lastName,
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                        }),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    hintText: 'Last Name',
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    counterText: '',
                  ),
                  onSaved: (text) => txtLastName = text,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "The format for mail is not correct";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                        }),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    hintText: 'Email',
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    counterText: '',
                  ),
                  onSaved: (text) => txtMail = text,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _txtBirthDate,
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "The format for mail is not correct";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.datetime,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed:
                            _selectDateForBirth), // myIcon is a 48px-wide widget.
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    hintText: 'BirthDay',
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    counterText: '',
                  ),
                  onSaved: (text) => txtBirthDate = text,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _txtDeathDay,
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed:
                            _selectDateForDeath), // myIcon is a 48px-wide widget.
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    hintText: 'Death Day',
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    counterText: '',
                  ),
                  onSaved: (text) => txtDeathDay = text,
                ),
                SizedBox(height: 10.0),
                InputDecorator(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Select time Zone',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                  ),
                  isEmpty: _color == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      value: _color,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _color = newValue;
                        });
                      },
                      items: _colors.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                        }),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    hintText: 'Hebrew Name',
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    counterText: '',
                  ),
                  onSaved: (text) => txtFirstName = text,
                ),
                SizedBox(height: 10.0),
                InputDecorator(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Select Relation Type',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                  ),
                  isEmpty: _color == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      value: _color,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _color = newValue;
                        });
                      },
                      items: _colors.map((String value) {
                        return new DropdownMenuItem(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                ButtonTheme(
                    minWidth: 300,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "Create Yahrzeit",
                          style: new TextStyle(
                              fontSize: 20, color: Colors.black54),
                        ),
                        onPressed: () async {
                          _key.currentState.save();
                          if (_key.currentState.validate()) {
                            GraphQLClient _client =
                                graphQLConfiguration.clientToQuery();
                            QueryResult result = await _client.mutate(
                              MutationOptions(
                                document: addMutation.loginUser(
                                  txtMail,
                                  _contrasena,
                                ),
                              ),
                            );
                            if (!result.hasErrors) {
                              Navigator.of(context)
                                  .pushReplacement(HomeScreen.route());
                            } else {
                              print(result);
                              _showDialog('An error ocurred',
                                  result.errors[0].message, 'Close', false);
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  // Maneja los Tween estáticos debido a que estos no cambian.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Column(children: <Widget>[
        SizedBox(height: 40),
        Image.asset(
          'assets/images/imageScreen.png',
          fit: BoxFit.cover,
          width: 200,
          height: 100,
        ),
      ]),
    );
  }
}
