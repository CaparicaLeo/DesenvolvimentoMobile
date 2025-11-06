import 'package:auth_apk/view/components/my_button.dart';
import 'package:auth_apk/view/components/my_textfield.dart';
import 'package:auth_apk/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showWaiting() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void showAlert(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(msg));
      },
    );
  }

  void registerUser() async {
    showWaiting();
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Navigator.pop(context);
        showAlert('As senhas não conferem!');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e.code);
      if (e.code == 'email-already-in-use') {
        showAlert('Ja existe um usuário com esse email');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                  'Register!',
                  style: TextStyle(color: Colors.black, fontSize: 35),
                ),
                SizedBox(height: 25),
                MyTextfield(
                  controller: usernameController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 15),
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                SizedBox(height: 15),
                MyButton(onTap: registerUser, text: 'Register'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
