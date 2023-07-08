import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/report_model/report_model.dart';
import 'package:my_project/main.dart';

class ReportAlert extends StatefulWidget {
  const ReportAlert(
      {Key? key,
      required this.reported,
      required this.reporter,
      required this.collection})
      : super(key: key);
  final String? reporter;
  final String? reported;
  final String collection;

  @override
  State<ReportAlert> createState() => _ReportAlertState();
}

class _ReportAlertState extends State<ReportAlert> {
  List<String>? dataList;
  List<bool> isSelectedList = [];
  List reasons = [];

  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    waitForData();
  }

  Future<void> getReportReasons() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(reportsCollection)
        .doc('reportsData')
        .get();
    final data = snapshot.data() as Map<String, dynamic>;
    dataList = (data['data'] as List<dynamic>).cast<String>();
    isSelectedList = List.generate(dataList!.length, (index) => false);
  }

  Future<void> sendReport() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      ReportModel report = ReportModel(
          reasons: reasons,
          reported: widget.reported,
          reporter: widget.reporter);

      await FirebaseFirestore.instance
          .collection(widget.collection)
          .add(report.toMap());
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> waitForData() async {
    if (!dataLoaded) {
      await getReportReasons();
      if (mounted) {
        setState(() {
          dataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Report this topic',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 300,
        width: 300,
        child: dataLoaded
            ? ListView.separated(
                shrinkWrap: true,
                itemCount: dataList!.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final isSelected = isSelectedList[index];
                  final myColor = isSelected ? myBlue1 : Colors.black87;
                  final myBorderColor =
                      isSelected ? myBlue1 : Colors.transparent;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        isSelectedList[index] = !isSelected;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: myBorderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          dataList![index],
                          style: TextStyle(color: myColor),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              for (int i = 0; i < isSelectedList.length; i++) {
                if (isSelectedList[i]) {
                  reasons.add(dataList![i]);
                }
              }
              await sendReport();
            },
            style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
            child: const Text('Send report'),
          ),
        ),
      ],
    );
  }
}
