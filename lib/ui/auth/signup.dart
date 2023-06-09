import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/auth/login.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  // Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: "Email",
                        helperText: "enter email e.g. abc@gmail.co",
                        prefixIcon: Icon(Icons.alternate_email_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter you mail id";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Password
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                        hintText: "Password", prefixIcon: Icon(Icons.password)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter you password";
                      } else if (value.length < 6) {
                        return "Password length must at atleast 6";
                      } else {
                        return null;
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              text: "Sign up",
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _signUpFunction();
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogIn()));
                    },
                    child: const Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signUpFunction() {
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Account Created Successfully",
          backgroundColor: Colors.deepPurple);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LogIn()));
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
        msg: error.toString(),
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
      );
      setState(() {
        loading = false;
      });
    });
  }
}
