import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import './utils.dart';
import './horizontal_buttons.dart';

const APP_USER_ID = '[YOUR_UNIQUE_APP_USER_ID]';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ImpressionDataListener, IronSourceInitializationListener, LevelPlayInitListener{

  @override
  void initState() {
    // Wait until all listeners are set in the child widgets.
    // instance is always initialized when this is called since it's only called in runApp.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.initState();
  }

  // For iOS14 IDFA access
  // Must be called when the app is in the state UIApplicationStateActive
  Future<void> checkATT() async {
    final currentStatus =
    await ATTrackingManager.getTrackingAuthorizationStatus();
    print('ATTStatus: $currentStatus');
    if (currentStatus == ATTStatus.NotDetermined) {
      final returnedStatus =
      await ATTrackingManager.requestTrackingAuthorization();
      print('ATTStatus returned: $returnedStatus');
    }
    return;
  }

  /// Enables debug mode for IronSource adapters.
  /// Validates integration.
  Future<void> enableDebug() async {
    await IronSource.setAdaptersDebug(true);
    // this function doesn't have to be awaited
    IronSource.validateIntegration();
  }

  /// Sets user segment params sample information for IronSource.
  Future<void> setSegment() async {
    final segment = IronSourceSegment();
    segment.age = 20;
    segment.gender = IronSourceUserGender.Female;
    segment.level = 3;
    segment.isPaying = false;
    segment.userCreationDateInMillis = DateTime.now().millisecondsSinceEpoch;
    segment.iapTotal = 1000;
    segment.setCustom(key: 'DemoCustomKey', value: 'DemoCustomVal');
    await IronSource.setSegment(segment);
  }

  /// Sets regulation parameters for IronSource.
  Future<void> setRegulationParams() async {
    // GDPR
    await IronSource.setConsent(true);
    await IronSource.setMetaData({
      // CCPA
      'do_not_sell': ['false'],
      // COPPA
      'is_child_directed': ['false'],
      'is_test_suite': ['enable']
    });

    return;
  }

  /// Initialize iron source SDK.
  Future<void> init() async {
    final appKey = Platform.isAndroid
        ? "1dc3db545"
        : Platform.isIOS
        ? "1dc3deecd"
        : throw Exception("Unsupported Platform");
    try {
      IronSource.setFlutterVersion('3.16.9');
      IronSource.addImpressionDataListener(this);
      await enableDebug();
      await IronSource.shouldTrackNetworkState(true);

      // GDPR, CCPA, COPPA etc
      await setRegulationParams();

      // Segment info
      await setSegment();

      // GAID, IDFA, IDFV
      String id = await IronSource.getAdvertiserId();
      print('AdvertiserID: $id');

      // Do not use AdvertiserID for this.
      await IronSource.setUserId(APP_USER_ID);

      // Authorization Request for IDFA use
      if (Platform.isIOS) {
        await checkATT();
      }

      // Finally, initialize
      // LevelPlay Init
      List<AdFormat> legacyAdFormats = [AdFormat.BANNER, AdFormat.REWARDED, AdFormat.INTERSTITIAL, AdFormat.NATIVE_AD];
      final initRequest = LevelPlayInitRequest(appKey: appKey, legacyAdFormats: legacyAdFormats);
      await LevelPlay.init(initRequest: initRequest, initListener: this);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Image.asset('assets/images/iS_logo.png'),
                  Utils.spacerLarge,
                  const LevelPlayRewardedVideoSection(),
                  Utils.spacerLarge,
                  const LevelPlayInterstitialAdSection(),
                  Utils.spacerLarge,
                  const LevelPlayBannerAdViewSection(),
                  Utils.spacerLarge,
                  const LevelPlayNativeAdViewSection(),
                  Utils.spacerLarge,
                  if (Platform.isIOS) const IOSSection()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// ImpressionData listener --------------------------------------------------///
  @override
  void onImpressionSuccess(ImpressionData? impressionData) {
    print('Impression Data: $impressionData');
  }

  /// Initialization listener --------------------------------------------------///
  @override
  void onInitializationComplete() {
    print('onInitializationComplete');
  }

  /// LevelPlay Init listener --------------------------------------------------///
  @override
  void onInitFailed(LevelPlayInitError error) {
    print('onInitFailed ${error.errorMessage}');
  }

  @override
  void onInitSuccess(LevelPlayConfiguration configuration) {
    print('onInitSuccess isAdQualityEnabled=${configuration.isAdQualityEnabled}');
  }
}

/// LevelPlay Rewarded Video Section -------------------------------------------///
class LevelPlayRewardedVideoSection extends StatefulWidget {
  const LevelPlayRewardedVideoSection({Key? key}) : super(key: key);

  @override
  _LevelPlayRewardedVideoSectionState createState() =>
      _LevelPlayRewardedVideoSectionState();
}

class _LevelPlayRewardedVideoSectionState extends State<LevelPlayRewardedVideoSection> with LevelPlayRewardedVideoListener {
  bool _isRewardedVideoAvailable = false;
  bool _isVideoAdVisible = false;
  IronSourceRewardedVideoPlacement? _placement;

  @override
  void initState() {
    super.initState();
    IronSource.setLevelPlayRewardedVideoListener(this);
  }

  Future<void> _setRewardedVideoCustomParams() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    await IronSource.setRewardedVideoServerParams({'dateTimeMillSec': time});
    Utils.showTextDialog(context, "RewardedVideo Custom Param Set", time);
  }

  Future<void> _showRewardedVideo() async {
    if (_isRewardedVideoAvailable && await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Rewarded Video", style: Utils.headingStyle),
      HorizontalButtons([ButtonInfo("Show Rewarded Video", _showRewardedVideo),]),
      HorizontalButtons([ButtonInfo("SetRewardedVideoServerParams", _setRewardedVideoCustomParams),]),
      HorizontalButtons([ButtonInfo("ClearRewardedVideoServerParams", () => IronSource.clearRewardedVideoServerParams())
      ]),
    ]);
  }

  @override
  void onAdAvailable(IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdAvailable: $adInfo");
    if (mounted) {
      setState(() {
        _isRewardedVideoAvailable = true;
      });
    }
  }

  @override
  void onAdUnavailable() {
    print("RewardedVideo - onAdUnavailable");
    if (mounted) {
      setState(() {
        _isRewardedVideoAvailable = false;
      });
    }
  }

  @override
  void onAdOpened(IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdOpened: $adInfo");
    if (mounted) {
      setState(() {
        _isVideoAdVisible = true;
      });
    }
  }

  @override
  void onAdClosed(IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdClosed: $adInfo");
    setState(() {
      _isVideoAdVisible = false;
    });
    if (mounted && _placement != null && !_isVideoAdVisible) {
      Utils.showTextDialog(context, 'Video Reward', _placement?.toString() ?? '');
      setState(() {
        _placement = null;
      });
    }
  }

  @override
  void onAdRewarded(IronSourceRewardedVideoPlacement placement, IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdRewarded: $placement, $adInfo");
    setState(() {
      _placement = placement;
    });
    if (mounted && _placement != null && !_isVideoAdVisible) {
      Utils.showTextDialog(context, 'Video Reward', _placement?.toString() ?? '');
      setState(() {
        _placement = null;
      });
    }
  }

  @override
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdShowFailed: $error, $adInfo");
    if (mounted) {
      setState(() {
        _isVideoAdVisible = false;
      });
    }
  }

  @override
  void onAdClicked(IronSourceRewardedVideoPlacement placement, IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdClicked: $placement, $adInfo");
  }
}

/// LevelPlay Interstitial Ad Section ------------------------------------------///
class LevelPlayInterstitialAdSection extends StatefulWidget {
  const LevelPlayInterstitialAdSection({Key? key}) : super(key: key);

  @override
  _LevelPlayInterstitialAdSectionState createState() => _LevelPlayInterstitialAdSectionState();
}

class _LevelPlayInterstitialAdSectionState extends State<LevelPlayInterstitialAdSection> with LevelPlayInterstitialAdListener {
  LevelPlayInterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    _interstitialAd = LevelPlayInterstitialAd(adUnitId: Platform.isAndroid ? '71tj8zbmfozim5nd' : 'v3fn8t0yhk0awqsm');
    _interstitialAd!.setListener(this);
  }

  Future<void> _showAd() async {
    if (_interstitialAd != null && await _interstitialAd!.isAdReady()) {
      _interstitialAd!.showAd(placementName: 'Default');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Interstitial Ad", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Load Ad", () => _interstitialAd?.loadAd()),
        ButtonInfo("Show Ad", _showAd),
      ]),
    ]);
  }

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    print("Interstitial Ad - onAdClicked: $adInfo");
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    print("Interstitial Ad - onAdClosed: $adInfo");
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    print("Interstitial Ad - onAdDisplayFailed: adInfo - $adInfo, error - $error");
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    print("Interstitial Ad - onAdDisplayed: $adInfo");
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    print("Interstitial Ad - onAdInfoChanged: $adInfo");
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    print("Interstitial Ad - onAdLoadFailed: $error");
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    print("Interstitial Ad - onAdLoaded: $adInfo");
  }
}

/// LevelPlay Banner Ad View Section -------------------------------------------///
class LevelPlayBannerAdViewSection extends StatefulWidget {
  const LevelPlayBannerAdViewSection({Key? key}) : super(key: key);

  @override
  _LevelPlayBannerAdViewSectionState createState() => _LevelPlayBannerAdViewSectionState();
}

class _LevelPlayBannerAdViewSectionState extends State<LevelPlayBannerAdViewSection> with LevelPlayBannerAdViewListener {
  LevelPlayBannerAdView? _bannerAdView;

  @override
  void initState() {
    super.initState();
    _createBannerAdView();
  }

  void _createBannerAdView() {
    final _bannerKey = GlobalKey<LevelPlayBannerAdViewState>();
    _bannerAdView = LevelPlayBannerAdView(
      key: _bannerKey,
      adUnitId: Platform.isAndroid ? 'iq2gxli4u8n10jrp' : 'pfhu8mrg1arqwlo8',
      adSize: LevelPlayAdSize.BANNER,
      listener: this,
      placementName: '',
    );
  }

  void _destroyAdAndCreateNew() {
    if (_bannerAdView == null) return;

    _bannerAdView!.destroy();
    setState(() {
      _createBannerAdView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Banner Ad View", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Load Ad", () => _bannerAdView?.loadAd()),
        ButtonInfo("Destroy Ad", _destroyAdAndCreateNew)
      ]),
      HorizontalButtons([
        ButtonInfo("Pause Auto Refresh", () => _bannerAdView?.pauseAutoRefresh() ),
        ButtonInfo("Resume Auto Refresh", () => _bannerAdView?.resumeAutoRefresh() ),
      ]),
      SizedBox(
        width: 320,
        height: 50,
        child: _bannerAdView ?? Container(),
      )
    ]);
  }

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    print("Banner Ad View - onAdClicked: $adInfo");
  }

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {
    print("Banner Ad View - onAdCollapsed: $adInfo");
  }

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {
    print("Banner Ad View - onAdDisplayFailed: adInfo - $adInfo, error - $error");
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    print("Banner Ad View - onAdDisplayed: $adInfo");
  }

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {
    print("Banner Ad View - onAdExpanded: $adInfo");
  }

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {
    print("Banner Ad View - onAdLeftApplication: $adInfo");
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    print("Banner Ad View - onAdLoadFailed: $error");
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    print("Banner Ad View - onAdLoaded: $adInfo");
  }
}

/// LevelPlay Native Ad View Section -------------------------------------------///
class LevelPlayNativeAdViewSection extends StatefulWidget {

  const LevelPlayNativeAdViewSection({Key? key}) : super(key: key);

  @override
  _LevelPlayNativeAdsSection createState() =>
      _LevelPlayNativeAdsSection();
}

class _LevelPlayNativeAdsSection extends State<LevelPlayNativeAdViewSection> with LevelPlayNativeAdListener {
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
        templateType: LevelPlayTemplateType.SMALL // Built-in native ad template(not required when implementing custom template),
    );
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
        ButtonInfo("Load Ad", () => _nativeAd?.loadAd()),
        ButtonInfo("Destroy Ad", _destroyAdAndCreateNew),
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

/// IOS Section ----------------------------------------------------------------///
class IOSSection extends StatefulWidget {
  const IOSSection({Key? key}) : super(key: key);

  @override
  _IOSSectionState createState() => _IOSSectionState();
}

class _IOSSectionState extends State<IOSSection> with IronSourceConsentViewListener {
  @override
  void initState() {
    super.initState();
    IronSource.setConsentViewListener(this);
  }

  Future<void> _loadConsentView() async =>await IronSource.loadConsentViewWithType('pre');

  Future<void> _getConversionValue(BuildContext context) async {
    final cv = await IronSource.getConversionValue();
    Utils.showTextDialog(context, "ConversionValue", cv.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("iOS 14", style: Utils.headingStyle),
      HorizontalButtons([ButtonInfo("Get Conversion Value", () => _getConversionValue(context))]),
      HorizontalButtons([ButtonInfo("Load Consent View", () => _loadConsentView)])
    ]);
  }

  @override
  void consentViewDidAccept(String consentViewType) {
    print('consentViewDidAccept consentViewType:$consentViewType');
  }

  @override
  void consentViewDidFailToLoad(IronSourceConsentViewError error) {
    print('consentViewDidFailToLoad error:$error');
  }

  @override
  void consentViewDidFailToShow(IronSourceConsentViewError error) {
    print('consentViewDidFailToShow error:$error');
  }

  @override
  void consentViewDidLoadSuccess(String consentViewType) {
    print('consentViewDidLoadSuccess consentViewType:$consentViewType');
    if (mounted) {
      IronSource.showConsentViewWithType(consentViewType);
    }
  }

  @override
  void consentViewDidShowSuccess(String consentViewType) {
    print('consentViewDidLoadSuccess consentViewType:$consentViewType');
  }
}