import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTab extends StatelessWidget {

  PageController _pageController;

  HomeTab(this._pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
//              Colors.grey[100],
//              Colors.grey[400]
              Color.fromARGB(255, 50, 200, 241),
              Color.fromARGB(255, 203, 236, 241)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        )
      ),
    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Color.fromARGB(255, 50, 180, 200),
              elevation: 2,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 2.2,
                child: CarouselSlider(
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  viewportFraction: 0.75,
                  items: ["http://ligadalingerie.com.br/wp-content/uploads/2490186122510494.jpg",
                  "http://www.dominiopop.com/wp-content/uploads/2018/05/colecao-riachuelo-stranger-things-roupas-destaque.jpg",
                  "http://academiadoimportador.org/wp-content/uploads/2015/03/1.jpg"].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
//                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Image(image: NetworkImage(i), fit: BoxFit.fill,),
                        );
                      },
                    );
                  }).toList(),
                )
              )
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                height: 60,
                child: RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add_shopping_cart, color: Colors.white, size: 35,),
                      SizedBox(width: 18,),
                      Text("COMPRE JÁ!", style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w500),),
                    ],
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    _pageController.jumpToPage(1);
                  },
                ),
              )
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("home").orderBy("pos").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count(
                      crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.documents.map(
                        (doc){
                          return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                        }
                    ).toList(),
                    children: snapshot.data.documents.map(
                        (doc){
                          return FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc.data["image"],
                            fit: BoxFit.cover,
                          );
                        }
                    ).toList(),
                  );
              },
            )
          ],
        )
      ],
    );
  }
}
