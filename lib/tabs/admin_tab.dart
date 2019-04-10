import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        color: Colors.black,
        height: 50.0,
        onPressed: () async{
          var doc = await Firestore.instance.collection("products").document("camisetas").collection("items").document("UsknNxCaMrhzZvEf20l8").get();
          await Firestore.instance.collection("products").document("camisetas").collection("items").add(doc.data);
        },
      ),
    );
  }
}