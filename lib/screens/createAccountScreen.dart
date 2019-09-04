import 'package:animaciones_basicas/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'alertDialogs.dart';
import 'homeScreen.dart';
import "package:flutter/material.dart";
import "../service/graphqlConf.dart";
import "../service/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "../models/user.dart";

class CreateUserAccountScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CreateUserAccountScreen(),
    );
  }

  @override
  _CreateUserAccountScreenState createState() => _CreateUserAccountScreenState();
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
      body: _logueado ? HomeScreen(mensaje: mensaje) : createUserForm(),
//      body: loginForm(),
    );
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
                    hintText: 'Enter your email',
                    labelText: 'Mail',
                    counterText: '',
                    icon:
                        Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correo = text,
                ),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "This field is required.";
                    } else if (text.length <= 5) {
                      return "Your password must be at least 5 characters";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "The password format is not correct";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    labelText: 'Password',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                 RaisedButton(
                  child: Text("Create Account"),
                  onPressed: () async {
                    if (txtMail.text.isNotEmpty &&
                        txtPassword.text.isNotEmpty) {
                      GraphQLClient _client = graphQLConfiguration.clientToQuery();
                      QueryResult result = await _client.mutate(
                        MutationOptions(
                          document: addMutation.addUser(
                            txtMail.text,
                            txtPassword.text,
                          ),
                        ),
                      );
                      if (!result.hasErrors) {
                        txtMail.clear();
                        txtPassword.clear();
                        Navigator.of(context).pop();
                      }
                      if(!result.data){
                        txtMail.clear();
                        txtPassword.clear();
                        Navigator.of(context).pushReplacement(LoginScreen.route());
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                 ),
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
  static final _sizeTween = Tween<double>(begin: 0.0, end: 150.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation), // Aumenta la altura
        width: _sizeTween.evaluate(animation), // Aumenta el ancho
        child: FlutterLogo(),
      ),
    );
  }
}
