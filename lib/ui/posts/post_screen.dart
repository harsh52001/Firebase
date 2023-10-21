import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/auth/login_screen.dart';
import 'package:untitled1/ui/posts/add_post.dart';
import 'package:untitled1/utils/utils.dart';
class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  final ref=FirebaseDatabase.instance.ref("Post");
  final searchFilter=TextEditingController();
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
        title: Text('Post'),
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPost()));

        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
         /* Expanded(
            child: StreamBuilder(
              stream: ref.onValue,

                builder: (context,AsyncSnapshot<DatabaseEvent> snapshot)
          {
            if(!snapshot.hasData)
              {
                return CircularProgressIndicator();
              }
            else {
              Map<dynamic,dynamic> map=snapshot.data!.snapshot.value as dynamic;
              List<dynamic> list=[];
              list.clear();
              list=map.values.toList();

              return ListView.builder(
                  itemCount: snapshot.data!.snapshot.children.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index]['title']),
                      subtitle: Text(list[index]['id']),
                    );
                  });
            }
          }
            )
          ),
          */
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searchFilter,

              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),

              ),
              onChanged: (String value)
                {
                  setState(() {

                  });
                }
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
            query: ref,
                defaultChild: Text("Loading",style: TextStyle(color: Colors.black),),
                itemBuilder: (context,snapshot,animation,index)
                  {
                    final title=snapshot.child('title').value.toString();
                    if(searchFilter.text.isEmpty)
                    {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context)=>
                          [
                            PopupMenuItem(
                                value:1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title,snapshot.child('id').value.toString());
                                  },

                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                            )),
                            PopupMenuItem(
                                value:1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },

                              leading: Icon(Icons.delete ),
                              title: Text("Delete"),
                            ))
                          ],
                        ),
                      );
                    }
                    else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toString()))
                      {
                        return ListTile(
                          title: Text(snapshot.child('title').value.toString()),
                          subtitle: Text(snapshot.child('id').value.toString()),
                        );
                      }
                    else
                      {
                        return Container();
                      }

                  }

          )
          )
        ],
      ),
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
            ref.child(id).update({
              'title':editController.text.toLowerCase()
            }).then((value){
              Utils().toastMessage("Post Update");
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, child: Text("Update"))
        ],
      );
    }
    );
  }
}
