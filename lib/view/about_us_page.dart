import 'package:expense_manager/view/drawer_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  static const routeName = "\aboutUsScreen";
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.of(context)
            .pushReplacementNamed(TransactionsScreen.routeName);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("About Us"),
        ),
        drawer: const MyDrawer(),
        body: const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
        ),
      ),
    );
  }
}
