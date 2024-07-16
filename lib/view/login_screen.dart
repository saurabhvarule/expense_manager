import 'package:expense_manager/providers/loginsignup_provider.dart';
import 'package:expense_manager/view/signup_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///THIS METHOD WILL RETURN A SNACKBAR WITH THE PROVIDED TEXT
  void showMySnackBar(String data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.black,
      ),
    );
  }

  ///THIS METHOD WILL CHECK THE VALIDATION AND SEND A SIGNIN REQUEST TO SERVER
  ///AND DISPLAY SNACKBAR IF ANY ERROR OCCURS

  Future<void> submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loginSignupProvider =
        Provider.of<LoginSignupProvider>(context, listen: false);
    if (loginSignupProvider.loginFormKey.currentState!.validate()) {
      String message = await loginSignupProvider.signIn();

      if (message == "User Authenticated Successfully") {
        await userProvider.setData(loginSignupProvider.currentUser.toString());

        Navigator.pushReplacementNamed(context, TransactionsScreen.routeName);
      } else {
        showMySnackBar(message);
      }
    } else {
      showMySnackBar(
        "Something Went Wrong!!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginSignupProvider = Provider.of<LoginSignupProvider>(context);
    return loginSignupProvider.isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Login to your Account",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                        key: loginSignupProvider.loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 10,
                                        color: Color.fromRGBO(0, 0, 0, 0.15))
                                  ]),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Enter Username";
                                  }

                                  return null;
                                },
                                controller:
                                    loginSignupProvider.loginUsernameController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 0.4)),
                                    contentPadding: EdgeInsets.only(left: 15)),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 10,
                                        color: Color.fromRGBO(0, 0, 0, 0.15))
                                  ]),
                              child: TextFormField(
                                obscureText:
                                    loginSignupProvider.obsecurePassword,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Enter A Password";
                                  }

                                  return null;
                                },
                                controller:
                                    loginSignupProvider.loginPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        ///THIS METHOD WILL TOGGLE THE PASSWORD VISIBLITY
                                        loginSignupProvider
                                            .changePasswordVisiblity();
                                      },
                                      child:
                                          loginSignupProvider.obsecurePassword
                                              ? const Icon(Icons.visibility_off)
                                              : const Icon(Icons.visibility)),
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 15, top: 10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () async {
                                ///SUBMIT THE RESPONSE TO THE SERVER
                                await submit();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromRGBO(14, 161, 125, 1),
                                ),
                                width: 320,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Sign In",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account?",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (loginSignupProvider.obsecurePassword) {
                              loginSignupProvider.obsecurePassword = false;
                            }
                            loginSignupProvider.loginUsernameController.clear();
                            loginSignupProvider.loginPasswordController.clear();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SignupScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            " Sign Up",
                            style: GoogleFonts.poppins(
                                color: const Color.fromRGBO(14, 161, 125, 1),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
