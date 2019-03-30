import 'package:flutter/material.dart';
import 'package:munin/models/Bangumi/subject/Subject.dart';
import 'package:munin/widgets/shared/icons/PlatformIcons.dart';
import 'package:munin/widgets/shared/services/Clipboard.dart';
import 'package:share/share.dart';

void _settingModalBottomSheet(BuildContext context, Subject subject) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.content_copy),
                  title: Text('复制标题'),
                  onTap: () {
                    ClipboardService.copyAsPlainText(context, subject.name,
                        popContext: true);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.content_copy),
                  title: Text('复制简介'),
                  onTap: () {
                    ClipboardService.copyAsPlainText(context, subject.summary,
                        popContext: true);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.content_copy),
                  title: Text('复制Staff信息'),
                  onTap: () {
                    ClipboardService.copyAsPlainText(
                        context, subject.infoBoxRowsPlainText,
                        popContext: true);
                  },
                ),
              ],
            ),
          ),
        );
      });
}

/// A list of common actions on subject page AppBar
List<Widget> subjectCommonActions(BuildContext context, Subject subject) {
  return [
    IconButton(
      icon: Icon(PlatformIcons.shareIconData),
      onPressed: () {
        Share.share('分享一个作品 ${subject.name} ${subject.pageUrlFromCalculation}');
      },
    ),
    IconButton(
      icon: Icon(PlatformIcons.moreActionsIconData),
      onPressed: () {
        _settingModalBottomSheet(context, subject);
      },
    ),
  ];
}