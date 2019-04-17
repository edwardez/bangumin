import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:munin/widgets/shared/chips/StrokeChoiceChip.dart';

typedef ToChipStringName<U> = String Function(U chip);

typedef OnChipSelected<U> = void Function(U chip);

/// A list of filter chips group
class FilterChipsGroup<T> extends StatefulWidget {
  /// Padding between chips, padding won't be inserted before the first chip
  final double paddingBetweenChips;

  /// List of filter chips
  final List<T> filterChips;

  /// A callback function that can find the name of the chip
  /// If unset, [T.toString()] will be used
  final ToChipStringName<T> getChipName;

  final OnChipSelected<T> onChipSelected;

  /// The current [selectedChip]
  /// If [selectedChip] is null, all chips will be rendered in unselected state
  /// If [selectedChip] is not null, it must be in [filterChips]
  final T selectedChip;

  FilterChipsGroup({
    Key key,
    @required this.filterChips,
    @required this.selectedChip,
    this.onChipSelected,
    this.getChipName,
    this.paddingBetweenChips = 4.0,
  })  : assert(selectedChip == null || filterChips.contains(selectedChip)),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilterChipsGroupState<T>();
  }
}

class _FilterChipsGroupState<T> extends State<FilterChipsGroup<T>> {
  T currentSelectedChipType;

  @override
  void initState() {
    super.initState();
    currentSelectedChipType = widget.selectedChip;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chipWidgets = [];

    for (T filterChip in widget.filterChips) {
      bool isSelected = currentSelectedChipType == filterChip;
      bool isFirstChip = chipWidgets.isEmpty;
      String chipName;
      if (widget.getChipName != null) {
        chipName = widget.getChipName(filterChip);
      } else {
        chipName = filterChip.toString();
      }

      chipWidgets.add(Padding(
        padding: isFirstChip
            ? EdgeInsets.zero
            : EdgeInsets.only(left: widget.paddingBetweenChips),
        child: StrokeChoiceChip(
          label: Text(
            chipName,
          ),
          selected: isSelected,
          onSelected: (isSelected) {
            if (isSelected) {
              setState(() {
                currentSelectedChipType = filterChip;
              });

              if (widget.onChipSelected != null) {
                widget.onChipSelected(filterChip);
              }
            }
          },
          labelStyle: Theme.of(context).chipTheme.labelStyle.copyWith(
              color: isSelected ? Theme.of(context).primaryColor : null),
        ),
      ));
    }

    /// TODO: figure out a better way ro constraint list size
    return Container(
      height: Theme.of(context).textTheme.body1.fontSize * 3.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          return chipWidgets[index];
        },
        itemCount: chipWidgets.length,
      ),
    );
  }
}