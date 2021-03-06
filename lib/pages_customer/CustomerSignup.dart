import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_customer/CustomerLogin.dart';
import 'package:flutter_complete_guide/widgets/Pageroute.dart';
import 'package:flutter_complete_guide/widgets/loader.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models.dart' as models;
import '../widgets/navbar.dart' as navbar;
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUppage extends StatefulWidget {
  String message;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final NameController = TextEditingController();
  final EmailController = TextEditingController();
  var phone;
  var PhoneNumberController = TextEditingController();
  var verifyed = false;
  String branch = '';
  bool obsureText = true;
  bool obsureText2 = true;
  SignUppage();

  @override
  State<SignUppage> createState() => _SignUppagestate();
}

class _SignUppagestate extends State<SignUppage> {
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  submit() async {  
    LoaderDialogbox(context);
    print(widget.phone);
    final body = {
      'full_name': widget.NameController.text,
      'email': widget.EmailController.text,
      'phone': widget.phone.toString(),
      'username': widget.PhoneNumberController.text,
      'password1': widget.passwordController.text,
    };
    print(body);
    final url = Uri.parse(main.url_start + 'mobileApp/SignUp/');

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
      ScaffoldMessenger.of(context).clearSnackBars();
      if (data['message'] == 'Success') {
        Navigator.of(context).pop();
        print('success');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SuccessFully done'),backgroundColor: Colors.green,));
        // print(main.storage.getItem('branch'));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerLoginpage()),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User with this Name is aldready there'),backgroundColor: Colors.green,));
      }
    }
  }

  get_branch() async {
    final url = Uri.parse(main.url_start + 'mobileApp/BranchDetails/');
    final response = await http.get(url);
    print(url);
    // print(response.statusCode);

    if (response.statusCode == 200) {
      //  print(response.body);
      var data = json.decode(response.body) as Map;
      //  print(data['results']);

      List Branches = data['results']
          .map<models.Branch>((json) => models.Branch.fromjson(json))
          .toList();

      return Branches;
    }
  }
  String phoneNumber, verificationId;
  String otpbyuser;
  Future receiveOtp(BuildContext context) async{
    var body = {
      'phone': widget.phone.toString(),
      'type':'signup'
    };
    final url = Uri.parse(main.url_start + 'mobileApp/sendotp/');

    final response = await http.post(url, body: body);
    if (response.statusCode == 200){
      var data = json.decode(response.body) as Map;
      var otp = data['otp'];
      print(otp);
      otpDialogBox(context).then((value){
        print(otpbyuser);
        if (otp.toString() == otpbyuser){
          print(widget.verifyed);
        setState(() {
          widget.verifyed = true;
          widget.usernameController.text == widget.phone.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Otp dont match retry'),backgroundColor: Colors.red,));
      }
      });
    }else if (response.statusCode == 111){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Aldready account With this number is there'),backgroundColor: Colors.red,));
      }

  }
  otpDialogBox(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter your OTP'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otpbyuser = value;
                },
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                return otpbyuser;
              },
              child: Text(
                'Submit',
              ),
            ),
          ],
        );
      });
      }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return    Scaffold(       
        drawer: navbar.Navbar(),
        
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor
          ), 
          child: Center(
            child: SingleChildScrollView(
                child: widget.verifyed== true? Column(children: 
                  [Text('Register', style: TextStyle(fontSize: 40, fontFamily: GoogleFonts.robotoMono().fontFamily,color: Colors.white)),
                Column(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [Form(
                            key: _formkey,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.NameController,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Full Name',
                            contentPadding:
                                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Name should be there';
                                        }
                                        return null;
                                      },
                                    ),
                              ), 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.EmailController,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            contentPadding:
                                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                            validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email should be there';
                                        }else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)==false){
                                          return 'Email pattern is wrong';
                                        }
                                        
                                        return null;
                                      },
                                    ),
                              ), 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.PhoneNumberController,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: widget.phone.toString(),
                            enabled: false,
                            
                            contentPadding:
                                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'User name should be there';
                                        }
                                        return null;
                                      },
                                    ),
                              ), 
                          
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.passwordController,
                                    obscureText: widget.obsureText,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                  icon: widget.obsureText
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.security_sharp),
                                  onPressed: () {
                                    setState(() {
                                      widget.obsureText = !widget.obsureText;
                                    });
                                  },
                                ),
                            contentPadding:
                                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                                  validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password should is compulsary';
                                        }
                                        return null;
                                      },
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: widget.confirmPasswordController,
                                    obscureText: widget.obsureText2,
                                    decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            suffixIcon: IconButton(
                                  icon: widget.obsureText2
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.security_sharp),
                                  onPressed: () {
                                    setState(() {
                                      widget.obsureText2 = !widget.obsureText2;
                                    });
                                  },
                                ),
                            contentPadding:
                                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                                  // ignore: missing_return
                                  validator: (value) {
                                        if (widget.passwordController.text ==null){
                                          return 'Password is needed before to confirm it';
                                        }
                                        else if (value == null || value.isEmpty ) {
                                          return 'Password should is compulsary';
                                        }else if(widget.passwordController.text != value){
                                          return 'Password didnt match';
                                        }
                                        return null;
                                      },
                                  ),
                              ),                
                             
                            ]),
                          ),
                           FlatButton(onPressed: (){setState(() {
                             widget.verifyed = false;
                           });}, child: Text('<<<  Go back',style: TextStyle(color: Color.fromARGB(255, 207, 206, 206), decoration: TextDecoration.underline),)),
                           ElevatedButton(
                              
                              onPressed: (){
                              if (_formkey.currentState.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data') , backgroundColor: Colors.green,),);
                              submit();
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ]
                        ),
                      )),
                    ),
                  ],
                )
              ]):
              Column(
                children: [
                  Text('Register', style: TextStyle(fontSize: 40, fontFamily: GoogleFonts.robotoMono().fontFamily,color: Colors.white)),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey2,
                        child: Column(
                          children: [
                            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: widget.PhoneNumberController,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                onChanged: (number) {
                                setState(() {
                                  widget.phone = number;
                                });
                              },
                              maxLength: 10,
                              keyboardType:
                                  TextInputType.number,
                              decoration: InputDecoration(
                                
                                filled: true,
                              prefixText: '+91',
                              prefixIcon: Icon(Icons.flag),
                              fillColor: Colors.white,
                              hintText: 'Phone Number',
                              contentPadding:
                                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                    
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                              ),),
                              ),
                            ),
                            FlatButton(onPressed: (){Navigator.pushReplacement(context, CustomPageRoute(child: CustomerLoginpage()));}, child: Text('Aldready have an account? ',style: TextStyle(color: Color.fromARGB(255, 207, 206, 206), decoration: TextDecoration.underline),)),
                            ElevatedButton(onPressed: (){if (_formkey2.currentState.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data') , backgroundColor: Colors.green,),);
                                receiveOtp(context);
                                  }
                                }, child: Text('Receive Otp')),
                          ],
                      
                        ),
                      ),
                    ),
                  ),
                ),]
              )

            ),
          ),
        ));
  }
}

