import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users").document(uid)
          .collection("orders").getDocuments(),
        builder:  (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(snapshot.data.documents.length == 0) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.assignment, color: Theme.of(context).primaryColor, size: 80.0,),
                      SizedBox(height: 20.0,),
                      Text("Não há pedidos :(",
                        style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500),)
                    ],
                  )
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList()
              .reversed.toList(),
            );
          }
        },
      );

    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0,),
            Text("Faça login para acompanhar\nseus pedidos!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0,),
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()
                    )
                );
              },
            )
          ],
        ),
      );
    }

  }
}
