import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/helpers/show_snack_bar.dart';
import 'package:scholar_chat/screens/chat_screen.dart';
import 'package:scholar_chat/widgets/custom_text_field.dart';
import 'package:scholar_chat/widgets/custom_Button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static String pageId = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;
  String? password;
  bool isLoading = false;
  // * Create Object from GlobalKey
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
                    'REGISTER',
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
            const CustomFormTextField(labelText: 'Name'),
            CustomFormTextField(
              onChanged: (emailData) {
                email = emailData;
              },
              labelText: 'Email *',
            ),
            CustomFormTextField(
              onChanged: (passwordData) {
                password = passwordData;
              },
              labelText: 'Password *',
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  isLoading = true;
                  setState(() {});
                  try {
                    await registerAuth();
                    showSnackBar(context, massage: 'Successfully Registered!');
                    Navigator.pushNamed(
                      context,
                      ChatScreen.pageId,
                      arguments: email,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      showSnackBar(
                        context,
                        massage: 'Weak Password.',
                      );
                    } else if (e.code == 'email-already-in-use') {
                      showSnackBar(
                        context,
                        massage: 'Email Already in Use.',
                      );
                    }
                  } catch (ex) {
                    showSnackBar(context, massage: 'There was an Error.');
                  }
                  isLoading = false;
                  setState(() {});
                }
              },
              buttonLabel: 'REGISTER',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already Have An Account ? ',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    ' Login Now !',
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

  Future<void> registerAuth() async {
    // ignore: unused_local_variable
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
