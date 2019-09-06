import 'package:Yahrzeit/screens/homeScreen.dart';
import 'package:Yahrzeit/screens/loginScreen.dart';
import 'package:flutter/material.dart';
// import '../screens/splashScreen.dart';
import "../service/graphQLConf.dart";
import "package:graphql_flutter/graphql_flutter.dart";

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
      GraphQLProvider(
        client: graphQLConfiguration.client,
        child: CacheProvider(child: Yahrzeits()),
      ),
    );

class Yahrzeits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Todas sus apliaciones deben de estar dentro de Material App para poder
    // hacer uso de las facilidades de Material Design puede omitirce esto pero
    // no podran hacer uso de estos widgets de material.dart
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), //  Tema Claro
//      theme: ThemeData.dark(), // Tema Obscuro
      home: LoginScreen(),
    );
  }
}