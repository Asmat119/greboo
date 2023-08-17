import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';

const String iOSGoogleApiKey = "AIzaSyASRrlkBg6CYEnVbzZDtObouh2q6Pgm3es";
const String androidGoogleApiKey = "AIzaSyAn0Hpf17oBrRQ3NYI4lHr6A1GwdZl9M5Q";
UnderlineInputBorder border =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

class GoogleSearchPlace extends StatelessWidget {
  final TextEditingController searchController;

  const GoogleSearchPlace({Key? key, required this.searchController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        disposeKeyboard();
        buildGooglePlaceSearch();
      },
      validator: (val) =>
          searchController.text.isEmpty ? "please_select_a_location".tr : null,
      controller: searchController,
      readOnly: true,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        contentPadding: EdgeInsets.zero.copyWith(left: 10, right: 10),
        hintText: 'search_place'.tr,
        hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: getProportionateScreenWidth(13)),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          color: Color(0xff9C9C9C),
          onPressed: () {},
        ),
      ),
    );
  }

  static Future<LocationDetail> buildGooglePlaceSearch() async {
    var v = await PlacesAutocomplete.show(
        context: Get.context as BuildContext,
        apiKey: Platform.isIOS ? iOSGoogleApiKey : androidGoogleApiKey,
        onError: onError,
        //overlayBorderRadius: BorderRadius.circular(30),
        mode: Mode.overlay,
        language: "en",
        decoration: InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        logo: Text(''),
        components: [Component(Component.country, "PK")],
        region: 'PK',
        types: [],
        strictbounds: false);
    if (v != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: Platform.isIOS ? iOSGoogleApiKey : androidGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(v.placeId.toString());
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      return LocationDetail(
          late: lat, long: lng, address: v.description.toString());
    }
    return LocationDetail();
  }

  static onError(PlacesAutocompleteResponse response) {
    flutterToast(response.errorMessage.toString());
  }
}

class LocationDetail {
  final double late;
  final double long;
  final String address;

  LocationDetail({this.late = 0, this.long = 0, this.address = ""});
}
