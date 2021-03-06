import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munin/config/application.dart';
import 'package:munin/widgets/shared/link/LinkTextSpan.dart';
import 'package:package_info/package_info.dart';
import 'package:quiver/time.dart';

void showMuninAboutDialog(BuildContext context) async {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = themeData.textTheme.bodyText1;
  final TextStyle linkStyle =
      themeData.textTheme.bodyText1.copyWith(color: themeData.accentColor);
  final Widget bangumiNLogo = SvgPicture.asset(
      'assets/logo/munin_logo_rounded.svg',
      width: 48.0,
      height: 48.0,
      semanticsLabel: 'BangumiN Logo');

  /// Gets package info, waits for up to one second.
  PackageInfo packageInfo = await PackageInfo.fromPlatform().timeout(
    aSecond,
    onTimeout: () {
      return PackageInfo(
        appName: 'BangumiN',
        packageName: 'BangumiN',
        version: '',
        buildNumber: '',
      );
    },
  );

  var additionalEnvironmentInfo = '';
  if (Application.environmentValue.environmentType !=
      EnvironmentType.Production) {
    additionalEnvironmentInfo =
    '${(Application.environmentValue.environmentType)}';
  }

  showAboutDialog(
    context: context,
    applicationName: 'BangumiN$additionalEnvironmentInfo',
    applicationVersion: packageInfo.version,
    applicationIcon: bangumiNLogo,
    applicationLegalese: 'BangumiN Project Authors',
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                style: aboutTextStyle,
                text: 'BanguminN（读作Bangu-min或Bangumi-N）是一个基于Flutter开发的'
                    'Bangumi第三方app。 ',
              ),
              TextSpan(
                style: aboutTextStyle,
                text: '\n\nBanguminN的开发代码开源，发布在',
              ),
              LinkTextSpan(
                style: linkStyle,
                url: 'https://github.com/edwardez/bangumin',
                text: 'Github',
              ),
              TextSpan(
                style: aboutTextStyle,
                text: '.',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
