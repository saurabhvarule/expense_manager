import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/providers/trash_provider.dart';
import 'package:expense_manager/view/drawer_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  static const routeName = "\trashscreen";

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  bool isLoading = false;

  ///WE WILL GET ALL THE TRASH INITIALLY
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoading = true;
    Provider.of<TrashProvider>(context)
        .getAllTrash(false, Provider.of<ExpenseProvider>(context).monthSelected)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  ///THIS IS THE CONFIRMATION DIALOG BOX IF DELETE EXPENSE IS SELECTED THEN
  ///clearFromTrash METHOD WILL BE CALLED WHICH WILL CLEAR THE SELECTED  EXPENSE
  Future<bool> showMyDialogBox(
      {required DismissDirection dismissDirection,
      required TrashProvider trashProvider,
      required ExpenseProvider expenseProvider,
      required int currentIndex}) async {
    bool shouldDismiss = false;

    ///IF WE WANT TO DELET THE EXPENSE
    if (dismissDirection == DismissDirection.startToEnd) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete Expense",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            content: const Text("Are you sure?"),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    ///THIS IS AN API CALL
                    ///WE HAVE PASSED THE TRASH ID AND THE SELECTED MONTH
                    ///THE SELECTED MONTH IS THERE IN THE EXPENSEPROVIDER
                    await trashProvider.clearFromTrash(
                      trashProvider.trashList[currentIndex].trashId,
                      expenseProvider.monthSelected,
                    );

                    Navigator.of(context).pop();
                    shouldDismiss = true;
                  },
                  child: Text(
                    "Delete",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(140, 128, 128, 0.2)),
                onPressed: () {
                  Navigator.of(context).pop();
                  shouldDismiss = false;
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          );
        },
      );
    }

    ///IF WE WANT TO RESTORE THE EXPENSE
    else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Restore Expense",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            content: const Text("Are you sure?"),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(14, 161, 125, 1)),
                  onPressed: () async {
                    ///TO RESTORE THE EXPENSE WE WILL PASS THE TRASH ID TO THE removeFromTrash METHOD
                    final statuscode = await trashProvider.restoreFromTrash(
                        trashProvider.trashList[currentIndex].trashId
                            .toString(),
                        expenseProvider.monthSelected);
                    if (statuscode != 200 && statuscode != 204) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Something Went Wrong!!",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.black,
                      ));
                    } else {
                      shouldDismiss = false;
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Restore",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(140, 128, 128, 0.2)),
                onPressed: () {
                  Navigator.of(context).pop();
                  shouldDismiss = false;
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          );
        },
      );
    }
    return shouldDismiss;
  }

  @override
  Widget build(BuildContext context) {
    final trashProvider = Provider.of<TrashProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (isPagePoped) async {
        Navigator.pushReplacementNamed(context, TransactionsScreen.routeName);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const MyDrawer(),
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Trash",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : trashProvider.trashList.isEmpty
                ? Center(
                    child: Text(
                      "No trash available",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: trashProvider.trashList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),

                              ///HERE WE HAVE USEED THE DISMISSIBLE WIDGET
                              ///THSI WIDGET WILL ALLOW US TO REMOVE THE CARD BY SWIPING
                              ///LEFT OR RIGHT
                              child: Dismissible(
                                secondaryBackground: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                  color: Colors.blue,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 5),
                                      Text("Restore"),
                                    ],
                                  ),
                                ),
                                background: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  color: Colors.red,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                                confirmDismiss: (DismissDirection direction) {
                                  ///WHEN WE SWPIE THIS METHOD WILL BE CALLED WHICH WILL DISPLAY A DIALOG
                                  return showMyDialogBox(
                                    currentIndex: index,
                                    dismissDirection: direction,
                                    expenseProvider: expenseProvider,
                                    trashProvider: trashProvider,
                                  );
                                },
                                key: ValueKey(index),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.remove_circle,
                                          color:
                                              Color.fromRGBO(204, 210, 227, 1),
                                          size: 30,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                trashProvider.trashList[index]
                                                    .trashCategory,
                                                style: GoogleFonts.poppins(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                trashProvider.trashList[index]
                                                    .trashDescription,
                                                style: GoogleFonts.poppins(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 0.8),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          trashProvider
                                              .trashList[index].trashAmount,
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          DateFormat.MMMd().format(
                                            DateTime.parse(trashProvider
                                                .trashList[index].trashDate),
                                          ),
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Text(" | "),
                                        Text(
                                          trashProvider
                                              .trashList[index].trashTime,
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            )
                          ],
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
