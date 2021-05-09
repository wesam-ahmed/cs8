import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}
class _ProductPageState extends State<ProductPage> {
  Future<bool> _backStore()async{
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHome()));
  }
  int quantityOfItems=1;
  @override
  Widget build(BuildContext context)
  {Size screenSize =MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _backStore,
        child:SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body:Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [Center(child: Container(child: Image.network(widget.itemModel.thumbnailUrl),height: 300,)),],),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child:Center(
                      child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.itemModel.title, style: boldTextStyle,),
                          SizedBox(height: 5.0,),
                          Text(widget.itemModel.longDescription,),
                          SizedBox(height: 5.0,),
                          Text("EGP"+ widget.itemModel.price.toString(), style: boldTextStyle,),
                        ],
                      ) ,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()=>checkItemInCart(widget.itemModel.idItem, context),
                        child: Container(
                          decoration: new BoxDecoration(borderRadius: BorderRadius.circular(35),
                              gradient: new LinearGradient(
                                colors: [Colors.greenAccent,Colors.green],
                                begin:const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0,1.0],
                                tileMode: TileMode.clamp,
                              )
                          ),
                          width: screenSize.width-40.0,
                          height: 50.0,
                          child: Center(
                            child: Text("Add to Cart",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),



                ],
              ),
            ),
            Flexible(child: CustomScrollView(slivers: [
              SliverToBoxAdapter(),
              StreamBuilder<QuerySnapshot>(

                stream: Firestore.instance
                    .collection("items")
                    .where("price",
                    isLessThanOrEqualTo: widget.itemModel.price)
                    .where("category",
                    isEqualTo: widget.itemModel.category)
                    .where("section",
                    isEqualTo: widget.itemModel.section)
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                      : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) =>
                        StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      ItemModel model = ItemModel.fromJson(
                          dataSnapshot
                              .data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data.documents
                        .length,
                  );
                },
              ),

            ],

            ),
            )
          ],
        )


      ),
    )
    );

  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
