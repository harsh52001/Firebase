
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading=true;
  File? _image;
  final picker=ImagePicker();
 firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
 DatabaseReference databaseRef =FirebaseDatabase.instance.ref('Post');

  Future getImagegallery()async{
    final pickedFile = await picker.pickImage(source:ImageSource.gallery,imageQuality: 80);
    setState(() {


    if(pickedFile!=null)
      {
       _image= File(pickedFile.path);
      }
    else
      {
       print('NO IMAGE PICKED');
      }
      });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: (){
                     getImagegallery();
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black
                        ),
                      ),
                      child: _image!=null? Image.file(_image!.absolute) : Icon(Icons.image),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                RoundButton(title: 'Upload Image',loading: loading, ontap: ()async{
                  setState(() {
                    loading=true;
                  });
               firebase_storage.Reference ref=firebase_storage.FirebaseStorage.instance.ref('/foldername/'+DateTime.now().millisecondsSinceEpoch.toString());
               firebase_storage.UploadTask uploadTask=ref.putFile(_image!.absolute);
               await Future.value(uploadTask).then((value)async{
                 var newUrl=await ref.getDownloadURL();
                 databaseRef.child('1').set({
                   'id':'1232',
                   'title':  newUrl.toString(),
                 }).then((value){
                   setState(() {
                     loading=false;
                   });
                   Utils().toastMessage('Uploaded');
                 }).onError((error, stackTrace){
                   setState(() {
                     loading=false;
                   });

                 });
               }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading=false;
                    });
               });

                }
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
