import 'package:expense_manager/providers/category_provider.dart';
import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/providers/graph_provider.dart';
import 'package:expense_manager/view/drawer_screen.dart';
import 'package:expense_manager/view/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:pie_chart/pie_chart.dart";
import 'package:provider/provider.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  static const routeName = "\graphScreen";

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoading = true;
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);

    ///GET THE DATA REQUIRED TO DISPLAY THE GRAPH

    Provider.of<GraphProvider>(context, listen: false)
        .getDataForGraph(expenseProvider.monthSelected)
        .then((value) {
      ///THIS METHOD GETS THE TOTAL OF ALL THE TRANSACTION

      Provider.of<GraphProvider>(context, listen: false).getTotal();

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final graphProvider = Provider.of<GraphProvider>(context);

    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    ///GET THE LIST OF KEYS FROM THE DATA FETCHED FROM THE SERVERS
    var keyList = graphProvider.dataMap.keys.toList();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pushReplacementNamed(context, TransactionsScreen.routeName);
      },
      child: isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  foregroundColor: Colors.black,
                  title: const Text(
                    "Graphs",
                    style: TextStyle(color: Colors.black),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                drawer: const MyDrawer(),
                body: graphProvider.dataMap.isEmpty
                    ? Center(
                        child: Text(
                          "Nothing to display",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      )

                    ///WE WILL PASS THE MAP  TO THE PIECHART
                    : Padding(
                        padding: const EdgeInsets.only(top: 50, left: 25),
                        child: Column(
                          children: [
                            graphProvider.dataMap.isEmpty
                                ? Container()
                                : SizedBox(
                                    width: 350,
                                    child: PieChart(
                                      centerTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      centerText:
                                          "Total\n \u{20B9} ${graphProvider.total} ",
                                      ringStrokeWidth: 50,
                                      chartRadius: 250,
                                      dataMap: graphProvider.dataMap,
                                      chartType: ChartType.ring,
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                        chartValueBackgroundColor:
                                            Colors.transparent,
                                        showChartValues: false,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 30),
                            Expanded(
                              child: ListView.builder(
                                itemCount: keyList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5, right: 10),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                              categoryProvider
                                                  .expenseCategoriesList[index]
                                                  .imageUrl,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            keyList[index],
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: 100,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "\u{20B9} ${graphProvider.dataMap[keyList[index]]}",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    "\u{20B9} ${graphProvider.total}",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }
}
