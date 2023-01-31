import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';

import '../shared/theme.dart';
import 'News/news-detail-page.dart';
import 'package:dio/dio.dart';

XFile? imageFile;

class AddEnrollPage extends StatefulWidget {
  const AddEnrollPage({super.key});

  @override
  State<AddEnrollPage> createState() => _AddEnrollPageState();
}

class _AddEnrollPageState extends State<AddEnrollPage> {
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
  var majorList = [];
  var gradeList = [];
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
                _sendEnrollData(img);
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Chip(
                  backgroundColor: Color(0xffAE2329),
                  label: Text('enroll',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      )),
                ),
              ),
            ),
          ],
          title: Text('Add Enroll',
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
                unitSelected == true ? _teacherField() : Container(),
                _paymentField(),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _unitField() {
    // return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   // ! instruments
    //   Text('Unit', style: TextStyle(fontSize: 16)),
    //   SizedBox(height: 5),
    //   Container(
    //     margin: EdgeInsets.only(top: 5),
    //     padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.grey),
    //       borderRadius: BorderRadius.all(Radius.circular(12)),
    //     ),
    //     width: MediaQuery.of(context).size.width,
    //     child: DropdownButton(
    //       underline: SizedBox(),
    //       isExpanded: true,
    //       hint: Text('Select Your Unit'),
    //       items: unitList.map((item) {
    //         return DropdownMenuItem(
    //           value: item['id'].toString(),
    //           child: Text(item['unit_name'].toString()),
    //         );
    //       }).toList(),
    //       onChanged: (newVal) {
    //         print(newVal);

    //         setState(() {
    //           unitSelected = false;
    //           _unitVal = newVal;
    //           teacherList = [];
    //           _fetchTeacher(newVal);
    //         });
    //       },
    //       value: _unitVal,
    //     ),
    //   ),
    //   SizedBox(
    //     height: 15,
    //   ),
    // ]);
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
            setState(() {
              _majorVal = newVal;
            });
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

  Widget _teacherField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! instruments
      Text('Teacher', style: TextStyle(fontSize: 16)),
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
          hint: Text('Select Your Teacher'),
          items: teacherList.map((item) {
            return DropdownMenuItem(
              value: item['id'].toString().capitalize,
              child: Text(capitalize(
                      '${item['first_name'].toString().toLowerCase()}') +
                  ' ' +
                  '${item['last_name'].toString().toLowerCase().capitalize}'),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _teacherVal = newVal;
              print(newVal.toString());
            });
          },
          value: _teacherVal,
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ]);
  }

  Widget _paymentField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ! instruments
      Text('Payment Receipt', style: TextStyle(fontSize: 16)),
      SizedBox(height: 5),
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
                Container(
                  child: Image.file(
                    File(imageFile!.path),
                    fit: BoxFit.contain,
                  ),
                  color: Colors.blue,
                )
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

    String? unit = await prefs.getString('unit');

    if (unit == '1') {
      _unitController.text = 'Alam Sutera';
    } else if (unit == '2') {
      _unitController.text = 'Gang Pinggir';
    } else if (unit == '3') {
      _unitController.text = 'Madiun';
    } else if (unit == '4') {
      _unitController.text = 'Puri Anjasmoro';
    } else if (unit == '5') {
      _unitController.text = 'Solo';
    } else if (unit == '6') {
      _unitController.text = 'Kudus';
    } else if (unit == '7') {
      _unitController.text = 'Yogyakarta';
    } else if (unit == '8') {
      _unitController.text = 'Kutoarjo';
    } else if (unit == '9') {
      _unitController.text = 'Purwodadi';
    } else if (unit == '10') {
      _unitController.text = 'Surabaya';
    }

    for (var a = 0; a < response.data.length; a++) {
      for (var a = 0; a < response.data.length; a++) {
        if (mounted) {
          setState(() {
            unitList.add(response.data[a]);
          });
        }
      }
    }

    teacherList = [];
    _fetchTeacher(unit);

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
        });
      }
    }

    print(gradeList.toString());
  }

  _fetchTeacher(id) async {
    var unitId = [];

    final getUnit = await dio.get('https://adm.imte.education/api/unit');

    print(getUnit.data.length.toString());
    for (var i = 0; i < getUnit.data.length; i++) {
      if (getUnit.data[i]['id'].toString() == id.toString()) {
        unitId.add(getUnit.data[i]['unit_name']);
      }
    }

    final response = await dio.get('https://adm.imte.education/api/teacher');

    for (var a = 0; a < response.data.length; a++) {
      if (response.data[a]['unit_name'].toString() == unitId[0].toString()) {
        if (mounted) {
          setState(() {
            teacherList.add(response.data[a]);
          });
        }
      }

      if (mounted) {
        setState(() {
          unitSelected = true;
        });
      }
    }
  }

  _sendEnrollData(file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String fileName = file.path.split('/').last;
    var token = prefs.getString('token');

    // print('unit : ' + _unitVal.toString());
    // print('period : ' + _periodVal.toString());
    // print('major : ' + _majorVal.toString());
    // print('grade : ' + _gradeVal.toString());
    // print('teacher_id : ' + _teacherVal.toString());
    // print('payment : ' + _paymentVal.toString());
    final failSnackBar = SnackBar(
      content: const Text('All field must be filled!'),
      backgroundColor: (Colors.black),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );
    final successSnackBar = SnackBar(
      content: const Text('Your Enrollment has been sent'),
      backgroundColor: (Colors.black),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );

    if (_paymentVal.toString() == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(failSnackBar);
    } else {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "token ${token}";
      final response =
          await dio.post('https://adm.imte.education/api/enroll/store', data: {
        'id': '',
        'unit': _unitVal.toString(),
        'period': _periodVal.toString(),
        'major': _majorVal.toString(),
        'grade': _gradeVal.toString(),
        'teacher_id': _teacherVal.toString(),
        'payment': _paymentVal.toString(),
      }, options: Options(validateStatus: (status) {
        if (status! > 200) {
          ScaffoldMessenger.of(context).showSnackBar(failSnackBar);
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        }

        return status > 200;
      }));

      print('response : ' + response.data.toString());
    }
  }
}
