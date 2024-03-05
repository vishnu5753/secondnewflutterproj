import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyBO7lNG8Bt3X1xdi7eGlGmC1Wl043CyEvg",
          appId: "1:767112312418:android:0648b0a0d63f8244eb433b",
          messagingSenderId: "",
          projectId: "secondfirebase-7b4cb",
          storageBucket: "secondfirebase-7b4cb.appspot.com"
      ),
  );
  runApp(MaterialApp(home: cloud(),));
}
class cloud extends StatefulWidget{
  @override
  State<cloud> createState() => _cloudState();
}

class _cloudState extends State<cloud> {
  var name_controller=TextEditingController();
  var email_controller=TextEditingController();
  late CollectionReference _userCollection;
  @override
  void initState(){
    _userCollection=FirebaseFirestore.instance.collection("name");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.purpleAccent,title: Text("Firebase cloud"),titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      body:Padding(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: name_controller,
              decoration: InputDecoration(
                  labelText: "name",border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: email_controller,
              decoration: InputDecoration(
                  labelText: "email",border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: (){
              addUser();
            }, child: Text("Add user")),
            SizedBox(height: 15,),
            StreamBuilder(stream: getUser(), builder: (context,snapshot){
              if(snapshot.hasError){
                return Text("Error${snapshot.error}");
              }if(snapshot.connectionState==ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              final users= snapshot.data!.docs;
              return Expanded(child:ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context,index){
                    final user=users[index];
                    final userId=user.id;
                    final userName=user['name'];
                    final userEmail=user['email'];
                    return ListTile(
                      title: Text('$userName',style: TextStyle(fontSize: 20),),
                      subtitle: Text("$userEmail",style: TextStyle(fontSize: 15),),
                      trailing: Wrap(
                        children: [
                          IconButton(onPressed: (){
                            ///editUser(userId);
                          }, icon: Icon(Icons.edit)),
                          IconButton(onPressed: (){
                            ///deleteUser(userId);
                          }, icon: Icon(Icons.delete))
                        ],
                      ),
                    );

                  }));
            })
          ],
        ),
      ) ,
    );

  }
  ///create user
  Future<void>addUser()async {
    return _userCollection.add({
      'name': name_controller.text,
      'email': email_controller.text
    }).then((value) {
      print("user added succesfully");
      name_controller.clear();
      email_controller.clear();
    }).catchError((error) {
      print("failed to add user $error");
    });

  }
  Stream<QuerySnapshot>getUser(){
    return _userCollection.snapshots();
  }
}
Future<void>updateUser(var id,String newname,String newemail){
  return _userCollection.doc(id).update({'name':newname, "email":newemail}).then(value){
    print("user Updated Successfully");
  }).catchError((error){

  }
}