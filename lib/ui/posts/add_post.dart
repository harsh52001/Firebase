import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/utils/utils.dart';
import 'package:untitled1/widgets/round_button.dart';
class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading=false;
  final postController=TextEditingController();
  final databaseRef=FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(

                  hintText: 'What is in Your Mind',
                  border: OutlineInputBorder()

              ),

            ),
            SizedBox(height: 30,),
            RoundButton(
                title: 'Add',
                loading: loading,
                ontap: (){
                  setState(() {
                    loading=true;
                  });
                  String id=DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    'title': postController.text.toString(),
                    'id': id,

                  }).then((value){
                    Utils().toastMessage('Post Added');
                    setState(() {
                      loading=false;
                    });
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
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
