import 'package:flutter/material.dart';
import 'package:munin/models/bangumi/user/social/NetworkServiceTag.dart';
import 'package:munin/models/bangumi/user/social/NetworkServiceTagLink.dart';
import 'package:munin/widgets/shared/services/Clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkServiceTagWidget extends StatelessWidget {
  final NetworkServiceTag tag;

  const NetworkServiceTagWidget({Key key, @required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLink = tag.isLink;
    TextStyle contentTextStyle = Theme.of(context).textTheme.body1;

    if (isLink) {
      contentTextStyle =
          contentTextStyle.copyWith(color: Theme.of(context).primaryColor);
    }

    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Chip(
            backgroundColor: tag.type.themeColor,
            label: Text(
              tag.type.name,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 6.0),
            child: Text(
              tag.content,
              style: contentTextStyle,
            ),
          ),
        ],
      ),
      onTap: () {
        if (isLink) {
          launch((tag as NetworkServiceTagLink).link, forceSafariVC: true);
        } else {
          ClipboardService.copyConfirmationDialog(context, tag.content);
        }
      },
      onLongPress: () {
        String textToCopy;
        if (isLink) {
          textToCopy = (tag as NetworkServiceTagLink).link;
        } else {
          textToCopy = tag.content;
        }
        ClipboardService.copyConfirmationDialog(context, textToCopy);
      },
    );
    ;
  }
}