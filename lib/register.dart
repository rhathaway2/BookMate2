import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bookshelf.png"),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.50), BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, bottom: 40.0),
                    child: Center(
                        child: Text('Create an Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Lobster'))),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.black38),
                          focusColor: Colors.white,
                          labelText: 'First Name',
                          hintText: "John",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal[200]),
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      controller: firstNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter a valid first name.";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: Colors.black38),
                            focusColor: Colors.white,
                            labelText: 'Last Name',
                            hintText: "Doe",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                              borderRadius: BorderRadius.circular(30.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal[200]),
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                        controller: lastNameInputController,
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid last name.";
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.black38),
                          focusColor: Colors.white,
                          labelText: 'Email',
                          hintText: "john.doe@gmail.com",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal[200]),
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.black38),
                          focusColor: Colors.white,
                          labelText: 'Password',
                          hintText: "********",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal[200]),
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.black38),
                          labelText: 'Confirm Password',
                          hintText: "********",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white38),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal[200]),
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      controller: confirmPwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ButtonTheme(
                          minWidth: 400.0,
                          height: 50.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text("Register"),
                            color: Colors.teal[200],
                            textColor: Colors.white,
                            onPressed: () {
                              if (_registerFormKey.currentState.validate()) {
                                if (pwdInputController.text ==
                                    confirmPwdInputController.text) {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailInputController.text,
                                          password: pwdInputController.text)
                                      .then((currentUser) => Firestore.instance
                                          .collection("users")
                                          .document(currentUser.user.uid)
                                          .setData({
                                            "uid": currentUser.user.uid,
                                            "fname":
                                                firstNameInputController.text,
                                            "surname":
                                                lastNameInputController.text,
                                            "email": emailInputController.text,
                                          })
                                          .then((result) => {
                                                Firestore.instance
                                                    .collection("users")
                                                    .document(
                                                        currentUser.user.uid)
                                                    .get()
                                                    .then((result) => {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomePage(
                                                                                user: result,
                                                                                uid: currentUser.user.uid,
                                                                              )),
                                                                  (_) => false),
                                                          //add initial collections for user
                                                          Firestore.instance
                                                              .collection(
                                                                  "users/${currentUser.user.uid}/Books")
                                                              .document(
                                                                  "initializer")
                                                              .setData({}),
                                                          Firestore.instance
                                                              .collection(
                                                                  "users/${currentUser.user.uid}/Notes")
                                                              .document(
                                                                  "initializer")
                                                              .setData({}),
                                                          Firestore.instance
                                                              .collection(
                                                                  "users/${currentUser.user.uid}/Reviews")
                                                              .document(
                                                                  "initializer")
                                                              .setData({}),
                                                          Firestore.instance
                                                              .collection(
                                                                  "users/${currentUser.user.uid}/Posts")
                                                              .document(
                                                                  "Created Account")
                                                              .setData({
                                                            "Date":
                                                                DateTime.now(),
                                                          }),
                                                          Firestore.instance
                                                              .collection(
                                                                  "users/${currentUser.user.uid}/Friends")
                                                              .document(
                                                                  "initializer")
                                                              .setData({}),

                                                          //clear inputs
                                                          firstNameInputController
                                                              .clear(),
                                                          lastNameInputController
                                                              .clear(),
                                                          emailInputController
                                                              .clear(),
                                                          pwdInputController
                                                              .clear(),
                                                          confirmPwdInputController
                                                              .clear()
                                                        })
                                              })
                                          .catchError((err) => print(err)))
                                      .catchError((err) => print(err));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                              "The passwords do not match"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                          ))),
                  Text("Already have an account?"),
                  FlatButton(
                    child: Text("Login here!"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}
