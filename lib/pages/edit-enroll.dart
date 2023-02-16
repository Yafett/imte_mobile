import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imte_mobile/pages/dashboard-page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:http/http.dart' as http;

import '../shared/theme.dart';
import 'News/news-detail-page.dart';
import 'package:dio/dio.dart';

XFile? imageFile;

class EditEnrollPage extends StatefulWidget {
  String? enrollId;
  String? unit;
  String? period;
  String? instrument;
  String? grade;
  String? teacher;
  String? payment;

  EditEnrollPage(
      {super.key,
      this.enrollId,
      this.unit,
      this.period,
      this.instrument,
      this.grade,
      this.teacher,
      this.payment});

  @override
  State<EditEnrollPage> createState() => _EditEnrollPageState();
}

class _EditEnrollPageState extends State<EditEnrollPage> {
  final dio = Dio();

  final _periodController = TextEditingController();
  final _unitController = TextEditingController();
  var _majorVal;
  var _unitVal;
  var _gradeVal;
  var _periodVal;
  var _paymentVal;

  var img;
  var teacherId;
  var unitIdentify;
  var _teacherVal;
  var photoName;
  var unitList = [];
  var gradePiano = [
    'CFK 1',
    'CFK 2',
    'JC 1',
    'JC 2',
    'JC 3',
    'JC 4',
    'JC 5 - Pop Jazz',
    'JC 5 - Classical',
    'JC 6 - Pop Jazz',
    'JC 6 - Classical',
  ];
  var majorList = [];
  var gradeList = [];
  var gradeListOld = [];
  var teacherList = [];
  var paymentMethod = ['Gallery', 'Camera'];

  bool unitSelected = false;

  final picker = ImagePicker();
  late Future<PickedFile?> pickedFile = Future.value(null);

  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _fetchUnit();
    _fetchMajor();
    _fetchGrade();
    _fetchPeriod();
    _majorVal = widget.instrument;
    _gradeVal = widget.grade;
    _teacherVal = widget.teacher;
    _paymentVal = widget.payment;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF0F0F0),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 37, 37, 37),
              size: 25,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // _getFromGallery();
                // _openGallery();
                _editEnrollData(img);
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Chip(
                  backgroundColor: Color(0xffAE2329),
                  label: Text('edit',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      )),
                ),
              ),
            ),
          ],
          title: Text('Edit Enroll',
              style:
                  blackTextStyle.copyWith(fontSize: 20, fontWeight: semiBold)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                _unitField(),
                _periodField(),
                _majorField(),
                _gradeField(),
                _paymentField(),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _unitField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! instruments
      Text('Unit', style: TextStyle(fontSize: 16)),
      SizedBox(height: 5),
      Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          readOnly: true,
          controller: _unitController,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Unit',
              hintStyle: greyTextStyle),
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ]);
  }

  Widget _periodField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! instruments
      Text('Period', style: TextStyle(fontSize: 16)),
      SizedBox(height: 5),
      Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          readOnly: true,
          controller: _periodController,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Period',
              hintStyle: greyTextStyle),
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ]);
  }

  Widget _majorField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! instruments
      Text('Instrument', style: TextStyle(fontSize: 16)),
      SizedBox(height: 5),
      Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        width: MediaQuery.of(context).size.width,
        child: DropdownButton(
          underline: SizedBox(),
          isExpanded: true,
          hint: Text('Select Your Instruments'),
          items: majorList.map((item) {
            return DropdownMenuItem(
              value: item['id'].toString(),
              child: Text(item['major'].toString()),
            );
          }).toList(),
          onChanged: (newVal) {
            print(newVal);
            setState(() {
              _majorVal = newVal;
            });
            _setMajorList(_majorVal);
          },
          value: _majorVal,
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ]);
  }

  Widget _gradeField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! instruments
      Text('Grade', style: TextStyle(fontSize: 16)),
      SizedBox(height: 5),
      Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        width: MediaQuery.of(context).size.width,
        child: DropdownButton(
          underline: SizedBox(),
          isExpanded: true,
          hint: Text('Select Your Grade'),
          items: gradeList.map((item) {
            return DropdownMenuItem(
              value: item['id'].toString(),
              child: Text(item['grade'].toString()),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _gradeVal = newVal;
            });
          },
          value: _gradeVal,
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ]);
  }

  Widget _paymentField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! receipt
      Text('Payment Receipt', style: TextStyle(fontSize: 16)),
      SizedBox(height: 10),
      (_paymentVal == null)
          ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _getImage('Camera');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kBlackColor,
                        )
                        // color: Color(0xffAE2329),
                        ),
                    margin: EdgeInsets.only(right: 10),
                    child: Text('Take Photo',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _getImage('Gallery');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kBlackColor,
                        )
                        // color: Color(0xffAE2329),
                        ),
                    margin: EdgeInsets.only(right: 15),
                    child: Text('Choose from Gallery',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        )),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${_paymentVal}',
                        hintStyle: blackTextStyle),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _getImage('Camera');
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kBlackColor,
                            )
                            // color: Color(0xffAE2329),
                            ),
                        margin: EdgeInsets.only(right: 10),
                        child: Text('Take Photo',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _getImage('Gallery');
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kBlackColor,
                            )
                            // color: Color(0xffAE2329),
                            ),
                        margin: EdgeInsets.only(right: 15),
                        child: Text('Choose from Gallery',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: Image.network(
                    'https://adm.imte.education/img/verifEnroll/${_paymentVal.toString()}',
                    fit: BoxFit.contain,
                  ),
                  color: Colors.blue,
                ),
                const SizedBox(height: 0),
              ],
            ),
    ]);
  }

  _getImage(method) async {
    if (method == 'Gallery') {
      imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        _paymentVal = imageFile!.name.toString();
      });
    } else if (method == 'Camera') {
      imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

      setState(() {
        _paymentVal = imageFile!.name.toString();
      });
    }
  }

  _fetchUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await dio.get('https://adm.imte.education/api/unit');

    // String? unit = await prefs.getString('unit');
    String? unit = widget.unit;

    print('dance : ' + response.data.length.toString());

    for (var a = 0; a < response.data.length; a++) {
      if (response.data[a]['id'].toString() == widget.unit) {
        if (mounted) {
          setState(() {
            unitList.add(response.data[a]);
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _unitController.text = unitList[0]['unit_name'].toString();
      });
    }

    print('codplay ${unitList[0]['unit_name'].toString()}');

    teacherList = [];

    if (mounted) {
      setState(() {
        unitSelected = true;
      });
    }
  }

  _fetchPeriod() async {
    final response = await dio.get('https://adm.imte.education/api/period');

    if (mounted) {
      setState(() {
        _periodController.text = response.data[0]['period_name'];
        _periodVal = response.data[0]['id'].toString();
      });
    }
  }

  _fetchMajor() async {
    final response = await dio.get('https://adm.imte.education/api/major');

    for (var a = 0; a < response.data.length; a++) {
      if (mounted) {
        setState(() {
          majorList.add(response.data[a]);
        });
      }
    }
  }

  _fetchGrade() async {
    final response = await dio.get('https://adm.imte.education/api/grade');

    for (var a = 0; a < response.data.length; a++) {
      if (mounted) {
        setState(() {
          gradeList.add(response.data[a]);
          gradeListOld.add(response.data[a]);
        });
      }
    }
  }

  _setEnrollData() {
    //  'id': id.toString(),
    //       'unit': unitList[0]['id'].toString(),
    //       'period': _periodVal.toString(),
    //       'major': _majorVal.toString(),
    //       'grade': _gradeVal.toString(),
    //       'teacher_id': _teacherVal.toString(),
    //       'payment': _paymentVal.toString(),

    _periodVal = widget.period;
    _majorVal = widget.instrument;
    _gradeVal = widget.grade;
    _teacherVal = widget.teacher;
    _paymentVal = widget.payment;
  }

  _editEnrollData(file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String fileName = file.path.split('/').last;
    var token = prefs.getString('token');
    String? unit = await prefs.getString('unit');
    String? id = await prefs.getString('tabUserId');

    print('id : ' + id.toString());
    print('unit : ' + unit.toString());
    print('period : ' + _periodVal.toString());
    print('major : ' + _majorVal.toString());
    print('grade : ' + _gradeVal.toString());
    print('payment : ' + _paymentVal.toString());
    final failSnackBar = SnackBar(
      content: const Text('Theres something wrong with ur data'),
      backgroundColor: (Colors.black),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );
    final successSnackBar = SnackBar(
      content: const Text('Your Enrollment has been Changed'),
      backgroundColor: (Colors.black),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );
    final existSnackBar = SnackBar(
      content: const Text('All field must be filled'),
      backgroundColor: (Colors.black),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );
    if (_paymentVal.toString() == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(failSnackBar);
    } else {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "token ${token}";
      dio.options.headers["Accept"] = "*/*";
      final response = await dio.post(
        'https://adm.imte.education/index.php/api/enroll/update/2',
        data: FormData.fromMap({
          'enroll_id': widget.enrollId.toString(),
          'tab_user_id': id.toString(),
          'tab_unit_id': unit.toString(),
          'tab_period_id': _periodVal.toString(),
          'tab_major_id': _majorVal.toString(),
          'tab_grade_id': _gradeVal.toString(),
          'payment': _paymentVal.toString(),
        }),
      );

      if (response.statusCode! == 200) {
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(failSnackBar);
      }

      print('response : ' + response.data.toString());
    }
  }

  _setMajorList(val) {
    if (val.toString() == '1') {
      if (mounted) {
        setState(() {
          gradeList = gradeListOld;
        });
      }
      gradeList = gradeListOld;
      gradeList.removeWhere((item) => item['grade'] == 'JC 5');
      gradeList.removeWhere((item) => item['grade'] == 'JC 6');

      print(gradeListOld.length.toString());
    } else {
      if (mounted) {
        setState(() {
          gradeList = gradeListOld;
        });
      }
      gradeList = gradeListOld;
      gradeList.removeWhere((item) => item['grade'] == 'JC 5 - Pop Jazz');
      gradeList.removeWhere((item) => item['grade'] == 'JC 6 - Pop Jazz');
      gradeList.removeWhere((item) => item['grade'] == 'JC 5 - Classical');
      gradeList.removeWhere((item) => item['grade'] == 'JC 6 - Classical');
    }
  }
}
