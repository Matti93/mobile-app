import 'dart:developer';

import 'package:Yahrzeit/screens/createYahrzeitScreen.dart';
import 'package:Yahrzeit/screens/loginScreen.dart';
import 'package:flutter/material.dart';
// import '../screens/splashScreen.dart';
import "../service/graphQLConf.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
      GraphQLProvider(
        client: graphQLConfiguration.client,
        child: CacheProvider(child: Yahrzeits()),
      ),
    );
final storage = new FlutterSecureStorage();
String token;
Future getToken() async {
       token = await storage.read(key: token);
  }
    
class Yahrzeits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getToken();
    // Todas sus apliaciones deben de estar dentro de Material App para poder
    // hacer uso de las facilidades de Material Design puede omitirce esto pero
    // no podran hacer uso de estos widgets de material.dart
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), //  Tema Claro
//      theme: ThemeData.dark(), // Tema Obscuro
      home: token != null ? CreateYahrzeitAccountScreen() : LoginScreen(),
    );
  }
}