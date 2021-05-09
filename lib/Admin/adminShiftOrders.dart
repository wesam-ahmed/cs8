import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import '../Widgets/loadingWidget.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  Future<bool> _backAdmin()async{
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPage()));
  }
  String dropdownValue_Section ;
  String dropdownValue_Category ;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backAdmin,
      child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title: Text("My Orders",style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPage()));
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              /* Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    hint: dropdownValue_Section == null
                        ? Text('Men')
                        : Text(dropdownValue_Section),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue_Section = newValue;
                      });
                    },
                    items: <String>['Men', 'Woman', 'Kids', 'Used']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
                  DropdownButton<String>(
                    hint: dropdownValue_Category == null
                        ? Text('Category')
                        : Text(dropdownValue_Category),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue_Category = newValue;
                      });
                    },
                    items: <String>['Shoes', 'Shirts', 'T-Shirt', 'Pants','Jackets']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                  ),
                ],
              ),*/
              Expanded(
                child:StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("orders").snapshots(),

                builder: (c,snapshot){
                  return snapshot.hasData
                      ?ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (c,index){
                      return FutureBuilder<QuerySnapshot>(
                        future:Firestore.instance.
                        collection("items").where("idItem",
                            whereIn: snapshot.data.documents[index].data[EcommerceApp.productID]).getDocuments(),

                        builder: (c,snap){
                          return snap.hasData ?
                          AdminOrderCard(
                            itemCount: snap.data.documents.length,
                            data: snap.data.documents,
                            orderId: snapshot.data.documents[index].documentID,
                            orderBy: snapshot.data.documents[index].data["orderBy"],
                            addressID: snapshot.data.documents[index].data["addressID"],
                            category: dropdownValue_Category,
                            section:dropdownValue_Section ,
                          )
                              :Center(child: circularProgress(),);


                        },
                      );
                    },
                  )
                      : Center(child: circularProgress(),);
                },
              ),
              )
            ],
          ),
        )
      ),
    ),
    );
  }
}
