import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/timeline/ProgressUpdateEpisodeUntil.dart';
import 'package:munin/widgets/shared/common/UserListTile.dart';
import 'package:munin/widgets/timeline/TimelineBodyWidget.dart';
import 'package:munin/widgets/timeline/item/common/FeedMoreActionsMenu.dart';

/// this currently applies to both book and tv shows(shares same route, layout, etc)
class ProgressUpdateEpisodeUntilWidget extends StatelessWidget {
  final ProgressUpdateEpisodeUntil progressUpdateEpisodeUntil;
  final int subjectNameMaxLines;
  final double verticalPadding;
  final DeleteFeedCallback onDeleteFeed;

  const ProgressUpdateEpisodeUntilWidget(
      {Key key,
      @required this.progressUpdateEpisodeUntil,
        @required this.onDeleteFeed,
        this.subjectNameMaxLines = 2,
        this.verticalPadding = 4.0
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UserListTile.fromUser(
          user: progressUpdateEpisodeUntil.user,
          trailing: buildTrailingWidget(
              progressUpdateEpisodeUntil, onDeleteFeed),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: InkWell(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    progressUpdateEpisodeUntil.subjectName,
                    maxLines: subjectNameMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onTap: () => {},
          ),
        )
      ],
    );
  }
}
