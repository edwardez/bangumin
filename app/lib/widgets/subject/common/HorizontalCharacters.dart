import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/mono/Character.dart';
import 'package:munin/models/bangumi/timeline/common/BangumiContent.dart';
import 'package:munin/styles/theme/Common.dart';
import 'package:munin/widgets/shared/common/HorizontalScrollableWidget.dart';
import 'package:munin/widgets/shared/images/RoundedElevatedImageWithBottomText.dart';

class HorizontalCharacters extends StatelessWidget {
  static const characterNameMaxLines = 1;
  static const actorNameMaxLines = 1;
  static const double textSpaceScaleBaseFactor = 1.5;

  final BuiltList<Character> characters;

  final double imageWidth;
  final double imageHeight;

  const HorizontalCharacters(
      {Key key,
      @required this.characters,
      this.imageHeight = 60.0,
      this.imageWidth = 60.0})
      : super(key: key);

  _BuildCharactersListResult _buildCharactersList(
      BuiltList<Character> characters) {
    bool noCharacterHasActor = true;

    List<RoundedElevatedImageWithBottomText> imageWidgets = [];
    for (var character in characters) {
      if (character.actors.length != 0) {
        noCharacterHasActor = false;
      }
      imageWidgets.add(RoundedElevatedImageWithBottomText(
        contentType: BangumiContent.Character,
        /// TODO: grid/small stores a low-resolution size avatar, medium/large stores a hi-res one
        /// However Bangumi allows user to crop image and produces a corresponding small/grid image
        /// We can let user select using a high-res but incorrectly cropped version
        /// Or a lo-res but correctly cropped version
        imageUrl: character.avatar.grid,
        id: character.id.toString(),
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        padding: EdgeInsets.only(right: mediumOffset),
        title: character.name,
        subtitle:
            character.actors.length == 0 ? null : character.actors[0].name,
        titleMaxLines: characterNameMaxLines,
        subTitleMaxLines: actorNameMaxLines,
      ));
    }

    return _BuildCharactersListResult(imageWidgets, noCharacterHasActor);
  }

  @override
  Widget build(BuildContext context) {
    final buildCharactersListResult = _buildCharactersList(characters);
    final systemScaleFactor = MediaQuery
        .of(context)
        .textScaleFactor;

    double calculatedTextScaleFactor;
    if (buildCharactersListResult.noCharacterHasActor) {
      calculatedTextScaleFactor =
          characterNameMaxLines * textSpaceScaleBaseFactor;
    } else {
      calculatedTextScaleFactor = (characterNameMaxLines + actorNameMaxLines) *
          textSpaceScaleBaseFactor;
    }

    calculatedTextScaleFactor *= systemScaleFactor;

    return HorizontalScrollableWidget(
      horizontalList: buildCharactersListResult.widgets,
      listHeight: imageHeight +
          Theme
              .of(context)
              .textTheme
              .caption
              .fontSize *
              calculatedTextScaleFactor,
    );
  }
}

class _BuildCharactersListResult {
  final List<RoundedElevatedImageWithBottomText> widgets;
  final bool noCharacterHasActor;

  _BuildCharactersListResult(this.widgets, this.noCharacterHasActor);
}
