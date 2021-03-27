import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'Section.dart';

double width;


class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<bool> _backStore()async{
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => Section()));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _backStore,
      child:SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            //Customs menu icon color (osama)
            icon: new Icon(Icons.menu,color: Colors.black,),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.white,Colors.grey],
                  begin:const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          title: Text("e-Shop",style: TextStyle(fontSize: 55.0,color: Colors.black,fontFamily: "Signatra"),),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart,color: Colors.black,),
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (C) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },),
                Positioned(
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,size: 20,color: Colors.grey,
                        ),
                        Positioned(
                            top: 3,
                            bottom: 4,
                            left: 4,
                            child:Consumer<CartItemCounter>(
                              builder: (context,counter,_)
                              {
                                return Text(
                                  (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                                  style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500) ,
                                );
                              },
                            )
                        )
                      ],
                    )
                )
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: Container(
          child:Center(
            child: Column(
              mainAxisSize: MainAxisSize.max ,
              children: [

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.deepPurple,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: (){
                            SectionKey.category="Pants";
                            Route route = MaterialPageRoute(builder: (_) => StoreHome());
                            Navigator.pushReplacement(context, route);
                          }, child: Text("Pants",style: TextStyle(fontSize: 20,),)),
                      SizedBox(width: 5,),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.red,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: (){
                            SectionKey.category="Shirts";
                            Route route = MaterialPageRoute(builder: (_) => StoreHome());
                            Navigator.pushReplacement(context, route);
                          }
                          ,child: Text("Shirts",style: TextStyle(fontSize: 20,),)),
                      SizedBox(width: 5,),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.greenAccent,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: (){
                            SectionKey.category="T-Shirt";
                            Route route = MaterialPageRoute(builder: (_) => StoreHome());
                            Navigator.pushReplacement(context, route);
                          }
                          ,child: Text("T-Shirt",style: TextStyle(fontSize: 20,),)),
                      SizedBox(width: 5,),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.lightGreen,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: (){
                            SectionKey.category="Jackets";
                            Route route = MaterialPageRoute(builder: (_) => StoreHome());
                            Navigator.pushReplacement(context, route);
                          }
                          ,child: Text("Jackets",style: TextStyle(fontSize: 20,),)),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),

                Expanded(child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate()),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection(SectionKey.section).document(SectionKey.category).collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
                      builder: (context, dataSnapshot){
                        return !dataSnapshot.hasData
                            ?SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                            :SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c)=> StaggeredTile.fit(1),
                          itemBuilder: (context,index)
                          {
                            ItemModel model =ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                            return sourceInfo(model, context);
                          },
                          itemCount: dataSnapshot.data.documents.length,
                        );
                      },
                    ),
                  ],
                ))
                ,
          ],
            ),
          )

        ),

      ),
    )
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction})
{
  return InkWell(
    onTap: (){
      Route route =MaterialPageRoute(builder: (c)=>ProductPage(itemModel:model));
      Navigator.pushReplacement(context, route);
    },
    splashColor:Colors.grey ,
    child: Padding
      (padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 14.0),),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height:5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.pink,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "50%",style: TextStyle(fontSize:15.0,color: Colors.white,fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "OFF",style: TextStyle(fontSize:12.0,color: Colors.white,fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  "original Price: EGP ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),

                                ),
                                Text(
                                  (model.price +model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,

                                  ),

                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "New Price:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  " EGP ",
                                  style: TextStyle(color: Colors.blueGrey,fontSize: 16.0),
                                ),
                                Text(
                                  (model.price ).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child:removeCartFunction == null
                      ?IconButton(
                      icon: Icon(Icons.add_shopping_cart,color: Colors.black,),
                      onPressed: (){
                        checkItemInCart(model.idItem, context);

                      },
                    )
                        :IconButton(
                      icon: Icon(Icons.delete ,color: Colors.black,),
                      onPressed: (){
                        removeCartFunction();
                        Route route = MaterialPageRoute(builder: (C) => StoreHome());
                        Navigator.pushReplacement(context, route);
                      },
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
  ),
  );
}
Widget card({Color primaryColor = Colors.redAccent, String imgPath})
{
  return Container(
    height: 150,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0,5),blurRadius: 10,color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Image.network(
        imgPath,
        height: 150,
        width: width * .34,
        fit: BoxFit.fill,
      ) ,
    ),
  );
}
void checkItemInCart(String idItemAsId, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(idItemAsId)
      ?Fluttertoast.showToast(msg: "Item is already in Cart")
  :addItemToCart(idItemAsId,context);
}
addItemToCart(String idItemAsId,BuildContext context)
{
 List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
 tempCartList.add(idItemAsId);
EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
 .updateData({
  EcommerceApp.userCartList:tempCartList,
}).then((v){
  Fluttertoast.showToast(msg: "Item Added to Cart Successfully");
  EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,tempCartList);
  Provider.of<CartItemCounter>(context,listen: false).displayResult();
 });
}