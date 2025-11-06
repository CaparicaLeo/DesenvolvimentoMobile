import 'package:auth_apk/view/components/my_button.dart';
import 'package:auth_apk/view/components/my_textfield.dart';
import 'package:auth_apk/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          print(e);
          return AlertDialog(title: Text('Usuário/Senha Incorretos!'));
        },
      );
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
                Icon(Icons.lock, size: 100),
                SizedBox(height: 50),
                Text(
                  'Seja bem vindo',
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
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                MyButton(onTap: signUserIn, text: 'Entrar'),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Nao tem cadastro?',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Registre-se Agora!',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
