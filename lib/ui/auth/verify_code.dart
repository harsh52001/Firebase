import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/posts/post_screen.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verifyCodeController = TextEditingController();
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '6 Digit Code'
              ),

            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(title: 'Verify',
                loading: loading,
                ontap: () async {
              setState(() {
                loading=true;
              });
                 final crendital= PhoneAuthProvider.credential(
                     verificationId: widget.verificationId,
                     smsCode: verifyCodeController.text.toString()
                 );
                 try
                 {
                   await auth.signInWithCredential(crendital);
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> PostScreen()));
                 }
                 catch(e)
                  {
                   setState(() {
                     loading=false;
                   });
                   Utils().toastMessage(e.toString());
                  }
                })
          ],
        ),
      ),
    );
  }
}