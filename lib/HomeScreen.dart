import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sprint1/LogInScreen.dart';
import 'addpage.dart';
import 'Data.dart';
import 'LogInScreen.dart';
import 'UploadData.dart';
import 'MyFavorite.dart';
import 'UpdateData.dart';
import 'details.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String currentEmail;

  HomeScreen(this.currentEmail);

  @override
  _HomeScreenState createState() => _HomeScreenState(currentEmail);
}

class _HomeScreenState extends State<HomeScreen> {
   TextEditingController recipeInputController;
  TextEditingController nameInputController;
  String id;
  final db = Firestore.instance;
  //final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;

  //create function for delete one register
   void deleteData(DocumentSnapshot doc) async {
    await db.collection('products').document(doc.documentID).delete();
    setState(() => id = null);
  }

  //create tha funtion navigateToDetail
  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyUpdatePage(
                  ds: ds,
                )));
  }

   //create tha funtion navigateToDetail
  navigateToInfo(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyInfoPage(
                  ds: ds,
                )));
  }

  String currentEmail;
  List<Data> dataList = [];
  List<bool> favList = [];
  //Grid<Data> gridList=[];
  bool searchState = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  _HomeScreenState(this.currentEmail);

  Future<void> logOut() async {
    auth.signOut().then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LogInScreen()));
    });
  }

  @override
  /*void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Data");
    referenceData.once().then((DataSnapshot dataSnapShot) {
      dataList.clear();
      favList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        Data data = new Data(values[key]['imgUrl'], values[key]['name'],
            values[key]['material'], values[key]['price'], key
            //key is the uploadid
            );
        dataList.add(data);
        auth.currentUser().then((value) {
          DatabaseReference reference = FirebaseDatabase.instance
              .reference()
              .child("Data")
              .child(key)
              .child("Fav")
              .child(value.uid)
              .child("state");
          reference.once().then((DataSnapshot snapShot) {
            if (snapShot.value != null) {
              if (snapShot.value == "true") {
                favList.add(true);
              } else {
                favList.add(false);
              }
            } else {
              favList.add(false);
            }
          });
        });
      }

      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xff2E001F),
        title: !searchState
            ? Text("Home")
            : TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search ...",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (text) {
                  //SearchMethod(text);
                },
              ),
        actions: <Widget>[
          !searchState
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  })
              : IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  }),
          FlatButton.icon(
              onPressed: () {
                logOut();
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text("Log out"))
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 170,
              color: Color(0xff2E001F),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Image(
                    image: AssetImage(""),
                    height: 90,
                    width: 90,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    currentEmail,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text("Upload"),
              leading: Icon(Icons.cloud_upload),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>  MyAddPage()));
              },
            ),

            ListTile(
              title: Text("My Favorite"),
              leading: Icon(Icons.favorite),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyFavorite()));
              },
            ),

            ListTile(
              title: Text("My Profile"),
              leading: Icon(Icons.person),
            ),
            Divider(),

            ListTile(
              title: Text("Contact US"),
              leading: Icon(Icons.email),
            ) //line
          ],
        ),
      ),

      body: /*dataList.length == 0
          ? Center(
              child: Text(
              "No Data Available",
              style: TextStyle(fontSize: 30),
            ))
          : ListView.builder(
              //gridDelegate: null,
              itemCount: dataList.length,
              itemBuilder: (_, index) {
                return CardUI(
                    dataList[index].imgUrl,
                    dataList[index].name,
                    dataList[index].material,
                    dataList[index].price,
                    dataList[index].uploadid,
                    index);
              }),*/
              StreamBuilder(
        stream: Firestore.instance.collection("products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text('"Loading...');
          }
          int length = snapshot.data.documents.length;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //two columns
              mainAxisSpacing: 0.1, //space the card
              childAspectRatio: 0.800, //space largo de cada card
          ),
           itemCount: length,
            padding: EdgeInsets.all(2.0),
            itemBuilder: (_, int index) {
              final DocumentSnapshot doc = snapshot.data.documents[index];                         
              return new Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                             onTap: () => navigateToDetail(doc),
                            child: new Container(
                              child: Image.network(
                                '${doc.data["image"]}' + '?alt=media',
                              ),
                              width: 170,
                              height: 120,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            doc.data["name"],
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 19.0,
                            ),
                          ),
                          subtitle: Text(
                            doc.data["materials"],
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 12.0),
                          ),
                           onTap: () => navigateToDetail(doc),
                        ),
                      ),
                      Divider(),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: new Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => deleteData(doc), //funciona
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blueAccent,
                                  ),
                                   onPressed: () => navigateToInfo(doc),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
      //curved
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xff2E001F),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xff2E001F),
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.add, size: 30, color: Colors.white),
          Icon(Icons.local_grocery_store, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 200),
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }

  /*Widget CardUI(String imgUrl, String name, String material, String price,
      String uploadId, int index) {
     return Card(
      elevation: 7,
      margin: EdgeInsets.all(15),
      color: Color(0xff2E001F),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Image.network(
              imgUrl,
              fit: BoxFit.cover,
              height: 100,
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 1,
            ),
            Text("material:- $material"),
            SizedBox(
              height: 1,
            ),
            Container(
              width: double.infinity,
              child: Text(
                price,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              height: 1,
            ),
            favList[index]
                ? IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Color(0xff2E001F),
                    ),
                    onPressed: () {
                      auth.currentUser().then((value) {
                        DatabaseReference favRef = FirebaseDatabase.instance
                            .reference()
                            .child("Data")
                            .child(uploadId)
                            .child("Fav")
                            .child(value.uid)
                            .child("state");
                        favRef.set("false");
                        setState(() {
                          FavoriteFunc();
                        });
                      });
                    })
                : IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {
                      auth.currentUser().then((value) {
                        DatabaseReference favRef = FirebaseDatabase.instance
                            .reference()
                            .child("Data")
                            .child(uploadId)
                            .child("Fav")
                            .child(value.uid)
                            .child("state");
                        favRef.set("true");

                        setState(() {
                          FavoriteFunc();
                        });
                      });
                    }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color(0xff2E001F),
                  textDirection: TextDirection.rtl,
                ),
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text('You are going to delete this product'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('NO'),
                              onPressed: () {},
                            ),
                            FlatButton(
                                child: Text('YES'),
                                onPressed: () {
                                  
                                    Delete_product(uploadId,index);
                                  
                                }),
                          ],
                        );
                      });
                }),
            IconButton(
              icon: Icon(
                Icons.mode_edit,
                color: Color(0xff2E001F),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UpdateData()));
              },
            )
          ],
        ),
      ),
    );
  }*/

 /* void FavoriteFunc() {
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Data");
    referenceData.once().then((DataSnapshot dataSnapShot) {
      favList.clear();

      var keys = dataSnapShot.value.keys;

      for (var key in keys) {
        auth.currentUser().then((value) {
          DatabaseReference reference = FirebaseDatabase.instance
              .reference()
              .child("Data")
              .child(key)
              .child("Fav")
              .child(value.uid)
              .child("state");
          reference.once().then((DataSnapshot snapShot) {
            if (snapShot.value != null) {
              if (snapShot.value == "true") {
                favList.add(true);
              } else {
                favList.add(false);
              }
            } else {
              favList.add(false);
            }
          });
        });
      }
      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }

  void SearchMethod(String text) {
    DatabaseReference searchRef =
        FirebaseDatabase.instance.reference().child("Data");
    searchRef.once().then((DataSnapshot snapShot) {
      dataList.clear();
      var keys = snapShot.value.keys;
      var values = snapShot.value;

      for (var key in keys) {
        Data data = new Data(values[key]['imgUrl'], values[key]['name'],
            values[key]['material'], values[key]['price'], key
            //key is the uploadid
            );
        if (data.name.contains(text)) {
          dataList.add(data);
        }
      }
      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }

  void Delete_product(String uploadId, int index) {
    DatabaseReference _ProductRef = FirebaseDatabase.instance.reference();
    _ProductRef.reference().child("Data").child(uploadId).remove().then((_) {
      print("Delete $uploadId successful");
      setState(() {
        dataList.removeAt(index);
      });
    });
  }*/
}
