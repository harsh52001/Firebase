import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/auth/verify_code.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';
class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController=TextEditingController();
  bool loading =false;
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
             SizedBox(
               height: 80,
             ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter Mobile No'
              ),

            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
                title: 'Verify',
                loading:loading,
                ontap: (){
              setState(() {
                loading=true;
              });
             auth.verifyPhoneNumber(
               phoneNumber: "+91"+phoneNumberController.text,
                 verificationCompleted: (_){
                   setState(() {
                     loading=false;
                   });
                 },
                 verificationFailed: (e)
                 {
                   Utils().toastMessage(e.toString());
                   setState(() {
                     loading=false;
                   });
                 },
                  codeSent:(String verificationId,int? token)
                 {
             Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyCodeScreen(verificationId: verificationId,)));
                setState(() {
                  loading=false;
                });
                 },
                  codeAutoRetrievalTimeout: (e)
             {
               Utils().toastMessage(e.toString());
               setState(() {
                 loading=false;
               });
             });
            })
          ],
        ),
      ),
    );
  }
}
