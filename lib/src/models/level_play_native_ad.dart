import 'package:flutter/services.dart';

import './listeners/level_play_native_ad_listener.dart';

/// Class representing a level play native ad
class LevelPlayNativeAd {
  String? placementName;
  LevelPlayNativeAdListener? listener;
  final String? title;
  final String? body;
  final String? advertiser;
  final String? callToAction;
  final LevelPlayNativeAdIcon? icon;
  
  // Private callback functions assigned by LevelPlayNativeAdView
  Function()? _loadAdCallback;
  Function()? _destroyAdCallback;

  LevelPlayNativeAd({
    this.placementName,
    this.listener,
    this.title,
    this.body,
    this.advertiser,
    this.callToAction,
    this.icon,
  });

  void setListener(LevelPlayNativeAdListener? listener) {
    this.listener = listener;
  }

  void setPlacementName(String? placementName) {
    this.placementName = placementName;
  }
  
  // Internal setter methods for LevelPlayNativeAdView (not exposed to users in docs)
  void setLoadAdCallback(Function() callback) {
    _loadAdCallback = callback;
  }
  
  void setDestroyAdCallback(Function() callback) {
    _destroyAdCallback = callback;
  }
  
  // Load ad method - calls the callback assigned by LevelPlayNativeAdView
  void loadAd() {
    _loadAdCallback?.call();
  }
  
  // Destroy ad method - calls the callback assigned by LevelPlayNativeAdView
  void destroyAd() {
    _destroyAdCallback?.call();
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'advertiser': advertiser,
      'callToAction': callToAction,
      'icon': icon?.toMap()
    };
  }

  factory LevelPlayNativeAd.fromMap(dynamic args) {
    return LevelPlayNativeAd(
      title: args['title'] as String?,
      body: args['body'] as String?,
      advertiser: args['advertiser'] as String?,
      callToAction: args['callToAction'] as String?,
      icon: args['icon'] != null
          ? LevelPlayNativeAdIcon.fromMap(args['icon'])
          : null
    );
  }

  @override
  String toString() {
    return 'LevelPlayNativeAd{title: $title, body: $body, advertiser: $advertiser, callToAction: $callToAction, iconUriString: ${icon?.uri}';
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

  /// Builder class for LevelPlayNativeAd
  static LevelPlayNativeAdBuilder builder() {
    return LevelPlayNativeAdBuilder();
  }
}

class LevelPlayNativeAdIcon {
  final String? uri;
  final Uint8List? imageData;

  LevelPlayNativeAdIcon({this.uri, this.imageData});

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

  Map<String, dynamic> toMap() {
    return {
      'uri': uri,
      'imageData': imageData
    };
  }

  factory LevelPlayNativeAdIcon.fromMap(dynamic args) {
    return LevelPlayNativeAdIcon(
        uri: args['uri'] as String?,
        imageData: args['imageData'] as Uint8List?
    );
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