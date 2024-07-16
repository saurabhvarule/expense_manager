import 'dart:async';
import 'package:expense_manager/providers/user_provider.dart';
import 'package:expense_manager/view/login_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// THIS METHOD WILL STARRT A TIMER AND WILL CHECK IF THE USER IS LOGGED IN OR NOT
  /// IF YES IT  WILL NAVIGATE TO TRANSACTION SCREEN OR ELSE IT WILL NAVIGATE TO
  /// LOGINSCREEN

  void navigateToNextScreen() {
    final userProvider = Provider.of<UserProvider>(context);

    Timer(
      const Duration(seconds: 3),
      () async {
        ///THIS METHOD WILL CHECK IF USER IS LOGGED IN OR NOT
        await userProvider.userLoggedInOrNot();
        if (userProvider.isuserLoggedIn == false) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const LoginScreen();
              },
            ),
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            TransactionsScreen.routeName,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    navigateToNextScreen();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color.fromRGBO(234, 238, 235, 1),
              child: Image.asset("assets/images/logo.png"),
            ),
            const Spacer(),
            Text(
              "Expense Manager",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}
