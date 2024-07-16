import 'package:expense_manager/providers/category_provider.dart';
import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/providers/graph_provider.dart';
import 'package:expense_manager/providers/loginsignup_provider.dart';
import 'package:expense_manager/providers/trash_provider.dart';
import 'package:expense_manager/providers/user_provider.dart';
import 'package:expense_manager/view/about_us_page.dart';
import 'package:expense_manager/view/category_screen.dart';
import 'package:expense_manager/view/graph_screen.dart';
import 'package:expense_manager/view/splash_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:expense_manager/view/trash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) {
            return LoginSignupProvider();
          }),
          ChangeNotifierProvider(create: (ctx) {
            return UserProvider();
          }),
          ChangeNotifierProvider(create: (context) {
            return CategoryProvider();
          }),
          ChangeNotifierProvider<ExpenseProvider>(
            create: (context) {
              return ExpenseProvider();
            },
          ),
          ChangeNotifierProvider<TrashProvider>(create: (context) {
            return TrashProvider();
          }),
          ChangeNotifierProvider<GraphProvider>(
            create: (ctx) {
              return GraphProvider();
            },
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            TransactionsScreen.routeName: (context) =>
                const TransactionsScreen(),
            GraphScreen.routeName: (context) => const GraphScreen(),
            CategoryScreen.routeName: (context) => const CategoryScreen(),
            TrashScreen.routeName: (context) => const TrashScreen(),
            AboutUsScreen.routeName: (context) => const AboutUsScreen()
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
