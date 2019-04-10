import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';

class OrderScreen extends StatelessWidget {

  final String orderID;

  OrderScreen(this.orderID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido realizado"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            Text("Pedido realizado com sucesso!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text("Código do pedido: $orderID",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25.0,),
            Container(
              height: 40.0,
              child: RaisedButton(
                child: Text("Início", style: TextStyle(color: Colors.white, fontSize: 17.0),),
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context)=>HomeScreen()
                      )
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
