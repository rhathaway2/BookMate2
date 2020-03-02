import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool _loggingIn = false;

  @override
  initState() {
    super.initState();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
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
          child: new Theme(
            data: new ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.white,
              primaryColorDark: Colors.white,
              primaryColorLight: Colors.white,
            ),
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  //logo
                  Padding(
                    padding: EdgeInsets.only(top: 75.0, bottom: 140.0),
                    child: Center(
                        child: Text('BookMate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 65.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[200],
                                fontFamily: 'Lobster'))),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "john.doe@gmail.com",
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
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "********",
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
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                    child: new InkWell(
                      onTap: () {
                        if (_loginFormKey.currentState.validate()) {
                          setState(() {
                            _loggingIn = true;
                          });
                          //_playAnimation();
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) => Firestore.instance
                                  .collection("users")
                                  .document(currentUser.user.uid)
                                  .get()
                                  .then((DocumentSnapshot result) =>
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    user: result,
                                                    uid: currentUser.user.uid,
                                                  ))))
                                  .catchError((err) => print(err)))
                              .catchError((err) => print(err));    
                        }
                      },
                      child: new AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          width: _loggingIn==false ? 400.0 : 70,
                          height: 60.0,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                            color: const Color(0xFF80CBC4),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(30.0)),
                          ),
                          child: _loggingIn==false
                              ? new Text("Sign In",)
                              : new CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )),
                    ),
                  ),

                  Text("Don't have an account yet?",
                      style: TextStyle(color: Colors.white)),
                  FlatButton(
                    child: Text(
                      "Register here!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
