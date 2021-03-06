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
  bool _registering = false;

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
                    Colors.black.withOpacity(1.0), BlendMode.dstATop),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        focusColor: Colors.white,
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "John",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal[300]),
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
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          focusColor: Colors.white,
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: "Doe",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30.0)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal[300]),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        focusColor: Colors.white,
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "john.doe@gmail.com",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0)),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        focusColor: Colors.white,
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "********",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0)),
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "********",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0)),
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
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: new InkWell(
                      onTap: () {
                        if (_registerFormKey.currentState.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {
                            setState(() {
                              _registering = true;
                            });
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                    .collection("users")
                                    .document(currentUser.user.uid)
                                    .setData({
                                      "darkMode": false,
                                      "uid": currentUser.user.uid,
                                      "fname": firstNameInputController.text,
                                      "surname": lastNameInputController.text,
                                      "email": emailInputController.text,
                                    })
                                    .then((result) => {
                                          Firestore.instance
                                              .collection("users")
                                              .document(currentUser.user.uid)
                                              .get()
                                              .then((result) => {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomePage(
                                                                          user:
                                                                              result,
                                                                          uid: currentUser
                                                                              .user
                                                                              .uid,
                                                                        )),
                                                            (_) => false),
                                                    //add initial collections for user
                                                    Firestore.instance
                                                        .collection(
                                                            "users/${currentUser.user.uid}/Books"),
                                                    Firestore.instance
                                                        .collection(
                                                            "users/${currentUser.user.uid}/Friends"),
                                                    Firestore.instance.collection("allUsers")
                                                    .document(firstNameInputController.text+" "+lastNameInputController.text)
                                                    .setData({
                                                      "fname": firstNameInputController.text,
                                                      "surname": lastNameInputController.text,
                                                      "uid": currentUser.user.uid,
                                                    }),
                                                    Firestore.instance
                                                        .collection(
                                                            "users/${currentUser.user.uid}/WeeklyReadingData")
                                                            .document("data")
                                                            .setData({
                                                              "Mon": 0, "Tue": 0, "Wed": 0, "Thur": 0 , "Fri": 0, "Sat": 0, "Sun":0,
                                                            }),
                                                    //clear inputs
                                                    firstNameInputController
                                                        .clear(),
                                                    lastNameInputController
                                                        .clear(),
                                                    emailInputController
                                                        .clear(),
                                                    pwdInputController.clear(),
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
                                    content: Text("The passwords do not match"),
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
                      child: new AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          width: _registering == false ? 400.0 : 70,
                          height: 60.0,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                            color: const Color(0xFF80CBC4),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(30.0)),
                          ),
                          child: _registering == false
                              ? new Text("Register", style: TextStyle(fontSize:20.0))
                              : new CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )),
                    ),
                  ),
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  FlatButton(
                    child: Text("Login here!",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}
