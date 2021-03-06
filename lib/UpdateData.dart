import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; //formateo hora

File image;
String filename;

class MyUpdatePage extends StatefulWidget {
  final DocumentSnapshot ds;
  MyUpdatePage({this.ds});
  @override
  _MyUpdatePageState createState() => _MyUpdatePageState();
}

class _MyUpdatePageState extends State<MyUpdatePage> {
  String productImage;
 TextEditingController descriptionInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;
  TextEditingController prixInputController;
  TextEditingController quantiteInputController;



  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String prix;
  String description;
  String quantite;

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
   
        prixInputController =
        new TextEditingController(text: widget.ds.data["prix"]);
    nameInputController =
        new TextEditingController(text: widget.ds.data["name"]);
    productImage = widget.ds.data["image"]; //nuevo
     descriptionInputController =
        new TextEditingController(text: widget.ds.data["description"]);
          quantiteInputController =
        new TextEditingController(text: widget.ds.data["quantite"]);

    print(productImage); //nuevo
  }

  /*
  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('colrecipes')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      // print(e);
    });
  }
  */

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("products").getDocuments();
    // print();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    getPosts();
    return Scaffold(
              backgroundColor: Color(0xffffffff),

      appBar: AppBar(
        backgroundColor: Color(0xff2E001F),

        title: Text('Update Product'),
        
        
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null ? Text('Add') : Image.file(image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.blueAccent)),
                        padding: new EdgeInsets.all(5.0),
                        child: productImage == ''
                            ? Text('Edit')
                            : Image.network(productImage + '?alt=media'),
                      ),
                    ),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCam),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                
                Container(
                  child: TextFormField(
                    controller: nameInputController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'name',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter new name';
                      }
                    },
                    onSaved: (value) => name = value,
                  ),
                ),
                 Container(
                  child: TextFormField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'description',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                     validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a  description ';
                      }
                    },
                    onSaved: (value) => description = value,                    
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'prix',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                     validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter price of product';
                      }
                    },
                    onSaved: (value) => prix = value,                    
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'quantite',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                     validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter quantity of product';
                      }
                    },
                    onSaved: (value) => quantite = value,                    
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Update'),
                onPressed: () {
                  DateTime now = DateTime.now();
                  String nuevoformato =
                      DateFormat('kk:mm:ss:MMMMd').format(now);
                  var fullImageName = 'nomfoto-$nuevoformato' + '.jpg';
                  var fullImageName2 = 'nomfoto-$nuevoformato' + '.jpg';

                  final StorageReference ref =
                      FirebaseStorage.instance.ref().child(fullImageName);
                  final StorageUploadTask task = ref.putFile(image);

                  var part1 =
                      'https://firebasestorage.googleapis.com/v0/b/sprint1-f7570.appspot.com/o/'; //esto cambia segun su firestore

                  var fullPathImage = part1 + fullImageName2;
                  print(fullPathImage);
                  Firestore.instance
                      .collection('products')
                      .document(widget.ds.documentID)
                      .updateData({
                    'name': nameInputController.text,
                    'quantite': quantiteInputController.text,
                     'prix': prixInputController.text,
                      'description': descriptionInputController.text,
                    'image': '$fullPathImage'
                  });
                  Navigator.of(context).pop(); //regrese a la pantalla anterior
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}