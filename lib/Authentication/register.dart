import 'dart:io';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

import '../Widgets/customTextField.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cpasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10),
            InkWell(
              onTap: () {
               _selectAndPickImage();
              },
              child: CircleAvatar(
                radius: _screenWidth *0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile ==null ? Icon(Icons.add_photo_alternate,size: _screenWidth*0.15,color: Colors.grey,):
                null,
              ) ,
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.person,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: (){
                uploadAndSaveImage();
              },
              color: Colors.white,
              child: Text("Sign up",style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 30),
            Container(height: 4,
            width: _screenWidth*0.8,
            color: Colors.white,),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
  Future<void> _selectAndPickImage() async
  {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  Future<void> uploadAndSaveImage() async
  {
    if(_imageFile==null)
    {
      showDialog(
        context: context,
        builder: (c)
          {
            return ErrorAlertDialog(message: "PLease select an image file ",);
          }
      );
    }
    else
      {
        _passwordTextEditingController.text == _cpasswordTextEditingController.text ?
                _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cpasswordTextEditingController.text.isNotEmpty &&
                    _nameTextEditingController.text.isNotEmpty ?
                    uploadToStorage() :
                displayDialog("Please fill up registration complete form.."):
                displayDialog("Password do not match.");
      }
  }
  displayDialog(String msg)
  {
    showDialog(
        context: context,
        builder: (c)
    {
      return ErrorAlertDialog(message: msg,);
    }
    );
  }
  uploadToStorage() async
  {
    showDialog(
        context: context,
        builder: (c)
    {
      return LoadingAlertDialog(message: "Authentication, Please wait.....");
    });
    String imageFileName =DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask =storageReference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((urlImage)
    {
      userImageUrl=urlImage;
      _registerUser();
    });
  }
  _registerUser()
  {

  }
}

