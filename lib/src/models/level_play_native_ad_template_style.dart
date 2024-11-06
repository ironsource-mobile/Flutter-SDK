import 'dart:ui';

import './level_play_native_ad_element_style.dart';

/// Class for styling native ad elements
class LevelPlayNativeAdTemplateStyle {
  final Color? mainBackgroundColor;
  final LevelPlayNativeAdElementStyle? titleStyle;
  final LevelPlayNativeAdElementStyle? bodyStyle;
  final LevelPlayNativeAdElementStyle? advertiserStyle;
  final LevelPlayNativeAdElementStyle? callToActionStyle;

  LevelPlayNativeAdTemplateStyle({
    this.mainBackgroundColor,
    this.titleStyle,
    this.bodyStyle,
    this.advertiserStyle,
    this.callToActionStyle,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "mainBackgroundColor": mainBackgroundColor?.value,
      "titleStyle": titleStyle?.toMap(),
      "bodyStyle": bodyStyle?.toMap(),
      "advertiserStyle": advertiserStyle?.toMap(),
      "callToActionStyle": callToActionStyle?.toMap(),
    };
  }
}