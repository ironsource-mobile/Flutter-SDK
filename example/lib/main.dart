import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';

const APP_USER_ID = '[YOUR_UNIQUE_APP_USER_ID]';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ImpressionDataListener, LevelPlayInitListener {

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
      final initRequest = LevelPlayInitRequest.builder(appKey)
        .withLegacyAdFormats(legacyAdFormats)
        .withUserId(APP_USER_ID)
        .build();
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
                  const SizedBox(height: 15),
                  const LevelPlayRewardedVideoSection(),
                  const SizedBox(height: 15),
                  const LevelPlayInterstitialAdSection(),
                  const SizedBox(height: 15),
                  const LevelPlayBannerAdViewSection(),
                  const SizedBox(height: 15),
                  const LevelPlayNativeAdViewSection(),
                  const SizedBox(height: 15),
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

class _LevelPlayRewardedVideoSectionState extends State<LevelPlayRewardedVideoSection> with LevelPlayRewardedAdListener {
  final LevelPlayRewardedAd _rewardedAd = LevelPlayRewardedAd(adUnitId: Platform.isAndroid ? 'ugymkux8j6lfs2u4' : '9f4ukec62lsnsyhp');

  @override
  void initState() {
    super.initState();
    _rewardedAd.setListener(this);
  }

  void _loadAd() async {
    _rewardedAd.loadAd();
  }

  Future<void> _showAd() async {
    if (await _rewardedAd.isAdReady()) {
      _rewardedAd.showAd(placementName: 'Default');
    }
  }

  void showTextDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Rewarded Ad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      HorizontalButtons([
        ButtonInfo("Load Ad", _loadAd),
        ButtonInfo("Show Ad", _showAd),
      ]),
    ]);
  }

  @override
  void onAdRewarded(LevelPlayReward reward, LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdRewarded: $adInfo");
    showTextDialog(context, 'Rewarded', reward.toString());
  }

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdClicked: $adInfo");
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdClosed: $adInfo");
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdDisplayFailed: adInfo - $adInfo, error - $error");
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdDisplayed: $adInfo");
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdInfoChanged: $adInfo");
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    print("Rewarded Ad - onAdLoadFailed: $error");
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    print("Rewarded Ad - onAdLoaded: $adInfo");
  }
}

/// LevelPlay Interstitial Ad Section ------------------------------------------///
class LevelPlayInterstitialAdSection extends StatefulWidget {
  const LevelPlayInterstitialAdSection({Key? key}) : super(key: key);

  @override
  _LevelPlayInterstitialAdSectionState createState() => _LevelPlayInterstitialAdSectionState();
}

class _LevelPlayInterstitialAdSectionState extends State<LevelPlayInterstitialAdSection> with LevelPlayInterstitialAdListener {
  final LevelPlayInterstitialAd _interstitialAd = LevelPlayInterstitialAd(adUnitId: Platform.isAndroid ? '71tj8zbmfozim5nd' : 'v3fn8t0yhk0awqsm');

  @override
  void initState() {
    super.initState();
    _interstitialAd.setListener(this);
  }

  void _loadAd() {
    _interstitialAd.loadAd();
  }

  Future<void> _showAd() async {
    if (await _interstitialAd.isAdReady()) {
      _interstitialAd.showAd(placementName: 'Default');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Interstitial Ad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      HorizontalButtons([
        ButtonInfo("Load Ad", _loadAd),
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
  final GlobalKey<LevelPlayBannerAdViewState> _bannerKey = GlobalKey<LevelPlayBannerAdViewState>();
  final _adSize = LevelPlayAdSize.BANNER;
  final _adUnitId = Platform.isAndroid ? 'iq2gxli4u8n10jrp' : 'pfhu8mrg1arqwlo8';
  final _placementName = '';

  void _loadAd() {
    _bannerKey.currentState?.loadAd();
  }

  void _destroyAd() {
    _bannerKey.currentState?.destroy();
  }

  void _pauseAutoRefresh() {
    _bannerKey.currentState?.pauseAutoRefresh();
  }

  void _resumeAutoRefresh() {
    _bannerKey.currentState?.resumeAutoRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Banner Ad View", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      HorizontalButtons([
        ButtonInfo("Load Ad", _loadAd),
        ButtonInfo("Destroy Ad", _destroyAd)
      ]),
      HorizontalButtons([
        ButtonInfo("Pause Auto Refresh", _pauseAutoRefresh ),
        ButtonInfo("Resume Auto Refresh", _resumeAutoRefresh ),
      ]),
      SizedBox(
        width: _adSize.width.toDouble(),
        height: _adSize.height.toDouble(),
        child: LevelPlayBannerAdView(
          key: _bannerKey,
          adUnitId: _adUnitId,
          adSize: _adSize,
          listener: this,
          placementName: _placementName,
        ),
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
  late LevelPlayNativeAd _nativeAd;
  final double _width = 350;
  final double _height = 300;
  final String _placementName = '';
  final LevelPlayTemplateType _templateType = LevelPlayTemplateType.MEDIUM; // Built-in native ad template(not required when implementing custom template)

  @override
  void initState() {
    super.initState();
    _nativeAd = LevelPlayNativeAd.builder()
        .withPlacementName(_placementName) // Your placement name string
        .withListener(this) // Your level play native ad listener
        .build();
  }

  void _loadAd() {
    _nativeAd.loadAd();
  }

  void _destroyAd() {
    _nativeAd.destroyAd();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Native Ad View", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      HorizontalButtons([
        ButtonInfo("Load Ad", _loadAd),
        ButtonInfo("Destroy Ad", _destroyAd),
      ]),
      LevelPlayNativeAdView(
          height: _height,
          width: _width,
          nativeAd: _nativeAd,
          templateType: _templateType,
      )
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
    if (nativeAd != null) {
      setState(() {
        _nativeAd = nativeAd;
      });
    }
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

  void showTextDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  Future<void> _loadConsentView() async =>await IronSource.loadConsentViewWithType('pre');

  Future<void> _getConversionValue(BuildContext context) async {
    final cv = await IronSource.getConversionValue();
    showTextDialog(context, "ConversionValue", cv.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("iOS 14", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

/// Widgets ----------------------------------------------------------------///

class ButtonInfo {
  final String title;
  final void Function()? onPressed;
  ButtonInfo(this.title, this.onPressed);
}

class HorizontalButtons extends StatelessWidget {
  final List<ButtonInfo> buttons;
  const HorizontalButtons(this.buttons, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final smallBtnStyle = ElevatedButton.styleFrom(minimumSize: const Size(150, 45));
    return Row(
        children: buttons
            .map((btn) => Expanded(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: btn.onPressed,
                child: Text(btn.title),
                style: smallBtnStyle,
              )),
        ))
            .toList());
  }
}