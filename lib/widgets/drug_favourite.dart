import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../services/drugs_service.dart';

class DrugFavourite extends StatefulWidget {
  const DrugFavourite({Key? key, required this.drugId}) : super(key: key);

  final int drugId;
  @override
  DrugFavouriteState createState() => DrugFavouriteState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class DrugFavouriteState extends State<DrugFavourite> {
  final DrugService _drugService = DrugService();
  final AuthenticationService _authenticationService = AuthenticationService();
  bool _isFavourite = false;

  fetchIsFavourite() async {
    var isFavourite = await _drugService.fetchIsFavourite(
        widget.drugId, await _authenticationService.getUserToken());

    setState(() {
      _isFavourite = isFavourite;
    });
  }

  changeFavouriteFlag() async {
    bool execRet = false;
    if (_isFavourite) {
      execRet = await _drugService.deleteFavourite(
          widget.drugId, await _authenticationService.getUserToken());
    } else {
      execRet = await _drugService.addFavourite(
          widget.drugId, await _authenticationService.getUserToken());
    }

    if (execRet) {
      setState(() {
        _isFavourite = !_isFavourite;
      });
    }
  }

  @override
  void initState() {
    fetchIsFavourite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: _isFavourite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_outline),
        onPressed: () async {
          await changeFavouriteFlag();
        });
  }
}
