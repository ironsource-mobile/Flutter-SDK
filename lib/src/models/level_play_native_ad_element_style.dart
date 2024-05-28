import 'dart:ui';

/// Class for styling native ad element
class LevelPlayNativeAdElementStyle {
  final Color? backgroundColor;
  final double? textSize;
  final Color? textColor;
  final LevelPlayNativeTemplateFontStyle? fontStyle;
  final double? cornerRadius;

  LevelPlayNativeAdElementStyle({
    this.backgroundColor,
    this.textSize,
    this.textColor,
    this.fontStyle,
    this.cornerRadius,
  });

  Map<String, dynamic>? toMap() {
    return <String, dynamic> {
      "backgroundColor": backgroundColor?.value,
      "textSize": textSize,
      "textColor": textColor?.value,
      "fontStyle": fontStyle?.toString(),
      "cornerRadius": cornerRadius,
    };
  }
}

enum LevelPlayNativeTemplateFontStyle {
  normal,
  bold,
  italic,
  monospace
}