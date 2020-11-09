import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyInfoPage extends StatefulWidget {
  final DocumentSnapshot ds;
  MyInfoPage({this.ds});
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String productImage;
  String id;
  String name;
 String prix,quantite,description;

  TextEditingController nameInputController;
  TextEditingController descriptionInputController;
  TextEditingController prixInputController;
  TextEditingController quantiteInputController;

  Future getPost() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("colrecipes").getDocuments();
    return qn.documents;
  }

   @override
  void initState() {
    super.initState();
    
    productImage = widget.ds.data["image"];
    print(productImage);
       prixInputController =
        new TextEditingController(text: widget.ds.data["prix"]);
    nameInputController =
        new TextEditingController(text: widget.ds.data["name"]);
    //nuevo
     descriptionInputController =
        new TextEditingController(text: widget.ds.data["description"]);
          quantiteInputController =
        new TextEditingController(text: widget.ds.data["quantite"]);

  }



  @override
  Widget build(BuildContext context) {
    getPost();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2E001F),
        title: Text('Information Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      padding: new EdgeInsets.all(5.0),
                      child: productImage == ''
                          ? Text('Edit')
                          : Image.network(productImage + '?alt=media'),
                    ),                    
                  ],
                ),
                new IniciarIcon(),
                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: new TextFormField(
                    controller: nameInputController,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa un nombre";
                    },
                    decoration: new InputDecoration(
                        hintText: "Name", labelText: "Name"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.list, color: Colors.black),
                  title: new TextFormField(
                    maxLines: 10,
                    controller: descriptionInputController,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa un nombre";
                    },
                    decoration: new InputDecoration(
                        hintText: "description", labelText: "description"),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.list, color: Colors.black),
                  title: new TextFormField(
                    maxLines: 10,
                    controller: prixInputController,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa un nombre";
                    },
                    decoration: new InputDecoration(
                        hintText: "prix", labelText: "prix"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.list, color: Colors.black),
                  title: new TextFormField(
                    maxLines: 10,
                    controller: quantiteInputController,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa un nombre";
                    },
                    decoration: new InputDecoration(
                        hintText: "quantite", labelText: "quantite"),
                  ),
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class IniciarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new IconoMenu(
            icon: Icons.call,
            label: "Call",
          ),
          new IconoMenu(
            icon: Icons.message,
            label: "Message",
          ),
          new IconoMenu(
            icon: Icons.place,
            label: "Place",
          ),
        ],
      ),
      
    );
  }
}

class IconoMenu extends StatelessWidget {
  IconoMenu({this.icon, this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 50.0,
            color: Colors.blue,
          ),
          new Text(
            label,
            style: new TextStyle(fontSize: 12.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
