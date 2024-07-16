import 'dart:developer';
import 'package:expense_manager/providers/category_provider.dart';
import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/view/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  static const routeName = "\transactionScreen";

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  DateTime? selectedMonth;

  ///HERE WE WILL LOAD ALL THE EXPENSES AND THE CATEGORIES
  ///WE ARE LOADING THE CATEGORIES BECAUSE
  ///WE WILL REQUIRE THE CATEGORIES WHILE ADDING THE NEW TRANSACTION
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoading = true;
    Provider.of<ExpenseProvider>(context, listen: false)
        .getAllExpenses(doNotify: false)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    isLoading = true;
    Provider.of<CategoryProvider>(context, listen: false)
        .getAllCategories()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  ///THIS BOTTOMSHEET WILL OPEN WHEN WE CLICK ON TH EFLOATING ACTION BUTTON
  Future<void> addTransactionBottomSheet(
      {required ExpenseProvider expenseProvider,
      required CategoryProvider categoryProvider}) async {
    String? selectedCategory;
    await showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Date"),
                    const SizedBox(height: 5),

                    ///TH IS TEXTFORMFIELD IS A READONLY TEXTFORMFILED
                    ///WE CAN"T TYPE IN THIS TEXTFORMFIELD.
                    TextFormField(
                      controller: expenseProvider.dateTextController,
                      readOnly: true,
                      validator: (value) {
                        return expenseProvider.dateTextController.text.isEmpty
                            ? "Date Must Be selected"
                            : null;
                      },
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        hintText: "Select Date",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(191, 189, 189, 1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(191, 189, 189, 1),
                          ),
                        ),
                      ),
                      onTap: () async {
                        ///SELECT THE DATE
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedMonth ?? DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2025));

                        ///CONVERT THE PICKED DATE IN "May 17, 2024" THIS FORMAT
                        if (pickedDate != null) {
                          expenseProvider.dateTextController.text =
                              DateFormat.yMMMd().format(pickedDate);
                          log(expenseProvider.dateTextController.text);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Amount"),
                    const SizedBox(height: 10),
                    TextFormField(
                      autocorrect: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return expenseProvider.amtValidation;
                      },
                      controller: expenseProvider.amtTextController,
                      decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(191, 189, 189, 1),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "Enter Amount",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(191, 189, 189, 1)))),
                    ),
                    const SizedBox(height: 20),
                    const Text("Category"),
                    const SizedBox(height: 15),

                    ///THIS IS A DROPDOWN WHICH WILL DISPLAY US THE VALUES OF THE CATEGORIES
                    ///WHEN WE CLIK ON ANY CATEGORY THE CATEGORY WILL BE DISPLAYED IN THE TEXTFIELD

                    DropdownButtonFormField<String?>(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select Category";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(191, 189, 189, 1),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "Enter Category",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(191, 189, 189, 1)))),

                      ///THIS IS THE VALUE WHICH IS CURRENTLY BEEN DISPLAYED
                      value: selectedCategory,

                      ///LIST OF DROPDOWNMENUITEM i.e THE WIDGET TO DISPLAY IN THE DROPDOWN
                      items: categoryProvider.expenseCategoriesList
                          .map<DropdownMenuItem<String?>>((category) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      category.imageUrl,
                                    ),
                                  )),
                              const SizedBox(width: 30),
                              Text(
                                category.name,
                                style: GoogleFonts.poppins(fontSize: 16),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        ///ASSIGN THE SELECTED CATEGORY VALUE TO OUR VARIABLE
                        selectedCategory = val;
                      },
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Description"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: expenseProvider.descTextController,
                      validator: (value) {
                        return expenseProvider.descTextController.text.isEmpty
                            ? "Description must be added"
                            : null;
                      },
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(191, 189, 189, 1),
                          ),
                        ),
                        hintText: "Enter Description",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(191, 189, 189, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0EA17D),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ///FIND THE CATEGORY WHICH IS SELECTED
                            ///BECAUSE WE WILL HAVE TO PASS TEH CATEGORY IF TO THE ADDEXPENSE METHOD

                            var categoryId = categoryProvider
                                .expenseCategoriesList
                                .where((element) =>
                                    selectedCategory == element.name)
                                .toList()[0]
                                .id
                                .toString();
                            expenseProvider.isValidated = false;
                            isLoading = true;
                            await expenseProvider
                                .addExpense(categoryId)
                                .then((value) {
                              ///CLOSE THE BOTTOMSHEET WHEN THE TASK IS ADDED
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            "Add",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///THIS IS THE DIALOG WHICH WILL BE DISPLAYED WHEN THE USER WILL CLICK ON THE SYSTEM BACK BUTTON
  ///
  void showMyDialog(ExpenseProvider expenseProvider) async {
    if (expenseProvider.isModalBottomSheetOpen) {
      expenseProvider.clearTextEditingControllers();
      expenseProvider.dateTextController.clear();
    } else {
      await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to exit app?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    }
    expenseProvider.isModalBottomSheetOpen = false;
  }

  ///THIS DIALOG WILL BE SHOWN TO TAKE THE CONFIRMATION ON THE DELETE OPERATION
  Future<bool> showDismissDialog(
      BuildContext context, ExpenseProvider expenseProvider, int index) async {
    bool shouldDismiss = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Expense",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          content: const Text("Are you sure?"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  ///CALL THE addToTrash method AND PASS THE id TO THE METHOD
                  Navigator.of(context).pop();

                  final statusCode = await expenseProvider.addTotrash(
                    expenseProvider.expenseList[index].id,
                  );

                  if (statusCode != 200 && statusCode != 204) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Something Went Wrong!!",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else {
                    shouldDismiss = true;
                  }
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
                backgroundColor: const Color.fromRGBO(140, 128, 128, 0.2),
              ),
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

    return shouldDismiss;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return PopScope(
      onPopInvoked: (isPoped) async {
        showMyDialog(expenseProvider);
      },
      child: isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              drawer: const MyDrawer(),
              appBar: AppBar(
                foregroundColor: Colors.black,
                title: isLoading
                    ? Container()
                    : Row(
                        children: [
                          Text(
                            expenseProvider.monthDisplayed,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              ///SELECT THE MONTH TO GET THE EXPENSE MONTHWISE
                              selectedMonth = await showMonthPicker(
                                context: context,
                                initialDate: DateTime(2024),
                                lastDate: DateTime(2025),
                                firstDate: DateTime(2024),
                              );

                              expenseProvider.changePickedMonth(
                                DateFormat.MMM().format(selectedMonth!),
                              );

                              ///WE WILL ASSIGN THE monthSelected VARIABLE
                              ///THE VALUE IN THE FORMAT "2024-11-01" BECAUSE THE API REQUIRES THE VALUE IN THIS FORMAT
                              expenseProvider.monthSelected =
                                  selectedMonth.toString().substring(0, 10);
                              await expenseProvider.getAllExpenses(
                                  doNotify: true);
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: expenseProvider.expenseList.isEmpty
                  ? isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Text(
                            "No Transactions available",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: expenseProvider.expenseList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Dismissible(
                                background: Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  color: Colors.red,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 30),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                                direction: DismissDirection.startToEnd,
                                confirmDismiss: (DismissDirection direction) {
                                  ///SHOW THE DIALOG BOX TO CONFIRM OR CANCEL THE DELETE OPERATION
                                  return showDismissDialog(
                                      context, expenseProvider, index);
                                },
                                key: ValueKey(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                              expenseProvider
                                                  .expenseList[index].imageUrl,
                                            ),
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
                                                  expenseProvider
                                                      .expenseList[index]
                                                      .category,
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
                                                  expenseProvider
                                                      .expenseList[index]
                                                      .description,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      246, 113, 49, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Icon(
                                                  Icons.remove_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                expenseProvider
                                                    .expenseList[index].amount,
                                                style: GoogleFonts.poppins(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ///DISPLAY THE DATE IN "MAY 24" THIS FORMAT
                                          Text(
                                            DateFormat.MMMd().format(
                                                DateTime.parse(expenseProvider
                                                    .expenseList[index].date)),
                                            style: GoogleFonts.poppins(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Text(" | "),
                                          Text(
                                            expenseProvider
                                                .expenseList[index].time,
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
                                thickness: 1,
                                color: Color.fromRGBO(206, 206, 206, 1),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              floatingActionButton: isLoading
                  ? Container()
                  : FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        ///CALL THE addTransactionBottomSheet METHOD
                        expenseProvider.clearTextEditingControllers();
                        await addTransactionBottomSheet(
                            categoryProvider: categoryProvider,
                            expenseProvider: expenseProvider);
                      },
                      icon: Image.asset(
                        "assets/images/categoryIcon.png",
                      ),
                      label: Text(
                        "Add Transaction",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
    );
  }
}
