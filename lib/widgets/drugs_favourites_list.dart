import 'package:easypedv3/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrugsFavouritesList extends StatelessWidget {
  const DrugsFavouritesList({
    required this.drugs,
    this.onSelect,
    this.selectedId,
    super.key,
  });

  final List<Drug> drugs;

  /// When provided (wide screens), called with the drug id instead of
  /// navigating to the detail route.
  final ValueChanged<int>? onSelect;

  /// Highlights the card for the currently selected drug (wide screens).
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final drug = drugs[index];
        final isSelected = selectedId != null && drug.id == selectedId;
        return Card(
            color: isSelected
                ? Theme.of(context).colorScheme.secondaryContainer
                : null,
            child: ListTile(
              title: Hero(
                tag: 'drug-name-${drug.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(drug.name ?? '',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
              subtitle: Text(drug.subcategoryDescription ?? '',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                final id = drug.id;
                if (onSelect != null && id != null) {
                  onSelect!(id);
                } else {
                  context.push('/drugs/$id');
                }
              },
            ));
      },
      itemCount: drugs.length,
    );
  }
}

