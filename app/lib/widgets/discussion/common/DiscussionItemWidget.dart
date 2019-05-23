import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/discussion/DiscussionItem.dart';
import 'package:munin/models/bangumi/discussion/GroupDiscussionPost.dart';
import 'package:munin/shared/utils/time/TimeUtils.dart';
import 'package:munin/widgets/shared/cover/CachedRoundedCover.dart';
import 'package:munin/widgets/shared/text/WrappableText.dart';
import 'package:munin/widgets/shared/utils/common.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class DiscussionItemWidget extends StatelessWidget {
  static const titleMaxLines = 2;
  static const subTitleMaxLines = 2;
  static const double smallPadding = 8.0;

  final DiscussionItem discussionItem;

  /// Checks the item is muted
  /// Currently only [GroupDiscussionPost] correctly returns its mute status
  final bool Function(DiscussionItem item) isMuted;

  /// Called when user requests a mute
  /// Currently only group discussion triggers this function
  final Function(DiscussionItem item) onMute;

  /// Called when user requests a unmute
  /// Currently only group discussion triggers this function
  final Function(DiscussionItem item) onUnmute;

  const DiscussionItemWidget({Key key,
    @required this.discussionItem,
    @required this.isMuted,
    @required this.onMute,
    @required this.onUnmute})
      : super(key: key);

  String getImageUrl(DiscussionItem discussionItem) {
    /// For mono, grid image is manually cropped by user which is more likely
    /// to result in a correct cropping
    if (discussionItem.bangumiContent.isMono) {
      return discussionItem.image.grid;
    }

    return discussionItem.image.medium;
  }

  GestureLongPressCallback _generateOnLongPressCallback(BuildContext context) {
    if (discussionItem is! GroupDiscussionPost) {
      return null;
    }

    Widget muteOptionWidget;
    if (isMuted(discussionItem)) {
      muteOptionWidget = ListTile(
        leading: Icon(OMIcons.clear),
        title: Text('解除屏蔽小组 ${discussionItem.subTitle}'),
        onTap: () {
          onUnmute(discussionItem);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("${discussionItem.subTitle} 将会被解除屏蔽，下次刷新数据后生效"),));
          Navigator.of(context).pop();
        },
      );
    } else {
      muteOptionWidget = ListTile(
        leading: Icon(OMIcons.block),
        title: Text('屏蔽小组 ${discussionItem.subTitle}'),
        onTap: () {
          onMute(discussionItem);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("${discussionItem.subTitle} 将会被屏蔽，下次刷新数据后生效"),));
          Navigator.of(context).pop();
        },
      );
    }

    return () {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: muteOptionWidget,
            );
          });
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: smallPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedRoundedCover.asGridSize(
              imageUrl: getImageUrl(discussionItem),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: smallPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      maxLines: titleMaxLines,
                      text: TextSpan(children: [
                        TextSpan(
                            text: discussionItem.title,
                            style: Theme.of(context).textTheme.body1),
                        TextSpan(
                          text: ' (+${discussionItem.replyCount})',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ]),
                    ),
                    Row(
                      children: <Widget>[
                        WrappableText(
                          '${discussionItem.subTitle}',
                          textStyle: Theme.of(context).textTheme.caption,
                          fit: FlexFit.tight,
                          maxLines: subTitleMaxLines,
                        ),
                        Text(
                          TimeUtils.formatMilliSecondsEpochTime(
                              discussionItem.updatedAt,
                              displayTimeIn: DisplayTimeIn.AlwaysRelative,
                              fallbackTimeStr: ''),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: generateOnTapCallbackForBangumiContent(
          contentType: discussionItem.bangumiContent,
          id: discussionItem.id.toString(),
          context: context),
      onLongPress: _generateOnLongPressCallback(context),
    );
  }
}
