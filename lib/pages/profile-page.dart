// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:imte_mobile/bloc/edit-profile-bloc/editProfile_bloc.dart';
import 'package:imte_mobile/bloc/get-profile_bloc/getProfile_bloc.dart';
import 'package:imte_mobile/models/profile-model.dart';
import 'package:imte_mobile/pages/history-page.dart';
import 'package:imte_mobile/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String enableBack;

  const ProfilePage({Key? key, required this.enableBack}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController genderController = new TextEditingController();
  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController birthController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController waliController = new TextEditingController();
  TextEditingController noWaliController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController smsController = new TextEditingController();
  TextEditingController emailOtpController = new TextEditingController();

  GetProfileBloc _getProfileBloc = new GetProfileBloc();
  EditProfileBloc _editProfileBloc = new EditProfileBloc();

  var profile;
  bool buttonLoading = false;
  var photoName = '';
  bool loading = true;

  String dfirst = '';
  String dlast = '';
  String dgender = '';
  String dplace = '';
  String dbirth = '';
  String dmobile = '';
  String dwali = '';
  String dnowali = '';
  String daddress = '';
  String dcity = '';
  int did = 0;

  var genderList = ['Laki-laki', 'Perempuan'];
  var genderval;

  @override
  void initState() {
    super.initState();
    _getValData();
    _getProfileBloc.add(GetProfileList());
  }

  otpEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String API_URL = 'https://adm.imte.education/api/user/sendVerifEmail';

    String emailOTP = prefs.getString('emails').toString();

    final response = await http.post(Uri.parse(API_URL),
        headers: {'Accept': 'application/json'}, body: {'id': did.toString()});

    final data = await json.decode(response.body);

    print(data);
  }

  sendOtpEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String API_URL = 'https://adm.imte.education/api/user/verifyOtp';

    String emailOTP = prefs.getString('emails').toString();

    final response = await http.post(Uri.parse(API_URL), headers: {
      'Accept': 'application/json'
    }, body: {
      'id': did.toString(),
      'otp': emailOtpController.text,
    });

    final data = await json.decode(response.body);

    Navigator.pop(context);
    var snackBar = SnackBar(content: Text(data['message']));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      emailOtpController.text = '';
    });

    print(data);
  }

  // ! Request OTP Wa
  otpWa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String API_URL = 'https://adm.imte.education/api/user/waVerifRequest';

    String emailOTP = prefs.getString('emails').toString();

    final response = await http.post(Uri.parse(API_URL),
        headers: {'Accept': 'application/json'}, body: {'id': did.toString()});

    final data = await json.decode(response.body);

    print(data);
  }

  sendOtpWa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String API_URL = 'https://adm.imte.education/api/user/waVerifRequest';

    String emailOTP = prefs.getString('emails').toString();

    final response = await http.post(Uri.parse(API_URL), headers: {
      'Accept': 'application/json'
    }, body: {
      'id': did.toString(),
      'otp': '',
    });

    final data = await json.decode(response.body);

    print(data);
  }

  // ! Request OTP SMS
  otpSms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String API_URL = 'https://adm.imte.education/api/user/mobileotp';

    String emailOTP = prefs.getString('emails').toString();

    final response = await http.post(Uri.parse(API_URL),
        headers: {'Accept': 'application/json'}, body: {'id': did.toString()});

    final data = await json.decode(response.body);

    print(data);
  }

  sendOtpSms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String API_URL = 'https://adm.imte.education/api/user/verifyOtp';

    String emailOTP = prefs.getString('emails').toString();

    final response = await http.post(Uri.parse(API_URL), headers: {
      'Accept': 'application/json'
    }, body: {
      'id': did.toString(),
      'otp': smsController.text,
    });

    final data = await json.decode(response.body);

    Navigator.pop(context);
    var snackBar = SnackBar(content: Text(data['message']));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      smsController.text = '';
    });

    print(data);
  }

  // ! Modal OTP E-Mail
  showOTPEmail(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Activation',
                    style: blackTextStyle.copyWith(
                        fontSize: 20, fontWeight: semiBold)),
                GestureDetector(
                    child: Icon(Icons.close),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            Divider(thickness: 2, height: 30),
            Text(
              'Please Input the OTP',
              style: greyTextStyle.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            TextFormField(
              // controller: emailOtpController,
              style: greyTextStyle.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Input Here..',
                border: OutlineInputBorder(
                  borderRadius: radiusNormal,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: radiusNormal,
                ),
              ),
            ),
            Divider(thickness: 2, height: 30),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Verified Later', style: blackTextStyle),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendOtpEmail();
                  },
                  child: Text('Resend OTP', style: whiteTextStyle),
                ),
              ],
            ),
            Text('Email is sent, Please Check your Email for OTP',
                style: greyTextStyle.copyWith(fontSize: 12)),
          ],
        ),
      ),
      actions: [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // ! Modal OTP Wa
  showOTPWa(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Activation',
                    style: blackTextStyle.copyWith(
                        fontSize: 20, fontWeight: semiBold)),
                GestureDetector(
                    child: Icon(Icons.close),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            Divider(thickness: 2, height: 30),
            Text(
              'Please Input the OTP',
              style: greyTextStyle.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            TextFormField(
              // controller: smsController,
              style: greyTextStyle.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Input Here..',
                border: OutlineInputBorder(
                  borderRadius: radiusNormal,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: radiusNormal,
                ),
              ),
            ),
            Divider(thickness: 2, height: 30),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Verified Later', style: blackTextStyle),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Resend OTP', style: whiteTextStyle),
                ),
              ],
            ),
            Text('Email is sent, Please Check your Whatsapp for OTP',
                style: greyTextStyle.copyWith(fontSize: 12)),
          ],
        ),
      ),
      actions: [],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showOTPSms(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Activation',
                    style: blackTextStyle.copyWith(
                        fontSize: 20, fontWeight: semiBold)),
                GestureDetector(
                    child: Icon(Icons.close),
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            Divider(thickness: 2, height: 30),
            Text(
              'Please Input the OTP',
              style: greyTextStyle.copyWith(fontSize: 12),
            ),
            SizedBox(height: 10),
            TextFormField(
              // controller: smsController,
              style: greyTextStyle.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Input Here..',
                border: OutlineInputBorder(
                  borderRadius: radiusNormal,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: radiusNormal,
                ),
              ),
            ),
            Divider(thickness: 2, height: 30),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Verified Later', style: blackTextStyle),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(smsController.text);

                    sendOtpSms();
                  },
                  child: Text('Send OTP', style: whiteTextStyle),
                ),
              ],
            ),
            Text('SMS is sent, Please Check your Message for OTP',
                style: greyTextStyle.copyWith(fontSize: 12)),
          ],
        ),
      ),
      actions: [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProfilePage(context);
  }

  Widget _buildProfilePage(BuildContext context) {
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
          actions: [_buildEditButton()],
          title: Text(
            'My Profile',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _buildEditProfileForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      bloc: _editProfileBloc,
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          Navigator.pushNamed(context, '/dashboard');
        } else if (state is EditProfileError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        if (state is EditProfileInitial) {
          print(state);
          return InkWell(
            onTap: () {
              _editProfileBloc.add(Edit(
                firstnameController.text,
                lastnameController.text,
                genderController.text,
                placeController.text,
                birthController.text,
                mobileController.text,
                addressController.text,
                waliController.text,
                cityController.text,
                noWaliController.text,
              ));
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Chip(
                backgroundColor: kBlueColor,
                label: Text('save',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    )),
              ),
            ),
          );
        } else if (state is EditProfileLoading) {
          print(state);

          return InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Chip(
                backgroundColor: kBlueColor,
                label: Text(
                  'Loading...',
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
          );
        } else {
          print(state);

          return InkWell(
            onTap: () {
              _editProfileBloc.add(Edit(
                firstnameController.text,
                lastnameController.text,
                genderController.text,
                placeController.text,
                birthController.text,
                mobileController.text,
                addressController.text,
                waliController.text,
                cityController.text,
                noWaliController.text,
              ));
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Chip(
                backgroundColor: kBlueColor,
                label: Text('save',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    )),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildEditProfileForm(BuildContext context) {
    return BlocBuilder<GetProfileBloc, GetProfileState>(
      bloc: _getProfileBloc,
      builder: (context, state) {
        if (state is GetProfileLoaded) {
          GetProfile profile = state.profileModel;
          _setController(profile);
          return Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              SizedBox(height: 10),
              Container(
                color: Color(0xFFF0F0F0),
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _editProfilePic(),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        "Put your best profile picture!.",
                        style: blackTextStyle.copyWith(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50),

              // ! Student

              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Student',
                    style: blackTextStyle.copyWith(
                        fontSize: 20, fontWeight: semiBold))
              ]),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Name
                  _editName(),
                  SizedBox(height: 30),

                  //  Email
                  _editEmail(context),
                  SizedBox(height: 30),

                  //  Gender
                  Row(
                    children: [
                      Text('Gender '),
                      Text('*', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  _editGender(),
                  SizedBox(height: 30),

                  //  Place
                  _editPlace(),
                  SizedBox(height: 30),

                  //  Birth
                  _editBirth(context),
                  SizedBox(height: 30),

                  //   Address
                  _editAddress(),
                  SizedBox(height: 30),

                  //   City
                  _editCity(),
                  SizedBox(height: 30),

                  //   Mobile
                  _editMobile(context),
                  SizedBox(height: 40),

                  // ! Guardian
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text('Guardian',
                        style: blackTextStyle.copyWith(
                            fontSize: 20, fontWeight: semiBold))
                  ]),
                  SizedBox(height: 30),

                  // Name
                  _editGuardName(),
                  SizedBox(height: 30),

                  // Guardian Mobile
                  _editGuardMobile(),
                  SizedBox(height: 30),
                ],
              ),
            ]),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _editGuardMobile() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: noWaliController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g 123xxxxxx',
          label: Row(
            children: [
              Text('Mobile '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {},
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editGuardName() {
    return TextFormField(
      controller: waliController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g., John Doe',
          label: Row(
            children: [
              Text('Name '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value!.length < 0 || value.contains('@'))
            ? "Can't be empty"
            : null;
      },
    );
  }

  Widget _editMobile(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: mobileController,
      decoration: InputDecoration(
          suffix: InkWell(
            onTap: () {
              otpSms();

              showOTPSms(context);
            },
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g 123xxxxxx',
          label: Row(
            children: [
              Text('Mobile '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editCity() {
    return TextFormField(
      controller: cityController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g city',
          label: Row(
            children: [
              Text('City '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editAddress() {
    return TextFormField(
      controller: addressController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g city',
          label: Row(
            children: [
              Text('Address '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editBirth(context) {
    return TextFormField(
      readOnly: true,
      controller: birthController,
      decoration: InputDecoration(
          suffix: IconButton(
            icon: Icon(
              Icons.edit_calendar,
              size: 20,
            ),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                print(
                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(
                    formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  birthController.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {
                print("Date is not selected");
              }
            },
          ),
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g city',
          label: Row(
            children: [
              Text('Birth Date '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editPlace() {
    return TextFormField(
      controller: placeController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g city',
          label: Row(
            children: [
              Text('Place '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {},
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editGender() {
    return DropdownButton(
      underline:
          Container(height: 2, color: Color.fromARGB(255, 209, 209, 209)),
      isExpanded: true,
      hint: Text('Select your gender'),
      items: genderList.map((item) {
        return DropdownMenuItem(
          value: item.toString(),
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          genderval = newVal;
        });
      },
      value: genderval,
    );
  }

  Widget _editEmail(context) {
    return TextFormField(
      readOnly: true,
      controller: emailController,
      decoration: InputDecoration(
          suffix: InkWell(
            onTap: () {
              otpEmail();

              showOTPEmail(context);
            },
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g., JohnDoe@gmail.com',
          label: Row(
            children: [
              Text('Email '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value!.length < 0) ? "Can't be empty" : null;
      },
    );
  }

  Widget _editName() {
    return TextFormField(
      controller: firstnameController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          labelStyle: GoogleFonts.openSans(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'e.g., John Doe',
          label: Row(
            children: [
              Text('Name '),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          )),
      onSaved: (String? value) {},
      validator: (String? value) {
        return (value!.length < 0 || value.contains('@'))
            ? "Can't be empty"
            : null;
      },
    );
  }

  Widget _editProfilePic() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Profile Image',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            )),
        InkWell(
          onTap: () {
            _getFromCamera();
          },
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                  image: AssetImage('assets/image/smile.jpg'),
                  fit: BoxFit.fill,
                ),
                border: Border.all(color: Colors.blue),
                borderRadius: radiusNormal),
          ),
        ),
        Text('Change', style: blackTextStyle.copyWith(fontSize: 14)),
      ],
    );
  }

  _setController(profile) {
    firstnameController.text = profile.profile[0].firstName == null
        ? ''
        : profile.profile[0].firstName;
    lastnameController.text =
        profile.profile[0].lastName == null ? '' : profile.profile[0].lastName;
    placeController.text =
        profile.profile[0].place == null ? '' : profile.profile[0].place;
    genderController.text =
        profile.profile[0].gender == null ? '' : profile.profile[0].gender;
    birthController.text = profile.profile[0].dateOfBirth == null
        ? ''
        : profile.profile[0].dateOfBirth;
    addressController.text =
        profile.profile[0].address == null ? '' : profile.profile[0].address;
    cityController.text =
        profile.profile[0].city == null ? '' : profile.profile[0].city;
    mobileController.text =
        profile.profile[0].mobile == null ? '' : profile.profile[0].mobile;
    waliController.text =
        profile.profile[0].wali == null ? '' : profile.profile[0].wali;
    noWaliController.text =
        profile.profile[0].noWali == null ? '' : profile.profile[0].noWali;
    genderval =
        (profile.profile[0].gender == 'L' ? 'Laki-laki' : 'Perempuan') == null
            ? ''
            : profile.profile[0].gender == 'L'
                ? 'Laki-laki'
                : 'Perempuan';
  }

  _getValData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    emailController.text = prefs.getString('email')!;
  }

  _getFromCamera() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      photoName = photo!.name;
    });
  }
}
