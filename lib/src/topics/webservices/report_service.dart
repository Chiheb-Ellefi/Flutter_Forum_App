import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/report_model/report_model.dart';
import 'package:my_project/main.dart';

class ReportService {
  Future<Map<String, List>?> getReportReasons(
      List<dynamic>? dataList, List<dynamic> isSelectedList) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(reportsCollection)
        .doc('reportsData')
        .get();
    final data = snapshot.data() as Map<String, dynamic>;
    dataList = (data['data'] as List<dynamic>).cast<String>();
    isSelectedList = List.generate(dataList.length,
        (index) => false); // Initialize isSelectedList with the correct length
    Map<String, List> myData = {'data': dataList, 'isSelected': isSelectedList};
    return myData;
  }

  Future<void> sendReport(
      {context, reasons, reported, reporter, collection}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      ReportModel report =
          ReportModel(reasons: reasons, reported: reported, reporter: reporter);

      await FirebaseFirestore.instance
          .collection(collection)
          .add(report.toMap());
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
