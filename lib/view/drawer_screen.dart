import 'package:expense_manager/view/about_us_page.dart';
import 'package:expense_manager/view/category_screen.dart';
import 'package:expense_manager/view/graph_screen.dart';
import 'package:expense_manager/view/login_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:expense_manager/view/trash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "Expense Manager",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              "Save All your Trasactions",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: const Color.fromRGBO(0, 0, 0, 0.5)),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, TransactionsScreen.routeName);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 17,
                      width: 17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/transactionIcon.png"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Transaction",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(GraphScreen.routeName);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 17,
                      width: 17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/graphIcon.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Graphs",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(CategoryScreen.routeName);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                // padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 17,
                      width: 17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/categoryIcon.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Category",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(TrashScreen.routeName);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 17,
                      width: 17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/trashIcon.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Trash",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AboutUsScreen.routeName);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 17,
                      width: 17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/aboutusIcon.png"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "About Us",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await userProvider.logOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      height: 17,
                      width: 17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/categoryIcon.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Log Out ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
