// ignore_for_file: non_constant_identifier_names

/// Banner Size
class IronSourceBannerSize {
  late final int _width;
  get width => _width;
  late final int _height;
  get height => _height;
  late final String _description;
  get description => _description;
  bool isAdaptive = false;

  /// private constructor to prevent description - WH conflicts
  IronSourceBannerSize._({width = 0, height = 0, required String description}) {
    _width = width;
    _height = height;
    _description = description;
  }

  static IronSourceBannerSize BANNER = IronSourceBannerSize._(description: "BANNER");
  static IronSourceBannerSize LARGE = IronSourceBannerSize._(description: "LARGE");
  static IronSourceBannerSize RECTANGLE = IronSourceBannerSize._(description: "RECTANGLE");
  static IronSourceBannerSize SMART = IronSourceBannerSize._(description: "SMART");

  static IronSourceBannerSize custom({required int width, required int height}) {
    return IronSourceBannerSize._(width: width, height: height, description: "CUSTOM");
  }

  @override
  String toString() {
    return _description == "CUSTOM" ? "$_description - w:$_width x h:$_height" : _description;
  }
}
