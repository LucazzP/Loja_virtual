import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String orderID;

  OrderTile(this.orderID);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("orders").document(orderID).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }  else {

                int status = snapshot.data["status"];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Código do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      _buildProductsText(snapshot.data),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      "Status do Pedido:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCircle("1", "Preparação", status, 1),
                        _lineBetween(),
                        _buildCircle("2", "Transporte", status, 2),
                        _lineBetween(),
                        _buildCircle("3", "Entrega", status, 3),
                      ],
                    )
                  ],
                );
              }
            }
        ),
      )
    );
  }
}

Widget _lineBetween(){
  return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey[500]
  );
}

String _buildProductsText(DocumentSnapshot snapshot){
  String text = "Descrição:\n";
  for(LinkedHashMap p in snapshot.data["products"]){
    text += "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
  }
  text += "Frete: R\$ ${snapshot.data["shipPrice"].toStringAsFixed(2)}\n";
  text += "\nTotal: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
  return text;
}

Widget _buildCircle(String title, String subtitle, int status, int thisStatus){

  Color backColor;
  Widget child;

  if(status < thisStatus){
    backColor = Colors.grey[500];
    child = Text(title, style: TextStyle(color: Colors.white),);
  } else if(status == thisStatus){
    backColor = Colors.blue;
    child = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(title, style: TextStyle(color: Colors.white),),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      ],
    );
  } else {
    backColor = Colors.green;
    child = Icon(Icons.check, color: Colors.white,);
  }

  return Column(
    children: <Widget>[
      CircleAvatar(
        radius: 20.0,
        backgroundColor: backColor,
        child: child,
      ),
      Text(subtitle)
    ],
  );
}