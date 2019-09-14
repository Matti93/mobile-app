import 'package:Yahrzeit/screens/loginScreen.dart';
import 'package:Yahrzeit/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import "../service/graphqlConf.dart";
import "../service/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";

class CreateUserAccountScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CreateUserAccountScreen(),
    );
  }

  @override
  _CreateUserAccountScreenState createState() =>
      _CreateUserAccountScreenState();
}

class _CreateUserAccountScreenState extends State<CreateUserAccountScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();

  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = new RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String _correo;
  String _contrasena;
  bool _logueado = false;
  String mensaje = '';
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

  // user defined function
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
                  Navigator.of(context).pushReplacement(LoginScreen.route());
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

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Color.fromRGBO(119, 173, 222, 10),
          body: _logueado ? HomeScreen() : createUserForm(),
          appBar: new AppBar(
            backgroundColor: Color.fromRGBO(119, 173, 222, 10),
            elevation: 0.0,
            title: new Text("Create Account"),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pushReplacement(LoginScreen.route()),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  Widget createUserForm() {
    TextEditingController txtMail = TextEditingController();
    TextEditingController txtPassword = TextEditingController();
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    QueryMutation addMutation = QueryMutation();
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
                SizedBox(height: 30.0),
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
                    hintText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    counterText: '',
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                  onSaved: (text) => _correo = text,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required.";
                    } else if (text.length <= 3) {
                      return "Your password must be at least 3 characters";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "The password format is not correct";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                    hintText: 'Password',
                    counterText: '',
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                SizedBox(height: 50.0),
                ButtonTheme(
                    minWidth: 300,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text("Create Account",
                            style: new TextStyle(
                                fontSize: 20, color: Colors.black54)),
                        onPressed: () async {
                          _key.currentState.save();
                          if (_key.currentState.validate()) {
                            GraphQLClient _client =
                                graphQLConfiguration.clientToQuery();
                            QueryResult result = await _client.mutate(
                              MutationOptions(
                                document: addMutation.addUser(
                                  _correo,
                                  _contrasena,
                                ),
                              ),
                            );
                            print(result);
                            if (!result.hasErrors) {
                              txtMail.clear();
                              txtPassword.clear();
                              _showDialog(
                                  'Your user is created!',
                                  'The user with email \n $_correo was created!',
                                  'LogIn',
                                  true);
                            } else {
                              print(result);
                              _showDialog('An error ocurred',
                                  result.errors[0].message, 'Close', false);
                              txtMail.clear();
                              txtPassword.clear();
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
      child: Container(
        child: Image.asset(
          'assets/images/imageScreen.png',
          fit: BoxFit.cover,
          width: 300,
          height: 200,
        ),
      ),
    );
  }
}
