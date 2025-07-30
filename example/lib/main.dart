import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';

const APP_USER_ID = '[YOUR_UNIQUE_APP_USER_ID]';
const String TAG = 'LevelPlayFlutterDemo';

// App Keys
const String APP_KEY_ANDROID = '85460dcd';
const String APP_KEY_IOS = '8545d445';

// Rewarded video ad unit IDs
const String REWARDED_AD_UNIT_ID_ANDROID = '76yy3nay3ceui2a3';
const String REWARDED_AD_UNIT_ID_IOS = 'qwouvdrkuwivay5q';

// Interstitial ad unit IDs
const String INTERSTITIAL_AD_UNIT_ID_ANDROID = 'aeyqi3vqlv6o8sh9';
const String INTERSTITIAL_AD_UNIT_ID_IOS = 'wmgt0712uuux8ju4';

// Banner ad unit IDs
const String BANNER_AD_UNIT_ID_ANDROID = 'thnfvcsog13bhn08';
const String BANNER_AD_UNIT_ID_IOS = 'iep3rxsyp9na3rw8';

// Native ad unit IDs
const String NATIVE_AD_UNIT_ID_ANDROID = 'ysoafvxg3grxe59f';
const String NATIVE_AD_UNIT_ID_IOS = 'w58kpushhcbps32x';

// Helper methods to get platform-specific appkeys and ad unit IDs.
String get appKey => Platform.isAndroid ? APP_KEY_ANDROID : Platform.isIOS ? APP_KEY_IOS
    : throw Exception("Unsupported Platform for App Key");

String get rewardedAdUnitId => Platform.isAndroid ? REWARDED_AD_UNIT_ID_ANDROID : Platform.isIOS ? REWARDED_AD_UNIT_ID_IOS
    : throw Exception("Unsupported Platform for Rewarded Ad Unit ID");

String get interstitialAdUnitId => Platform.isAndroid ? INTERSTITIAL_AD_UNIT_ID_ANDROID : Platform.isIOS ? INTERSTITIAL_AD_UNIT_ID_IOS
    : throw Exception("Unsupported Platform for Interstitial Ad Unit ID");

String get bannerAdUnitId => Platform.isAndroid ? BANNER_AD_UNIT_ID_ANDROID : Platform.isIOS ? BANNER_AD_UNIT_ID_IOS
    : throw Exception("Unsupported Platform for Banner Ad Unit ID");

String get nativeAdUnitId => Platform.isAndroid ? NATIVE_AD_UNIT_ID_ANDROID : Platform.isIOS ? NATIVE_AD_UNIT_ID_IOS
    : throw Exception("Unsupported Platform for Native Ad Unit ID");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with LevelPlayImpressionDataListener, LevelPlayInitListener {

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
    logMethodName('getTrackingAuthorizationStatus', 'ATTStatus:', currentStatus);
    if (currentStatus == ATTStatus.NotDetermined) {
      final returnedStatus =
      await ATTrackingManager.requestTrackingAuthorization();
      logMethodName('requestTrackingAuthorizationATTStatus', 'ATTStatus returned:', returnedStatus);
    }
    return;
  }

  /// Enables debug mode for LevelPlay adapters.
  /// Validates integration.
  Future<void> enableDebug() async {
    await LevelPlay.setAdaptersDebug(true);
    // this function doesn't have to be awaited
    LevelPlay.validateIntegration();
  }

  /// Initialize LevelPlay SDK.
  Future<void> init() async {

    try {
      LevelPlay.setFlutterVersion('3.32.7');
      LevelPlay.addImpressionDataListener(this);
      await enableDebug();

      // Authorization Request for IDFA use
      if (Platform.isIOS) {
        await checkATT();
      }

      // Finally, initialize
      // LevelPlay Init
      List<AdFormat> legacyAdFormats = [AdFormat.NATIVE_AD];
      final initRequest = LevelPlayInitRequest.builder(appKey)
        .withLegacyAdFormats(legacyAdFormats)
        .withUserId(APP_USER_ID)
        .build();
      await LevelPlay.init(initRequest: initRequest, initListener: this);
    } on PlatformException catch (e) {
      logMethodName('LevelPlayInit', 'PlatformException', e);
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
                  const LevelPlayBannerAdSection(),
                  const SizedBox(height: 15),
                  const LevelPlayNativeAdSection(),
                  const SizedBox(height: 15),
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
  void onImpressionSuccess(LevelPlayImpressionData impressionData) {
    logMethodName('Impression Data', 'onImpressionSuccess', impressionData);
  }

  /// LevelPlay Init listener --------------------------------------------------///
  @override
  void onInitFailed(LevelPlayInitError error) {
    logMethodName('InitListener', 'onInitFailed', error);
  }

  @override
  void onInitSuccess(LevelPlayConfiguration configuration) {
    logMethodName('InitListener', 'onInitSuccess', configuration);
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
  // Instance of the Rewarded Ad
  final LevelPlayRewardedAd _rewardedAd = LevelPlayRewardedAd(adUnitId: rewardedAdUnitId);

  @override
  void initState() {
    super.initState();
    // Set this class as the listener for the rewarded ad events.
    _rewardedAd.setListener(this);
  }

  // Initiates loading of a rewarded ad.
  void _loadAd() async {
    _rewardedAd.loadAd();
  }

  // Shows the rewarded ad if it's ready.
  Future<void> _showAd() async {
    if (await _rewardedAd.isAdReady()) {
      _rewardedAd.showAd(placementName: 'Default');
    }
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
    logMethodName('Rewarded Ad', 'onAdRewarded', '$adInfo | $reward');
    showTextDialog(context, 'Rewarded', reward.toString());
  }

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    logMethodName('Rewarded Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    logMethodName('Rewarded Ad', 'onAdClosed', adInfo);
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    logMethodName('Rewarded Ad', 'onAdDisplayFailed', '$error | $adInfo');
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    logMethodName('Rewarded Ad', 'onAdDisplayed', adInfo);
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    logMethodName('Rewarded Ad', 'onAdInfoChanged', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    logMethodName('Rewarded Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    logMethodName('Rewarded Ad', 'onAdLoaded', adInfo);
  }
}

/// LevelPlay Interstitial Ad Section ------------------------------------------///
class LevelPlayInterstitialAdSection extends StatefulWidget {
  const LevelPlayInterstitialAdSection({Key? key}) : super(key: key);

  @override
  _LevelPlayInterstitialAdSectionState createState() => _LevelPlayInterstitialAdSectionState();
}

class _LevelPlayInterstitialAdSectionState extends State<LevelPlayInterstitialAdSection> with LevelPlayInterstitialAdListener {
  final LevelPlayInterstitialAd _interstitialAd = LevelPlayInterstitialAd(adUnitId: interstitialAdUnitId);

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
    logMethodName('Interstitial Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    logMethodName('Interstitial Ad', 'onAdClosed', adInfo);
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    logMethodName('Interstitial Ad', 'onAdDisplayFailed', '$error | $adInfo');
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    logMethodName('Interstitial Ad', 'onAdDisplayed', adInfo);
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    logMethodName('Interstitial Ad', 'onAdInfoChanged', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    logMethodName('Interstitial Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    logMethodName('Interstitial Ad', 'onAdLoaded', adInfo);
  }
}

/// LevelPlay Banner Ad Section -------------------------------------------///
class LevelPlayBannerAdSection extends StatefulWidget {
  const LevelPlayBannerAdSection({Key? key}) : super(key: key);

  @override
  _LevelPlayBannerAdSectionState createState() => _LevelPlayBannerAdSectionState();
}

class _LevelPlayBannerAdSectionState extends State<LevelPlayBannerAdSection> with LevelPlayBannerAdViewListener {
  // GlobalKey to control the LevelPlayBannerAd state (e.g., load, destroy)
  GlobalKey<LevelPlayBannerAdViewState> _bannerKey = GlobalKey<LevelPlayBannerAdViewState>();
  final _adSize = LevelPlayAdSize.BANNER;
  final _adUnitId = bannerAdUnitId;
  final _placementName = '';

  // Initiates loading of the banner ad.
  void _loadAd() {
    _bannerKey.currentState?.loadAd();
  }

  // Destroys the current banner ad view and prepares for a new one.
  void _destroyAd() {
    _bannerKey.currentState?.destroy();

    // Recreate the banner key to reset the state of the banner ad view.
    // This ensures that if we load again, it's a fresh banner instance.
    setState(() {
      _bannerKey = GlobalKey<LevelPlayBannerAdViewState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Banner Ad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      HorizontalButtons([
        ButtonInfo("Load Ad", _loadAd),
        ButtonInfo("Destroy Ad", _destroyAd)
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
    logMethodName('Banner Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {
    logMethodName('Banner Ad', 'onAdCollapsed', adInfo);
  }

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {
    logMethodName('Banner Ad', 'onAdDisplayFailed', '$error | $adInfo');
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    logMethodName('Banner Ad', 'onAdDisplayed', adInfo);
  }

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {
    logMethodName('Banner Ad', 'onAdExpanded', adInfo);
  }

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {
    logMethodName('Banner Ad', 'onAdLeftApplication', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    logMethodName('Banner Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    logMethodName('Banner Ad', 'onAdLoaded', adInfo);
  }
}

/// LevelPlay Native Ad Section -------------------------------------------///
class LevelPlayNativeAdSection extends StatefulWidget {

  const LevelPlayNativeAdSection({Key? key}) : super(key: key);

  @override
  _LevelPlayNativeAdsSection createState() =>
      _LevelPlayNativeAdsSection();
}

class _LevelPlayNativeAdsSection extends State<LevelPlayNativeAdSection> with LevelPlayNativeAdListener {
  late LevelPlayNativeAd _nativeAd;
  // GlobalKey to allow re-rendering the LevelPlayNativeAdView widget when the ad is destroyed and re-created.
  GlobalKey _nativeAdKey = GlobalKey();
  final double _width = 350;
  final double _height = 300;
  final String _placementName = '';
  final LevelPlayTemplateType _templateType = LevelPlayTemplateType
      .MEDIUM; // Built-in native ad template(not required when implementing custom template)

  @override
  void initState() {
    super.initState();
    // Initialize the native ad
    _createNativeAd();
  }

  // Creates a new instance of LevelPlayNativeAd with the specified listener and placement.
  void _createNativeAd() {
    _nativeAd = LevelPlayNativeAd.builder()
        .withPlacementName(_placementName)
        .withListener(this)
        .build();
  }

  // Initiates loading of the native ad.
  void _loadAd() {
    _nativeAd.loadAd();
  }

  // Destroys the current native ad and prepares for a new one.
  void _destroyAd() {
    _nativeAd.destroyAd();
    // Create a new key and a new native ad instance to force widget recreation
    setState(() {
      _nativeAdKey = GlobalKey(); // Create a new key to force view recreation
      _createNativeAd(); // Create a new native ad instance
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Native Ad",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      HorizontalButtons([
        ButtonInfo("Load Ad", _loadAd),
        ButtonInfo("Destroy Ad", _destroyAd),
      ]),
      LevelPlayNativeAdView(
        key: _nativeAdKey,
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
    logMethodName('Native Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdImpression(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    logMethodName('Native Ad', 'onAdImpression', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd? nativeAd, IronSourceError? error) {
    logMethodName('Native Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    logMethodName('Native Ad', 'onAdLoaded', adInfo);
    if (nativeAd != null) {
      setState(() {
        // Update the state with the loaded native ad.
        _nativeAd = nativeAd;
      });
    }
  }
}

/// Utils ----------------------------------------------------------------///

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
// Log utility function to print ad format, method name and additional data
void logMethodName(String adFormat, String methodName, dynamic data) {
  print('$TAG: $adFormat - $methodName $data');
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