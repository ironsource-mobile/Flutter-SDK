import 'package:flutter/services.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';

import '../ironsource_constants.dart';
import '../parsers/incoming_value_parser.dart';

/// For LevelPlayListeners
class LevelPlayNativeAd with LevelPlayNativeAdListener{
  String? placementName;
  LevelPlayNativeAdListener? listener;
  final String? title;
  final String? body;
  final String? advertiser;
  final String? callToAction;
  final LevelPlayNativeAdIcon? icon;
  MethodChannel? methodChannel;

  LevelPlayNativeAd({
    this.placementName,
    this.listener,
    this.title,
    this.body,
    this.advertiser,
    this.callToAction,
    this.icon,
  });

  void setMethodChannel(MethodChannel? methodChannel) {
    this.methodChannel = methodChannel;
    // Set handler for every method call
    methodChannel?.setMethodCallHandler(_onNativeAdMethodCall);
  }

  void setListener(LevelPlayNativeAdListener? listener) {
    this.listener = listener;
  }

  void setPlacementName(String? placementName) {
    this.placementName = placementName;
  }

  LevelPlayNativeAd? _extractCompletedNativeAd(dynamic args) {
    final nativeAd = IncomingValueParser.getLevelPlayNativeAd(IncomingValueParser.getValueForKey(IronConstKey.NATIVE_AD, args));
    // Copy existing variables to complete the native ad object
    nativeAd.methodChannel = methodChannel;
    nativeAd.listener = listener;
    nativeAd.placementName = placementName;
    return nativeAd;
  }

  /// Handle various method calls from the native platform
  Future<dynamic> _onNativeAdMethodCall(MethodCall call) async {
    switch(call.method) {
      case 'onAdLoaded':
        // Extract native ad and ad info from arguments
        final nativeAd = _extractCompletedNativeAd(call.arguments);
        final adInfo = IncomingValueParser.getAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        // Notify user on ad loaded event
        listener?.onAdLoaded(nativeAd, adInfo);
        break;
      case 'onAdLoadFailed':
        // Extract native ad and error from arguments
        final nativeAd = _extractCompletedNativeAd(call.arguments);
        final error = IncomingValueParser.getIronSourceError(IncomingValueParser.getValueForKey(IronConstKey.ERROR, call.arguments));
        // Notify user on ad load failed event
        listener?.onAdLoadFailed(nativeAd, error);
        break;
      case 'onAdImpression':
        // Extract native ad and ad info from arguments
        final nativeAd = _extractCompletedNativeAd(call.arguments);
        final adInfo = IncomingValueParser.getAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        // Notify user on ad load impression event
        listener?.onAdImpression(nativeAd, adInfo);
        break;
      case 'onAdClicked':
        // Extract native ad and ad info from arguments
        final nativeAd = _extractCompletedNativeAd(call.arguments);
        final adInfo = IncomingValueParser.getAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        // Notify user on ad load clicked event
        listener?.onAdClicked(nativeAd, adInfo);
        break;
      default: break;
    }
  }

  void loadAd() {
    methodChannel?.invokeMethod('loadAd');
  }

  void destroyAd() {
    methodChannel?.invokeMethod('destroyAd');
  }

  @override
  String toString() {
    return 'IronSourceNativeAd{title: $title, body: $body, advertiser: $advertiser, callToAction: $callToAction, iconUriString: ${icon?.uri}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelPlayNativeAd &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          body == other.body &&
          advertiser == other.advertiser &&
          callToAction == other.callToAction &&
          icon == other.icon;

  @override
  int get hashCode =>
      title.hashCode ^
      body.hashCode ^
      advertiser.hashCode ^
      callToAction.hashCode ^
      icon.hashCode;

  @override
  void onAdClicked(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    listener?.onAdClicked(nativeAd, adInfo);
  }

  @override
  void onAdImpression(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    listener?.onAdImpression(nativeAd, adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd? nativeAd, IronSourceError? error) {
    listener?.onAdLoadFailed(nativeAd, error);
  }

  @override
  void onAdLoaded(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    listener?.onAdLoaded(nativeAd, adInfo);
  }

  /// Builder class for LevelPlayNativeAd
  static LevelPlayNativeAdBuilder builder() {
    return LevelPlayNativeAdBuilder();
  }
}

class LevelPlayNativeAdIcon {
  final String? uri;
  final Uint8List? imageData;

  LevelPlayNativeAdIcon(this.uri, this.imageData);

  // Method to check if the image data is valid
  bool isValidImageData() {
    return imageData != null && imageData!.isNotEmpty;
  }

  // Method to check if the uri is valid
  bool isValidUri() {
    if (uri == null) return false;
    try {
      Uri.parse(uri!);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'LevelPlayNativeAdIcon{uri: $uri, imageData: $imageData}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LevelPlayNativeAdIcon &&
              runtimeType == other.runtimeType &&
              uri == other.uri &&
              imageData == other.imageData;

  @override
  int get hashCode => uri.hashCode ^ imageData.hashCode;
}

/// Builder class for LevelPlayNativeAd
class LevelPlayNativeAdBuilder {
  String? placementName;
  LevelPlayNativeAdListener? listener;

  LevelPlayNativeAdBuilder();

  LevelPlayNativeAdBuilder withPlacementName(String placement) {
    placementName = placement;
    return this;
  }

  LevelPlayNativeAdBuilder withListener(LevelPlayNativeAdListener listener) {
    this.listener = listener;
    return this;
  }

  LevelPlayNativeAd build() {
    return LevelPlayNativeAd(
      placementName: placementName,
      listener: listener,
    );
  }
}