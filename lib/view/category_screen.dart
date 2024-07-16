import 'package:expense_manager/model/expense_category.dart';
import 'package:expense_manager/providers/category_provider.dart';
import 'package:expense_manager/view/drawer_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static const routeName = "\categoryScreen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

  ///WE WILL GET ALL THE AVAILABLE CATEGORIES
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<CategoryProvider>(
      context,
    ).getAllCategories().then((value) {
      setState(() {});
    });
  }

  void showMySnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        content,
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black,
    ));
  }

  ///WE WILL EITHER ADD OR UPDATE THE CATEGORY BASED ON THE isEdit VARIABLE
  Future<void> submitCategory(bool isEdit, [int? categoryId]) async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    int statusCode = -1;

    if (isEdit) {
      ///call the updateCategory method if asked for edit
      statusCode = await categoryProvider.updateCategory(categoryId!);
    } else {
      ///call the addCategory method if new vcategory must be added
      statusCode = await categoryProvider.addCategory();
    }

    ///If the category is added or updated successfully display a snackbar
    print("My satatus code: $statusCode");
    if (statusCode == 201 || statusCode == 200) {
      showMySnackBar("Category added successfully");
      Navigator.of(context).pop();
    }

    ///SHOW TH ESNACKBARS BASED ON THE VALUE OF THE STATUS CODE
    else if (statusCode == 400) {
      if (!context.mounted) {
        return;
      }
      showMySnackBar("Invalid image link");

      Navigator.of(context).pop();
    } else if (statusCode == 409) {
      Navigator.of(context).pop();
      showMySnackBar("Category already exists");
    } else {
      Navigator.of(context).pop();
      showMySnackBar("Something went wrong");
    }
    categoryProvider.clearControllers();
  }

  ///THIS IS THE BOTTOMSHEET TO ADD OR UPDATE THE CATEGORY
  Future<void> addCategoryBottomSheet(
      CategoryProvider categoryProvider, bool isEdit,
      [ExpenseCategory? expenseCategoryObj]) async {
    if (isEdit) {
      categoryProvider.isImgPicked = true;
    } else {
      categoryProvider.isImgPicked = false;
    }
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
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  ///Check whether there is a text in the textfield and
                  ///whether it is a valid url.
                  ///if it is a valid url then diplay the entered image
                  child: categoryProvider.imageController.text.isNotEmpty &&
                          categoryProvider.isImgPicked
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            categoryProvider.imageController.text,
                            height: 80,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(140, 128, 128, 0.2),
                          radius: 40,
                          child: Image.asset(
                            fit: BoxFit.cover,
                            "assets/images/containerImage.png",
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Add Image",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Text("Add Image"),
                const SizedBox(height: 10),
                TextFormField(
                  onFieldSubmitted: (value) {
                    ///WHEN THE USER TYPES THE URL IN THE TEXTFIELD IF THE URL STARTS WITH https
                    ///i.e IS A VALID URL
                    ///IF TEH URL IS VALID THEN DISPLAY THE IMAGE IN THE ABOVE CIRCLEAVATAR
                    if (value.startsWith("https")) {
                      categoryProvider.togglePickedImg(true);
                    } else {
                      categoryProvider.togglePickedImg(false);
                    }
                  },
                  validator: (value) {
                    return !categoryProvider.imageController.text
                            .startsWith("https")
                        ? "Enter a valid Url"
                        : categoryProvider.imageController.text.isEmpty
                            ? "Image Url Required"
                            : null;
                  },
                  controller: categoryProvider.imageController,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    hintText: "Enter Image URL",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(33, 33, 33, 0.6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(191, 189, 189, 1),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Category"),
                const SizedBox(height: 10),
                TextFormField(
                  controller: categoryProvider.nameController,
                  validator: (value) {
                    return categoryProvider.nameController.text.isEmpty
                        ? "Category name required"
                        : null;
                  },
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    hintText: "Enter Category Name",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(33, 33, 33, 0.6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(191, 189, 189, 1),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 161, 125, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19))),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ///IF WE WANT TO EDIT CALL THE submitCategory METHOD with a boolean value and  id
                        if (isEdit) {
                          await submitCategory(
                              true, int.parse(expenseCategoryObj!.id));
                        } else {
                          await submitCategory(false);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
        );
      },
    );
  }

  ///THIS IS THE CONFIRMATION DIALOGBOX TO REMOVE  THE CATEGORY
  Future<void> removeCategoryDialog(int currentIndex) async {
    await showDialog(
      context: context,
      builder: (context) {
        final categoryProvider = Provider.of<CategoryProvider>(context);

        return AlertDialog(
          title: Text(
            "Delete Category",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          content: Text(
            "By Deleting this Category Transactions related to this category will be deleted.",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.of(context).pop();

                  ///Call the remove category method if if we confirm to remove the category
                  ///if we remove the category then all the transactions related to the category will get removed
                  final statuscode = await categoryProvider.removeCategory(
                      categoryProvider.expenseCategoriesList[currentIndex].id);
                  if (statuscode != 200) {
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
                  backgroundColor: const Color.fromRGBO(140, 128, 128, 0.2)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (categoryProvider.isModalBottomSheetOpened == true) {
          categoryProvider.nameController.clear();
          categoryProvider.imageController.clear();
        } else {
          Navigator.pushReplacementNamed(context, TransactionsScreen.routeName);
        }
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const MyDrawer(),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Text(
              "Categories",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          body: categoryProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : categoryProvider.expenseCategoriesList.isEmpty
                  ? Center(
                      child: Text(
                        "No Categories available",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Expanded(
                            child: Consumer<CategoryProvider>(
                              builder: (context, category, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: GridView.builder(
                                    itemCount:
                                        category.expenseCategoriesList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1 / 1,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 18,
                                      mainAxisSpacing: 18,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () async {
                                            ///assign the value from the tapped category to the respective textformfields.
                                            categoryProvider
                                                    .imageController.text =
                                                category
                                                    .expenseCategoriesList[
                                                        index]
                                                    .imageUrl;
                                            categoryProvider
                                                    .nameController.text =
                                                category
                                                    .expenseCategoriesList[
                                                        index]
                                                    .name;

                                            ///open the bottomsheet with the vales already filled
                                            await addCategoryBottomSheet(
                                              categoryProvider,
                                              true,
                                              category
                                                  .expenseCategoriesList[index],
                                            );
                                          },
                                          onLongPress: () async {
                                            ///open the dialogbox when the card is longpressed.
                                            await removeCategoryDialog(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    spreadRadius: 0,
                                                    color: Colors.grey,
                                                    offset: Offset(1, 2),
                                                    blurRadius: 5),
                                              ],
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 45,
                                                  backgroundImage: NetworkImage(
                                                    categoryProvider
                                                        .expenseCategoriesList[
                                                            index]
                                                        .imageUrl,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  categoryProvider
                                                      .expenseCategoriesList[
                                                          index]
                                                      .name,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () async {
              //SHOW THE Bottomsheet used to add the category
              await addCategoryBottomSheet(categoryProvider, false);
              categoryProvider.clearControllers();
            },
            icon: Image.asset("assets/images/categoryIcon.png"),
            label: Text(
              "Add Category",
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
      ),
    );
  }
}
