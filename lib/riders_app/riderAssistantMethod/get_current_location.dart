import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_tiffin/globalVariables/globleVariable.dart';

class UserLocation
{

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

    String completeAddress = '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
  }

}
