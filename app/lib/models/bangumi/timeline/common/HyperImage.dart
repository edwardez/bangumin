import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:munin/models/bangumi/common/BangumiImage.dart';
import 'package:munin/models/bangumi/timeline/common/BangumiContent.dart';
import 'package:munin/models/bangumi/timeline/common/HyperItem.dart';

part 'HyperImage.g.dart';

/// HyperImage: image with a clickable link
abstract class HyperImage
    implements Built<HyperImage, HyperImageBuilder>, HyperItem {
  /// id of the hyper text
  String get id;

  /// content type
  BangumiContent get contentType;

  BangumiImage get image;

  /// if we cannot parse content, a fallback webview might be used
  /// hence an optional link is needed
  @nullable
  String get pageUrl;

  HyperImage._();

  factory HyperImage([updates(HyperImageBuilder b)]) = _$HyperImage;

  static Serializer<HyperImage> get serializer => _$hyperImageSerializer;
}
