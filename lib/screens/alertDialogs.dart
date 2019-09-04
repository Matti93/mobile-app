import 'dart:developer';

import "package:flutter/material.dart";
import "../service/graphqlConf.dart";
import "../service/queryMutation.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import "../models/user.dart";

class AlertDialogWindow extends StatefulWidget {
  final User user;

  AlertDialogWindow({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlertDialogWindow(this.user);
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  TextEditingController txtMail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();

  final User user;

  _AlertDialogWindow(this.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegExp emailRegExp =
        new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
    RegExp contRegExp = new RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
    return AlertDialog(
      title: Text("Create User"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    validator: (text) {
                      if (text.length == 0) {
                        return "This field is required";
                      } else if (!emailRegExp.hasMatch(text)) {
                        return "The format for mail is not correct";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: txtMail,
                    decoration: InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      labelText: "Mail",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 80.0),
                  child: TextFormField(
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
                    controller: txtPassword,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Password",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text("Create"),
          onPressed: () async {
            if (txtMail.text.isNotEmpty && txtPassword.text.isNotEmpty) {
              GraphQLClient _client = graphQLConfiguration.clientToQuery();
              QueryResult result = await _client.mutate(
                MutationOptions(
                  document: addMutation.addUser(
                    txtMail.text,
                    txtPassword.text,
                  ),
                ),
              );
              log(txtMail.text);
              if (!result.hasErrors) {
                txtMail.clear();
                txtPassword.clear();
                Navigator.of(context).pop();
              }
            }
          },
        )
      ],
    );
  }
}
