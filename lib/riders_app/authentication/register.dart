
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_tiffin/globalVariables/globleVariable.dart';
import 'package:my_tiffin/riders_app/homeScreens/home_screen.dart';
import 'package:my_tiffin/riders_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tiffin/riders_app/widgets/dialog_loading.dart';
import 'package:my_tiffin/riders_app/widgets/error_dialog.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formkey=  GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpassordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  XFile? imageXFile;

  Position? position;
  String completeAddress ='';
  String riderImageUrl ='';
  LocationPermission? permission;
  List<Placemark>? placeMarks;

  final ImagePicker _picker = ImagePicker();
  Future<void> _getImage() async{
    imageXFile= await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {

    permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position= newPosition;
    placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude
      );
    Placemark pMark = placeMarks![0];// return from 0 th index

    String completeAddress = '${pMark.subThoroughfare},${pMark.thoroughfare}${pMark.subLocality},${pMark.locality},${pMark.subAdministrativeArea},${pMark.administrativeArea},${pMark.postalCode},${pMark.country}';
   locationcontroller.text= completeAddress;
  }
// for number validation
  bool isNumeric(String value) {

    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(value);
  }

  Future<void> formValidation() async{
    if(imageXFile==null){
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: 'Please select an image',
            );
          }
        );
    }
    else
    {
      if(passwordcontroller.text==confirmpassordcontroller.text)
        {
          if(confirmpassordcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && phonecontroller.text.isNotEmpty && locationcontroller.text.isNotEmpty ) {
            if (isNumeric(phonecontroller.text)) {
              // start uploading data at first image
              showDialog(
                  context: context,
                  builder: (c) {
                    return const DialogLoading(
                      message: 'Signing Up',
                    );
                  }
              );
              String fileName = DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString();
              f_storage.Reference reference = f_storage.FirebaseStorage.instance
                  .ref().child('riders').child('fileName');
              f_storage.UploadTask uploadTask = reference.putFile(
                  File(imageXFile!.path));
              f_storage.TaskSnapshot taskSnapshot = await uploadTask
                  .whenComplete(() =>
              {
              }); // It provides information and status updates about the ongoing task.
              await taskSnapshot.ref.getDownloadURL().then((url) {
                riderImageUrl = url;

                //to save info to firestore
                authenticateAndSignUp();
              });
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorDialog(
                      message: 'Please enter valid phone number',
                    );
                  }
              );
            }
          } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return const ErrorDialog(
                      message: 'All fields must be filled',
                    );
                  }
              );
            }

        }
      else
        {
          showDialog(
              context: context,
              builder: (c) {
                return const ErrorDialog(
                  message: 'Please Enter same password',
                );
              }
          );
      }
    }
  }
  void authenticateAndSignUp() async{
    User?  currentRider;
    await firebaseAuth.createUserWithEmailAndPassword(
    email: emailcontroller.text.trim(),
    password: passwordcontroller.text.trim(),
    ).then((auth){
      currentRider = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder:(c)
      {
        return ErrorDialog(
          message:error.message.toString(),
        );
      });
    });
    if(currentRider!=null)
      {
        saveDataToFirestore(currentRider!).then((value){
          Navigator.pop(context);
          // sending user to home page
          Route newRoute = MaterialPageRoute(builder: (c)=>const  RiderHomeScreen());
          Navigator.pushReplacement(context, newRoute);
      });
      }
  }
  //To store data in firestore
  Future saveDataToFirestore (User currentRider) async{
    FirebaseFirestore.instance.collection('riders').doc(currentRider.uid).set({
      'riderId':currentRider.uid,
      'riderEmail':currentRider.email,
      'riderName':namecontroller.text.trim(),
      'riderPhone':phonecontroller.text.trim(),
      'riderAvatarUrl':riderImageUrl,
      'riderAdress':completeAddress,
      'status': "approved",
      'earnings':0.0,
      'lat':position?.latitude,
      'lng':position?.longitude,
      'role':'rider',
    });

    // to save data locally so that accessing data should be fast easy and reliable
    sharedPreferences= await SharedPreferences.getInstance();
  await sharedPreferences!.setString('uid', currentRider.uid);// key value pair
  await sharedPreferences!.setString('name', namecontroller.text.trim());
  await sharedPreferences!.setString('photoUrl',riderImageUrl );
    await sharedPreferences!.setString('role','rider');

}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children:  [
          const SizedBox(height:10,),
          InkWell(
            onTap: (){
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imageXFile==null?null: FileImage(File(imageXFile!.path)) ,
              child: imageXFile==null
                ?
                Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.grey,
                ):null,

            ),
          ),
          Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
                    child: CustomTextField(
                      data: Icons.person,
                      controller: namecontroller,
                      hintText: 'Name',
                      isObsecre: false,
                    ),),
                  Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
                    child: CustomTextField(
                    data: Icons.email,
                    controller: emailcontroller,
                    hintText: 'Email',
                    isObsecre: false,
                  ),),
                 Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
                   child: CustomTextField(
                    data: Icons.lock,
                    controller: passwordcontroller,
                    hintText: 'Password',
                    isObsecre: true,
                  ),),
                Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
                  child: CustomTextField(
                    data: Icons.lock,
                    controller: confirmpassordcontroller,
                    hintText: 'Confirm password',
                    isObsecre: true,
                  ),),
                Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
                   child: CustomTextField(
                    data: Icons.phone,
                    controller: phonecontroller,
                    hintText: 'Phone',
                    isObsecre: false,
                  ),),
                Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
                  child: CustomTextField(
                    data: Icons.my_location,
                    controller: locationcontroller,
                    hintText: 'Location',
                    isObsecre: false,
                    enabled: true,
                  ),),
                  Container(
                      width: 400,
                      height: 40,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(

                        onPressed: () {
                          getCurrentLocation();
                        },
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                          label: const Text('Get my location',
                            style: TextStyle(
                            color: Colors.white,
                          ),
                          ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      ),
                      )
                      ,),

                ],
              )
          ),
          const SizedBox(height: 30,),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            width: double.infinity,
            child:  ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor:Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                  color: Color(0xff5ac18e),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,

                ),
              ),
              onPressed: ()=>{
                formValidation(),
              }
            ),
          ),

          const SizedBox(height: 30,),
        ],
      ),
    ) ;



  }
}
