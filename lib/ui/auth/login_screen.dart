import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/auth/login_with_phone_number.dart';
import 'package:untitled1/ui/auth/signup_screen.dart';
import 'package:untitled1/ui/forget_password.dart';
import 'package:untitled1/ui/posts/post_screen.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey =GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool loading=false;
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void dispose()
  {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login()
  {
    setState(() {
      loading=true;
    });
    auth.signInWithEmailAndPassword(
      email:emailController.text.toString(),
      password:passwordController.text.toString(),

    ).then((value){
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace)
    {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());

      setState(() {
        loading=false;
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
        title: const Text("Login"),
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
            height: 15,
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
                  return 'Enter Password Please';
                }
                return null;
              },

            ),
          ]
        ),
      ),
         const SizedBox(height: 40,),


          RoundButton(
            title:'Login',
            loading: loading,
            ontap: (){
              if(_formKey.currentState!.validate())
                {
                  login();

                }
            },
          ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen()));
                  }, child: Text('Forget Password?')),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account "),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                }, child: Text('Sign up'))

              ],
            ),
            InkWell(
              onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginWithPhoneNumber()));
              },
              child: Container(
                height: 50,
                child: Center(child: Text('Login With Phone No')),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.black,
                  )

                ),
              ),
            )

  ],

        ),
      ),
    );
  }
}
