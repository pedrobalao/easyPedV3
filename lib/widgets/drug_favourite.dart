import 'package:easypedv3/repositories/repositories.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:flutter/material.dart';

class DrugFavourite extends StatefulWidget {
  const DrugFavourite({required this.drugId, super.key});

  final int drugId;
  @override
  DrugFavouriteState createState() => DrugFavouriteState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class DrugFavouriteState extends State<DrugFavourite> {
  final DrugRepository _drugRepository =
      DrugRepository(drugService: DrugService());
  bool _isFavourite = false;

  Future<void> fetchIsFavourite() async {
    final isFavourite = await _drugRepository.isFavourite(widget.drugId);

    setState(() {
      _isFavourite = isFavourite;
    });
  }

  Future<void> changeFavouriteFlag() async {
    var execRet = false;
    if (_isFavourite) {
      execRet = await _drugRepository.removeFavourite(widget.drugId);
    } else {
      execRet = await _drugRepository.addFavourite(widget.drugId);
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
