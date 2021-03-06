import 'package:flutter/material.dart';
import 'package:munin/styles/theme/Common.dart';

/// A read-only subject star widget
/// Currently max stars are 5
///
class SubjectStars extends StatelessWidget {
  final double subjectScore;
  final double starSize;

  /// Color of the activated star. Note that un-scored star is current hard-coded
  /// as the color of caption text color under current theme.
  final Color activateStarColor;

  ///Whether star should be resized by
  ///[MediaQuery.of(context).textScaleFactor]. Default to true.
  final bool scaleStarByTextScaleFactor;

  const SubjectStars({
    Key key,
    @required this.subjectScore,
    this.starSize = 18,
    this.activateStarColor = MuninColor.score,
    this.scaleStarByTextScaleFactor = true,
  }) : super(key: key);

  /// score: min 0.0, max 10.0
  List<Widget> _buildStarIconsWith5StarMax(BuildContext context, double score,
      double textScaleFactor) {
    Color starColor;
    if (score <= 0) {
      starColor = captionTextWithCustomizedOpacity(context, 0.6).color;
    } else {
      starColor = activateStarColor;
    }
    assert(score <= 10.0 && score >= 0.0);

    const maxStars = 5;
    final int numOfFullStars = score ~/ 2;
    final int numOfHalfStars = score % 2 < 1 ? 0 : 1;
    final int restOfStars = maxStars - numOfFullStars - numOfHalfStars;

    final scaledStarSize = textScaleFactor * starSize;

    return []
      ..addAll(List.generate(
          numOfFullStars,
          (index) =>
              Icon(Icons.star_rounded, size: scaledStarSize, color: starColor)))
      ..addAll(List.generate(
          numOfHalfStars,
          (index) => Icon(Icons.star_half_rounded,
              size: scaledStarSize, color: starColor)))
      ..addAll(List.generate(
          restOfStars,
          (index) => Icon(Icons.star_border_rounded,
              size: scaledStarSize, color: starColor)));
  }

  @override
  Widget build(BuildContext context) {
    if (subjectScore == null) {
      return ExcludeSemantics(child: Container());
    }

    final textScaleFactor = scaleStarByTextScaleFactor
        ? MediaQuery.of(context).textScaleFactor
        : 1.0;

    return Semantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _buildStarIconsWith5StarMax(
          context,
          subjectScore,
          textScaleFactor,
        ),
      ),
      label: '分数: $subjectScore',
    );
  }
}
