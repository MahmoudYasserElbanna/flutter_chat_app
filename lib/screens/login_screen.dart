import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/helpers/show_snack_bar.dart';
import 'package:scholar_chat/screens/chat_screen.dart';
import 'package:scholar_chat/screens/register_screen.dart';
import 'package:scholar_chat/widgets/custom_text_field.dart';
import 'package:scholar_chat/widgets/custom_Button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);
  static String pageId = 'LogInScreen';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Form(
          key: formKey,
          child: ListView(children: [
            const SizedBox(height: 64),
            const Image(
              image: AssetImage(
                'assets/images/scholar.png',
              ),
              height: 100,
            ),
            const Center(
              child: Text(
                'Scholar Chat',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomFormTextField(
              labelText: 'Email',
              onChanged: (data) {
                email = data;
              },
            ),
            CustomFormTextField(
                obscureText: true,
                labelText: 'Password',
                onChanged: (data) {
                  password = data;
                }),
            const SizedBox(height: 20),
            CustomButton(
              buttonLabel: 'SIGN IN',
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  isLoading = true;
                  setState(() {});
                  try {
                    await loginAuth();
                    showSnackBar(context, massage: 'Successfully Signed In!');
                    Navigator.pushNamed(
                      context,
                      ChatScreen.pageId,
                      arguments: email,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showSnackBar(
                        context,
                        massage: 'No user found for that email.',
                      );
                    } else if (e.code == 'wrong-password') {
                      showSnackBar(
                        context,
                        massage: 'Wrong password provided for that user.',
                      );
                    }
                  } catch (e) {
                    showSnackBar(context, massage: 'There was an Error.');
                  }
                  isLoading = false;
                  setState(() {});
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t Have An Account ? ',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterScreen.pageId);
                  },
                  child: const Text(
                    ' Register Now !',
                    style: TextStyle(color: Color(0xFFC4E9E5)),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> loginAuth() async {
    // ignore: unused_local_variable
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
