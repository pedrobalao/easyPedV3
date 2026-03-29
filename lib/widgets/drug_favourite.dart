import 'package:easypedv3/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrugFavourite extends ConsumerStatefulWidget {
  const DrugFavourite({required this.drugId, super.key});

  final int drugId;
  @override
  DrugFavouriteState createState() => DrugFavouriteState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class DrugFavouriteState extends ConsumerState<DrugFavourite> {
  bool _isFavourite = false;

  Future<void> fetchIsFavourite() async {
    final drugRepository = ref.read(drugRepositoryProvider);
    final isFavourite = await drugRepository.isFavourite(widget.drugId);

    setState(() {
      _isFavourite = isFavourite;
    });
  }

  Future<void> changeFavouriteFlag() async {
    final drugRepository = ref.read(drugRepositoryProvider);
    var execRet = false;
    if (_isFavourite) {
      execRet = await drugRepository.removeFavourite(widget.drugId);
    } else {
      execRet = await drugRepository.addFavourite(widget.drugId);
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
