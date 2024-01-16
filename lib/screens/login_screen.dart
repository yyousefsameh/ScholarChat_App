import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String loginScreenId = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = false;
  bool isLoading = false;
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String? userEmail, userPassword;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kSenderPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 75.0,
                ),
                Image.asset(
                  kLogoPath,
                  height: 100.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontFamily: 'pacifico',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 75.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CustomTextFormField(
                  keyBoardType: TextInputType.emailAddress,
                  controller: userEmailController,
                  hintText: 'Email',
                  onChanged: (userEmailData) {
                    userEmail = userEmailData;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  controller: userPasswordController,
                  obscureText: isObscure,
                  suffixIcon: isObscure == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = false;
                            });
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = true;
                            });
                          },
                          icon: const Icon(
                            Icons.visibility_off,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                  keyBoardType: TextInputType.visiblePassword,
                  hintText: 'Password',
                  onChanged: (userPasswordData) {
                    userPassword = userPasswordData;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CustomButton(
                  buttonLabel: "LOGIN",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushReplacementNamed(
                          context,
                          ChatScreen.chatScreenId,
                          arguments: userEmail,
                        );
                      } on FirebaseAuthException catch (error) {
                        if (error.code == 'user-not-found') {
                          showSnackBar(context, 'user not found');
                        } else if (error.code == 'wrong-password') {
                          showSnackBar(context, 'wrong password');
                        }
                      } catch (error) {
                        showSnackBar(context, 'there was an error');
                      }

                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'dont\'t have an account?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        '   Register',
                        style: TextStyle(
                          color: Color(
                            0xffc7ede6,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RegisterScreen.registerScreenId,
                        );
                        userEmailController.clear();
                        userPasswordController.clear();
                      },
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

  Future<void> loginUser() async {
    UserCredential userData =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userEmail!,
      password: userPassword!,
    );
  }
}
