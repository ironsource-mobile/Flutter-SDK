import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/ironsource_constants.dart';
import '../models/listeners/level_play_banner_ad_view_listener.dart';
import '../models/level_play_ad_size.dart';
import '../models/level_play_ad_info.dart';
import '../models/level_play_ad_error.dart';

/// [LevelPlayBannerAdView] is the widget that contains the banner elements
///  and must be created in order load banner ad
class LevelPlayBannerAdView extends StatefulWidget {

  /// A unique ad unit id for banner
  final String adUnitId;

  /// The banner ad size elements
  final LevelPlayAdSize adSize;

  /// A listener to banner ad view events
  final LevelPlayBannerAdViewListener listener;

  /// A placement string for the banner ad
  final String? placementName;

  /// An optional bid floor
  final double? bidFloor;

  /// Placement for banner
  final VoidCallback? onPlatformViewCreated;

  /// Constructs an instance of [LevelPlayBannerAdView].
   const LevelPlayBannerAdView({
    super.key,
    required this.adUnitId,
    required this.adSize,
    required this.listener,
    this.placementName,
    this.bidFloor,
    this.onPlatformViewCreated,
  }) : assert(key is GlobalKey<LevelPlayBannerAdViewState>, 'Key must be a GlobalKey<LevelPlayBannerAdViewState>');

  GlobalKey<LevelPlayBannerAdViewState> get _globalKey => key as GlobalKey<LevelPlayBannerAdViewState>;

  /// Method to load the ad and add the view to screen
  Future<void> loadAd() async => await _globalKey.currentState?.loadAd();

  /// Method to destroy the ad and remove the view from screen
  Future<void> destroy() async => await _globalKey.currentState?.destroy();

  /// Method to pause the auto refresh of the banner
  Future<void> pauseAutoRefresh() async => await _globalKey.currentState?.pauseAutoRefresh();

  /// Method to resume(after pause) the auto refresh of the banner
  Future<void> resumeAutoRefresh() async => await _globalKey.currentState?.resumeAutoRefresh();

  /// Provides access to the `adId`
  String get adId {
    return _globalKey.currentState?._adId ?? "";
  }

  @override
  State<LevelPlayBannerAdView> createState() => LevelPlayBannerAdViewState();
}

class LevelPlayBannerAdViewState extends State<LevelPlayBannerAdView> {
  final String viewType = 'levelPlayBannerAdView';
  MethodChannel? channel;
  String _adId = "";

  Future<void> _onPlatformViewCreated(int id) async {
    final String methodChannelName = '${viewType}_$id';
    channel = MethodChannel(methodChannelName);
    channel!.setMethodCallHandler(_onNativeAdMethodCall);
    _adId = await channel?.invokeMethod('getAdId');
    // Notify on ad view creation
    widget.onPlatformViewCreated?.call();
  }

  Future<void> loadAd() async => await channel?.invokeMethod('loadAd');
  Future<void> destroy() async => await channel?.invokeMethod('destroyBanner');
  Future<void> pauseAutoRefresh() async => await channel?.invokeMethod('pauseAutoRefresh');
  Future<void> resumeAutoRefresh() async => await channel?.invokeMethod('resumeAutoRefresh');

  String get adId {
    return _adId;
  }

  @override
  Widget build(BuildContext context) {
    final creationParams = <String, dynamic>{
      'adUnitId': widget.adUnitId,
      'placementName': widget.placementName,
      'viewType': viewType,
      'adSize': widget.adSize.toMap(),
    };

    if (widget.bidFloor != null) {
      creationParams['bidFloor'] = widget.bidFloor;
    }

    return Platform.isAndroid ? AndroidView(
      viewType: viewType,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    ) : Platform.isIOS ? UiKitView(
      viewType: viewType,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,) : Container();
  }

  Future<dynamic> _onNativeAdMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        widget.listener.onAdLoaded(adInfo);
        break;
      case 'onAdLoadFailed':
        final error = LevelPlayAdError.fromMap(call.arguments[IronConstKey.ERROR]);
        widget.listener.onAdLoadFailed(error);
        break;
      case 'onAdDisplayed':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        widget.listener.onAdDisplayed(adInfo);
        break;
      case 'onAdDisplayFailed':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final error = LevelPlayAdError.fromMap(call.arguments[IronConstKey.ERROR]);
        widget.listener.onAdDisplayFailed(adInfo, error);
        break;
      case 'onAdClicked':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        widget.listener.onAdClicked(adInfo);
        break;
      case 'onAdExpanded':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        widget.listener.onAdExpanded(adInfo);
        break;
      case 'onAdCollapsed':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        widget.listener.onAdCollapsed(adInfo);
        break;
      case 'onAdLeftApplication':
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        widget.listener.onAdLeftApplication(adInfo);
        break;
      default:
        break;
    }
  }
}
