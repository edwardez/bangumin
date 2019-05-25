import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/user/UserProfile.dart';
import 'package:munin/models/bangumi/user/timeline/TimelinePreview.dart';
import 'package:munin/router/routes.dart';
import 'package:munin/shared/utils/time/TimeUtils.dart';
import 'package:munin/widgets/shared/icons/AdaptiveIcons.dart';
import 'package:munin/widgets/shared/text/WrappableText.dart';
import 'package:munin/widgets/timeline/Timeline.dart';

class TimelinePreviewWidget extends StatelessWidget {
  final UserProfile profile;

  const TimelinePreviewWidget({Key key, @required this.profile})
      : super(key: key);

  RichText _buildFeed(BuildContext context, TimelinePreview previewFeed) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: '•  ${previewFeed.content}',
            style: Theme.of(context).textTheme.body1),
        TextSpan(
            text:
                ' ${TimeUtils.formatMilliSecondsEpochTime(previewFeed.userUpdatedAt, displayTimeIn: DisplayTimeIn.AlwaysRelative)}',
            style: Theme.of(context).textTheme.caption),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              WrappableText(
                '时间胶囊',
                fit: FlexFit.tight,
                textStyle: Theme.of(context).textTheme.subhead,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  AdaptiveIcons.forwardIconData,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (TimelinePreview preview in profile.timelinePreviews)
                _buildFeed(context, preview)
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Scaffold(
                  body: MuninTimeline.onUserProfile(
                    username: profile.basicInfo.username,
                  ),
                ),
            settings: RouteSettings(
                name: Routes.userProfileTimelineRoute.replaceAll(
                    ':username', profile.basicInfo.username)),
          ),
        );
      },
    );
  }
}
