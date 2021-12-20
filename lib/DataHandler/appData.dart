import 'package:flutter/cupertino.dart';
import 'package:pai_nai/Models/address.dart';


class AppData extends ChangeNotifier {
  Address pickUpLocation,dropOffLocation;
  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationaddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
  
}
