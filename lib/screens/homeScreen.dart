import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();

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
      body: _logueado ? HomeScreen() : loginForm(),
    );
  }

  Widget loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        onPressed: () async {},
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)))),
                SizedBox(height: 50.0),
                ButtonTheme(
                    minWidth: 300,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "View/Edit Yahrzeits",
                          style: new TextStyle(
                              fontSize: 20, color: Colors.black54),
                        ),
                        onPressed: () async {},
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))))
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
      child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/imageScreen.png',
              fit: BoxFit.cover,
              width: 300,
              height: 200,
            ),
          ]),
    );
  }
}
