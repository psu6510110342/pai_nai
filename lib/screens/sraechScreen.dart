import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pai_nai/Assistants/requestAssistant.dart';
import 'package:pai_nai/DataHandler/appData.dart';
import 'package:pai_nai/Models/address.dart';
import 'package:pai_nai/Models/placePredictions.dart';
import 'package:pai_nai/configMaps.dart';
import 'package:pai_nai/widgets/Divider.dart';
import 'package:pai_nai/widgets/progressDialog.dart';
import 'package:provider/provider.dart';

class SearchScreens extends StatefulWidget {
  @override
  _SearchScreensState createState() => _SearchScreensState();
}

class _SearchScreensState extends State<SearchScreens> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? '';
    pickUpTextEditingController.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          'Set Drop Off',
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            findPlace(val);
                          },
                          controller: pickUpTextEditingController,
                          decoration: InputDecoration(
                            hintText: 'PickUp Location',
                            fillColor: Colors.grey,
                            filled: true,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.only(left: 11, top: 8, bottom: 8),
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            findPlace(val);
                          },
                          controller: dropOffTextEditingController,
                          decoration: InputDecoration(
                            hintText: 'Where to?',
                            fillColor: Colors.grey,
                            filled: true,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.only(left: 11, top: 8, bottom: 8),
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (placePredictionList.length > 0)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return PredictionTile(
                        placePredictions: placePredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        DividerWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:th';

      var res = await RequestAssistant.getRequest(autoCompleteUrl);
     

      if (res == 'failed') {
        return;
      }
      print('Place Prediction Response :: ');
      print(res);
      if (res['status'] == 'OK') {
        var predictions = res['predictions'];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredictionTile({Key key, this.placePredictions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        getPlacerAddressDetails(placePredictions.place_id, context);
      },
          child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePredictions.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        placePredictions.secondary_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  void getPlacerAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: 'Setting Dropoff, Please wait...',
            ));
    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';

    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (res == 'failed') {
      return;
    }
    if (res['status'] == 'OK') {
      Address address = Address();
      address.placeName = res['result']['name'];
      address.placeId = placeId;
      address.latitude = res['result']['geometry']['location']['lat'];
      address.longitude = res['result']['geometry']['location']['lng'];
      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationaddress(address);
      print('This is Drop Off Location ::');
      print(address.placeName);
      Navigator.pop(context,'obtainDirection');
    }
  }
}
