import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/ui/auth/login_screen.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';
import 'package:firebase_core/firebase_core.dart';




class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool  loading=false;
  final _formKey =GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  void dispose()
  {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void signup()
  {
    setState(() {
      loading=true;
    });
    auth.createUserWithEmailAndPassword(
      email:emailController.text.toString(),
      password:passwordController.text.toString(),
    ).then((value){
      setState(() {
        loading=false;
      });

    }).onError((error, stackTrace)
    {
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async
      {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(

          title: const Text("Sign up"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Form(
                key: _formKey,
                child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          helperText: 'Enter email jon@email.com',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Enter Email Please';
                          }
                          return null;
                        },


                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Enter Paasword Please';
                          }
                          return null;
                        },

                      ),
                    ]
                ),
              ),
              const SizedBox(height: 50,),


              RoundButton(
                title:'Sign up',
                loading: loading,
                ontap: () {
                  if (_formKey.currentState!.validate()) {
                    signup();
                  }

                }
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account "),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  }, child: Text('Login'))

                ],
              )

            ],

          ),
        ),
      ),
    );
  }
}
