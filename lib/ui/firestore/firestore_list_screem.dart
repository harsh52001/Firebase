import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:untitled1/ui/auth/login_screen.dart';
import 'package:untitled1/ui/firestore/add_firestore_data.dart';
import 'package:untitled1/ui/posts/add_post.dart';
import 'package:untitled1/utils/utils.dart';
class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  final fireStore =FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference ref=FirebaseFirestore.instance.collection('user');
  //final ref1=FirebaseFirestore.instance.collection('user');
  final editController=TextEditingController();
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('FireStore'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
            });

          }, icon: Icon(Icons.logout),),
          SizedBox(width: 10,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddFirestoreDataScreen()));

        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [

          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
                builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
                {
                  if(snapshot.connectionState==ConnectionState.waiting)
                    return CircularProgressIndicator();
                  if(snapshot.hasError)
                    return Text('Some Error Occur');
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,

                        itemBuilder: (context,index)
                    {
                      return ListTile(
                        onTap: () {

                          ref.doc(snapshot.data!.docs[index]['id'].toString())
                              .update({
                            'title': 'I am not good in Flutter'
                          }).then((value) {
                            Utils().toastMessage('Updated');
                          }).onError((error, stackTrace) {
                            Utils().toastMessage(error.toString());
                          });
                        },
                        onLongPress: () {

                          ref.doc(snapshot.data!.docs[index]['id'].toString()).delete().then((value) {
                            Utils().toastMessage('Deleted');
                          }).onError((error, stackTrace) {
                            Utils().toastMessage(error.toString());
                          });

                        },


                        title: Text(snapshot.data!.docs[index]['title']),
                        subtitle: Text(snapshot.data!.docs[index]['id']),
                      );

                    }
                    ),
                  );
                  }

            ),


         ],
          )
          );


  }
  Future<void> showMyDialog(String title,String id)async
  {
    editController.text=title;
    return showDialog(context: context, builder: (BuildContext context)
    {
      return AlertDialog(
        title: Text('Update'),
        content: Container(
          child: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'Edit Post',
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")
          ),
          TextButton(onPressed: (){
            Navigator.pop(context);

          }, child: Text("Update"))
        ],
      );
    }
    );
  }
}
