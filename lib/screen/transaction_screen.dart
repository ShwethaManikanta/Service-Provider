import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:serviceprovider/common/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:serviceprovider/common/utils.dart';
import 'package:serviceprovider/service/transaction_api_provider.dart';
import 'package:serviceprovider/service/translation_api_provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    if (context.read<TranslationAPIProvider>().translationModel == null) {
      context.read<TranslationAPIProvider>().getTranslationList();
    }
    if (context.read<TransactionListAPIProvider>().transactionModel == null) {
      context.read<TransactionListAPIProvider>().getTransactionList();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactionAPIProvider =
        Provider.of<TransactionListAPIProvider>(context);
    final translationAPIProvider = Provider.of<TranslationAPIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "${translationAPIProvider.translationModel!.languageDetails![58]}",
          style: CommonStyles.whiteText16BoldW500(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 20),
        child: transactionAPIProvider.ifLoading ||
                transactionAPIProvider.transactionModel == null
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.5,
                ),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: transactionAPIProvider
                    .transactionModel!.transactionList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Neumorphic(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactionAPIProvider.transactionModel!
                                  .transactionList![index].date!,
                              style: CommonStyles.black12(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Neumorphic(
                              style: NeumorphicStyle(color: Colors.white),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Posted ID :  ${transactionAPIProvider.transactionModel!.transactionList![index].id}",
                                            style: CommonStyles.black13(),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Job Name     : ${transactionAPIProvider.transactionModel!.transactionList![index].postDetails!.jobTitle}",
                                            style: CommonStyles.black13(),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Job Location : ${transactionAPIProvider.transactionModel!.transactionList![index].postDetails!.address}",
                                            style: CommonStyles.black13(),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹  ${transactionAPIProvider.transactionModel!.transactionList![index].postDetails!.total}",
                                        style: CommonStyles.greeen15bold(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),

      /*Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 20),
          child: transactionAPIProvider.ifLoading ||
                  transactionAPIProvider.transactionModel == null
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 0.5,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: transactionAPIProvider
                      .transactionModel!.transactionList!.length,
                  itemBuilder: (context, indext) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 15,
                      shadowColor: Colors.lightBlue,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              transactionAPIProvider.transactionModel!
                                  .transactionList![indext].jobTitle!,
                              style: CommonStyles.black1654thin(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![34]}    :  ",
                                        style: CommonStyles.black13(),
                                      ),
                                      Text(
                                        transactionAPIProvider.transactionModel!
                                            .transactionList![indext].userName!,
                                        style: CommonStyles.blue14900(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![5]}  :  ",
                                        style: CommonStyles.black13(),
                                      ),
                                      Flexible(
                                        child: Text(
                                          transactionAPIProvider
                                              .transactionModel!
                                              .transactionList![indext]
                                              .mobile!,
                                          style: CommonStyles.blue14900(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Order ID  :  ",
                                        style: CommonStyles.black13(),
                                      ),
                                      Text(
                                        transactionAPIProvider.transactionModel!
                                            .transactionList![indext].id!,
                                        style: CommonStyles.blue14900(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        "${translationAPIProvider.translationModel!.languageDetails![46]}  :  ",
                                        style: CommonStyles.black13(),
                                      ),
                                      Text(
                                        "₹  ${transactionAPIProvider.transactionModel!.transactionList![indext].amount!}",
                                        style: CommonStyles.blue14900(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${translationAPIProvider.translationModel!.languageDetails![20]} :",
                                  style: CommonStyles.black13(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    transactionAPIProvider.transactionModel!
                                        .transactionList![indext].description!,
                                    style: CommonStyles.blue14900(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),*/
    );
  }
}
