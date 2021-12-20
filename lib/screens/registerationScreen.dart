/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pai_nai/main.dart';
import 'package:pai_nai/screens/loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pai_nai/screens/mainscreen.dart';
import 'package:pai_nai/widgets/progressDialog.dart';

class RegiterationScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Image(
                image: AssetImage('images/logo.png'),
                width: 390,
                height: 250,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1),
              Text(
                'Login as a Rider',
                style: TextStyle(fontSize: 24, fontFamily: 'Brand-Bold'),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 1),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 1),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 1),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 1),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand-Bold'),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 3) {
                          displayToastMessage(
                              'name must be atleast 3 Character.', context);
                        } else if (!emailTextEditingController.text
                            .contains('@')) {
                          displayToastMessage(
                              'Email address is not Valid', context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              'Phone Number is mandatory', context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          displayToastMessage(
                              'Password must be atleast 6 Characters.',
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  'Create an Account? Login Here',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: ' Registering, Please wait...',
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) { 
            Navigator.pop(context);
      displayToastMessage('Error :' + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      Map userDataMap = {
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'phone': phoneTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          'Comgratulations, your account has been created', context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
       Navigator.pop(context);
      displayToastMessage('New user account has not been Create', context);
    }
  }
}
displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  } */