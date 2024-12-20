import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tcbapp/WidgetHub/dialog/dialogyes.dart';
import 'package:tcbapp/WidgetHub/dialog/loadingDialog.dart';
import 'package:tcbapp/constants.dart';
import 'package:tcbapp/home/widgets/CardItem.dart';
import 'package:tcbapp/notifications/notificationsPage.dart';
import 'package:tcbapp/register/registerPage.dart';
import 'package:tcbapp/service/ProjectController.dart';
import 'package:tcbapp/utils/apiException.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
    });
  }

  Future getapi() async {
    try {
      LoadingDialog.open(context);
      await context.read<ProjectController>().getPatientHistory();
      await context.read<ProjectController>().getMedicalHistorys();
      if (!mounted) return;
      LoadingDialog.close(context);
    } on ClientException catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => Dialogyes(
          title: 'แจ้งเตือน',
          description: '$e',
          pressYes: () {
            Navigator.pop(context, true);
          },
          bottomNameYes: 'ตกลง',
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      // LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => Dialogyes(
          title: 'แจ้งเตือน',
          description: '$e',
          pressYes: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RegisterPage();
                },
              ),
            );
          },
          bottomNameYes: 'ตกลง',
        ),
      );
    }
  }

  String formatNationalID(String id) {
    if (id.length < 3) {
      return id;
    }
    return "${id.substring(0, 3)}******";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor3,
      appBar: AppBar(
        shadowColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ยินดีต้อนรับ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            )
          ],
        ),
        backgroundColor: kBackgroundColor,
        elevation: 5,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child: Image.asset(
              'assets/icons/logo MOPH.png',
              scale: 10,
            ),
          ),
        ),
      ),
      body: Consumer<ProjectController>(
        builder: (BuildContext context, controller, child) {
          final medicalHistorys = controller.medicalHistorys;
          final patientHistory = controller.patientHistory;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.12,
                width: double.infinity,
                color: kBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 15),
                              Text(
                                'ชื่อ : ',
                                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                patientHistory?.full_name ?? '-',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              SizedBox(width: 15),
                              Text(
                                'เพศ : ',
                                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                patientHistory?.sex_name ?? '-',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              SizedBox(width: 15),
                              Text(
                                'เลข ID : ',
                                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formatNationalID(
                                  patientHistory?.cid ?? '-',
                                ),
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //SizedBox(height: 10),
              Container(
                height: size.height * 0.07,
                width: double.infinity,
                color: kBackgroundColor2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'รายการนัดหมาย : ',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ไม่มี',
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height * 0.07,
                width: double.infinity,
                color: kBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'ประวัติการรักษา : ',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: medicalHistorys!.length,
                  itemBuilder: (context, index) {
                    final item = cardItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: CardItem(
                        date: medicalHistorys[index].diagnosis_date ?? '-',
                        hospital: medicalHistorys[index].hospital_name ?? '',
                        diagnosis: medicalHistorys[index].icd10_text ?? '',
                        size: size,
                        medicalHistorys: medicalHistorys[index].treatments,
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
