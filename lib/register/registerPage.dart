import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:tcbapp/home/firstPage.dart';
import "package:intl/intl.dart";
import 'package:tcbapp/otp/OtpPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController idCard = TextEditingController();
  final TextEditingController birthDate = TextEditingController();
  final TextEditingController phone = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _afterselectDate(BuildContext context) async {
    final selectedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: [],
    );

    if (selectedDates != null && selectedDates.isNotEmpty) {
      // แปลงวันที่เป็น String และใส่ใน TextFormField
      final selectedDate = selectedDates.first;
      final formattedDate = _dateFormat.format(selectedDate!);
      birthDate.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00CFCF), Color(0xFF00E0D0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  'ลงทะเบียน',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'กรุณาระบุข้อมูลเบื้องต้นเพื่อลงทะเบียนเข้าใช้ระบบ',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                buildInputField(
                  controller: name,
                  icon: Icons.person,
                  hint: 'ชื่อ',
                ),
                buildInputField(
                  controller: surname,
                  icon: Icons.person,
                  hint: 'นามสกุล',
                ),
                buildInputField(
                  controller: idCard,
                  icon: Icons.credit_card,
                  hint: 'เลขบัตรประชาชน 13 หลัก',
                ),
                buildInputField(
                  controller: birthDate,
                  icon: Icons.calendar_today,
                  hint: '000-00-00',
                ),
                buildInputField(
                  controller: phone,
                  icon: Icons.phone,
                  hint: 'เบอร์โทร',
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Otppage()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      'ลงทะเบียน/รับรหัส OTP',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    // required String label,
    required IconData icon,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          // labelText: label,
          hintText: hint ?? '',
          prefixIcon: controller == birthDate
              ? GestureDetector(
                  onTap: () {
                    _afterselectDate(context);
                  },
                  child: Icon(icon, color: Colors.grey))
              : Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
