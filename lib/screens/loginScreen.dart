import 'package:Yahrzeit/service/graphQLConf.dart';
import 'package:Yahrzeit/service/queryMutation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'createAccountScreen.dart';
import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();

  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = new RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String _correo;
  String _contrasena;
  String mensaje = '';

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
      body: _logueado ? HomeScreen(mensaje: mensaje) : loginForm(),
//      body: loginForm(),
    );
  }
  //Uso esto si necesito llamar a create User en un alert
  //  void _createUser(context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       AlertDialogWindow alertDialogWindow =
  //           new AlertDialogWindow();
  //       return alertDialogWindow;
  //     },
  //   ).whenComplete(() {
  //     Navigator.of(context).pushReplacement(LoginScreen.route());
  //   });
  // }

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

  Widget loginForm() {
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
                SizedBox(height: 20.0),
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
                  onSaved: (text) => _correo = text,
                ),
                SizedBox(height: 18.0),
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
                    hintText: 'Password',
                    counterText: '',
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    hintStyle: new TextStyle(color: Colors.grey[400]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                SizedBox(height: 50.0),
                ButtonTheme(
                    minWidth: 300,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "Sign In",
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
                                  _correo,
                                  _contrasena,
                                ),
                              ),
                            );
                            if (!result.hasErrors) {
                              txtMail.clear();
                              txtPassword.clear();
                              Navigator.of(context)
                                  .pushReplacement(HomeScreen.route('asd'));
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
                SizedBox(height: 50.0),
                FlatButton(
                  child: Text("Create account",
                      style: new TextStyle(fontSize: 16)),
                  onPressed: () async {
                    Navigator.of(context)
                        .pushReplacement(CreateUserAccountScreen.route());
                  },
                  textColor: Colors.white,
                )
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
