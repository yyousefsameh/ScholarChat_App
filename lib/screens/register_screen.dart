import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String registerScreenId = 'registerScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? userEmail;
  String? userPassword;
  bool isLoading = false;
  bool isObscure = false;
  GlobalKey<FormState> formKey = GlobalKey();

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
                      'REGISTER',
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
                  onChanged: (userEmailData) {
                    userEmail = userEmailData;
                  },
                  keyBoardType: TextInputType.emailAddress,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  onChanged: (userPasswordData) {
                    userPassword = userPasswordData;
                  },
                  keyBoardType: TextInputType.visiblePassword,
                  hintText: 'Password',
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
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CustomButton(
                  buttonLabel: 'REGISTER',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await registerUser();
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (error) {
                        if (error.code == 'weak-password') {
                          showSnackBar(context, 'weak password');
                        } else if (error.code == 'email-already-in-use') {
                          showSnackBar(context, 'email already exits');
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
                      'already have an account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        '   Login',
                        style: TextStyle(
                          color: Color(
                            0xffc7ede6,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential userData =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail!,
      password: userPassword!,
    );
  }
}
