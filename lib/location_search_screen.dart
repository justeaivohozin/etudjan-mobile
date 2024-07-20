import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:etudjan/components/location_list_tile.dart';
import 'package:etudjan/components/request_service.dart';
import 'package:etudjan/models/auto_complete_prediction.dart';
import 'package:etudjan/models/place_auto_complete_response.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> placePredictions = [];

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": query, "key": "AIzaSyBIl5Bm_cBNlCk2cXBXWbsOAiZpR-ta1sI"});
    String? response = await RequestService.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 194, 52, 255),
            child: SvgPicture.asset(
              "assets/icons/location.svg",
              color: Colors.white,
              height: 16,
            ),
          ),
        ),
        title: const Text("Trouvez une adresse"),
      ),
      body: Column(children: [
        Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                placeAutocomplete(value);
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(hintText: "Rechercher une adresse"),
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.black45,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              print("hello");
              placeAutocomplete("Cocotomey");
            },
            icon: SvgPicture.asset(
              "assets/icons/location.svg",
              height: 16,
            ),
            label: const Text("Rechercher"),
            style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: const Size(
                  double.infinity,
                  40,
                )),
          ),
        ),
        const Divider(
          height: 2,
          thickness: 1,
          color: Colors.grey,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => LocationListTile(
                location: placePredictions[index].description!,
                press: () {
                  print(placePredictions[index]);
                }),
          ),
        )
      ]),
    );
  }
}
