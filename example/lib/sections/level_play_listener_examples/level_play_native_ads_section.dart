import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../../utils.dart';
import '../../widgets/horizontal_buttons.dart';

/// LevelPlayNativeAdListener integration example
class LevelPlayNativeAdsSection extends StatefulWidget {

  const LevelPlayNativeAdsSection({Key? key}) : super(key: key);

  @override
  _LevelPlayNativeAdsSection createState() =>
      _LevelPlayNativeAdsSection();
}

class _LevelPlayNativeAdsSection extends State<LevelPlayNativeAdsSection> with LevelPlayNativeAdListener {
  LevelPlayNativeAd? _nativeAd;
  LevelPlayNativeAdView? _nativeAdView;

  @override
  void initState() {
    super.initState();
    _createNativeAd();
    _createNativeAdView();
  }

  /// Initialize native ad object
  void _createNativeAd() {
    _nativeAd = LevelPlayNativeAd.builder()
        .withPlacementName('') // Your placement name string
        .withListener(this) // Your level play native ad listener
        .build();
  }

  /// Initialize native ad view widget with native ad
  void _createNativeAdView() {
    _nativeAdView = LevelPlayNativeAdView(
      key: GlobalKey(), // Unique key to force recreation of widget
      height: 150, // Your chosen height
      width: double.infinity, // Your chosen width
      nativeAd: _nativeAd, // Native ad object
      templateType: LevelPlayTemplateType.SMALL, // Built-in native ad template(not required when implementing custom template)
      templateStyle: LevelPlayNativeAdTemplateStyle( // Level play native ad styling(optional)
          callToActionStyle: LevelPlayNativeAdElementStyle(
              backgroundColor: Colors.white,
              textColor: Colors.lightBlue
          )
      ),
    );
  }

  /// Load native ad
  void _loadAd() {
    _nativeAd?.loadAd();
  }

  /// Destroy current native ad and create new instances of LevelPlayNativeAd and LevelPlayNativeAdView.
  void _destroyAdAndCreateNew() {
    if (_nativeAd == null) return;

    _nativeAd!.destroyAd();
    setState(() {
      _createNativeAd();
      _createNativeAdView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Native Ad", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Load Ad", () {
          _loadAd();
        }),
        ButtonInfo("Destroy Ad", () {
          _destroyAdAndCreateNew(); // Call this method on button press
        }),
      ]),
      _nativeAdView ?? Container()
    ],
    );
  }

  // LevelPlay NativeAd listener

  @override
  void onAdClicked(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    print('onAdLoaded - adInfo: $adInfo');
  }

  @override
  void onAdImpression(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    print('onAdLoaded - adInfo: $adInfo');
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd? nativeAd, IronSourceError? error) {
    print('onAdLoadFailed - error: $error');
  }

  @override
  void onAdLoaded(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    print('onAdLoaded - nativeAd: $_nativeAd, adInfo: $adInfo');
    setState(() {
      _nativeAd = nativeAd;
    });
  }
}
