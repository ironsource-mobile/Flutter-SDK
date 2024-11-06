// ignore_for_file: non_constant_identifier_names
import '../utils/level_play_method_channel.dart';
import '../utils/ironsource_constants.dart';

/// Represents the size of an ad in LevelPlay.
class LevelPlayAdSize {
  final int width;
  final int height;
  final String? adLabel;
  final bool isAdaptive;

  static final _channel = LevelPlayMethodChannel().channel;

  LevelPlayAdSize._({
    required this.width,
    required this.height,
    this.adLabel,
    this.isAdaptive = false
  });

  static LevelPlayAdSize BANNER = LevelPlayAdSize._(width: IronConst.BANNER_WIDTH, height: IronConst.BANNER_HEIGHT, adLabel: IronConst.SIZE_BANNER);
  static LevelPlayAdSize LARGE = LevelPlayAdSize._(width: IronConst.LARGE_WIDTH, height: IronConst.LARGE_HEIGHT, adLabel: IronConst.SIZE_LARGE);
  static LevelPlayAdSize MEDIUM_RECTANGLE = LevelPlayAdSize._(width: IronConst.MEDIUM_RECTANGLE_WIDTH, height: IronConst.MEDIUM_RECTANGLE_HEIGHT, adLabel: IronConst.SIZE_MEDIUM_RECTANGLE);

  static LevelPlayAdSize createCustomSize({required int width, required int height}) {
    return LevelPlayAdSize._(width: width, height: height, adLabel: IronConst.SIZE_CUSTOM);
  }

  static LevelPlayAdSize createAdSize({required String adSize}) {
    switch(adSize) {
      case IronConst.SIZE_BANNER:
        return LevelPlayAdSize.BANNER;
      case IronConst.SIZE_LARGE:
        return LevelPlayAdSize.LARGE;
      case IronConst.SIZE_MEDIUM_RECTANGLE:
        return LevelPlayAdSize.MEDIUM_RECTANGLE;
      default:
        throw ArgumentError('Wrong Ad Size');
    }
  }

  static Future<LevelPlayAdSize?> createAdaptiveAdSize({int? width}) async {
    final sizeMap = await _channel.invokeMethod('createAdaptiveAdSize', { 'width': width });
    return sizeMap != null ? LevelPlayAdSize.fromMap(sizeMap) : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'adLabel': adLabel,
      'isAdaptive': isAdaptive,
    };
  }

  factory LevelPlayAdSize.fromMap(dynamic args) {
    return LevelPlayAdSize._(
      width: args['width'] as int,
      height: args['height'] as int,
      adLabel: args['adLabel'] as String?,
      isAdaptive: args['isAdaptive'] as bool,
    );
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is LevelPlayAdSize) &&
        other.width == width &&
        other.height == height &&
        other.adLabel == adLabel &&
        other.isAdaptive == isAdaptive;
  }

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      adLabel.hashCode ^
      isAdaptive.hashCode;

  String getDescription() {
    return '$adLabel';
  }

  @override
  String toString() {
    return '$adLabel ${width}x$height';
  }
}