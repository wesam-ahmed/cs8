import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25,bottom: 10),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.white,Colors.grey],
                    begin:const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp,
                  )
              ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                  style: TextStyle(color: Colors.black,fontSize: 35 ,fontFamily: "Signatra"),
                ),
              ],
            ),
          ),
          SizedBox(height: 12,),
          Container(
            padding: EdgeInsets.only(top: 1),
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.white,Colors.grey],
                  begin:const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home,color: Colors.black,),
                  title: Text("Home",style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (C) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10,color: Colors.black,thickness: 6,),
                ListTile(
                  leading: Icon(Icons.shopping_bag,color: Colors.black,),
                  title: Text("My Orders",style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (C) => MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10,color: Colors.black,thickness: 6,),
                ListTile(
                  leading: Icon(Icons.shopping_cart,color: Colors.black,),
                  title: Text("My Cart",style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (C) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10,color: Colors.black,thickness: 6,),
                ListTile(
                  leading: Icon(Icons.search,color: Colors.black,),
                  title: Text("Search",style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (C) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10,color: Colors.black,thickness: 6,),
                ListTile(
                  leading: Icon(Icons.add_location_alt,color: Colors.black,),
                  title: Text("Add New Address",style: TextStyle(color: Colors.black),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (C) => AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10,color: Colors.black,thickness: 6,),
                ListTile(
                  leading: Icon(Icons.logout,color: Colors.black,),
                  title: Text("Logout",style: TextStyle(color: Colors.black),),
                  onTap: () {
                    EcommerceApp.auth.signOut().then((c) {
                      Route route = MaterialPageRoute(builder: (C) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(height: 10,color: Colors.black,thickness: 6,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
