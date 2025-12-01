import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

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

class _MyAppState extends State<MyApp> with LevelPlayImpressionDataListener, LevelPlayInitListener, LevelPlayBannerAdViewListener {
  // Bottom banner ad variables
  GlobalKey<LevelPlayBannerAdViewState> bannerAdKey = GlobalKey<LevelPlayBannerAdViewState>();
  final adSize = LevelPlayAdSize.BANNER;

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
      final initRequest = LevelPlayInitRequest.builder(appKey)
        .withUserId(APP_USER_ID)
        .build();
      await LevelPlay.init(initRequest: initRequest, initListener: this);
    } on PlatformException catch (e) {
      logMethodName('LevelPlayInit', 'PlatformException', e);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Banner ad methods
    void loadBannerAd() {
      bannerAdKey.currentState?.loadAd();
    }

    void destroyBannerAd() {
      bannerAdKey.currentState?.destroy();
      setState(() {
        bannerAdKey = GlobalKey<LevelPlayBannerAdViewState>();
      });
    }

    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Logo with text below
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo_small.png',
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  'for Flutter',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const LevelPlayRewardedVideoSection(),
                      const LevelPlayInterstitialAdSection(),
                      LevelPlayBannerAdSection(
                        onLoadBanner: loadBannerAd,
                        onDestroyBanner: destroyBannerAd,
                      ),
                      const LevelPlayNativeAdSection(),
                      const SizedBox(height: 80), // Space for bottom banner
                    ],
                  ),
                ),
                // Banner positioned at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: adSize.width.toDouble(),
                    height: adSize.height.toDouble(),
                    alignment: Alignment.center,
                    child: LevelPlayBannerAdView(
                      key: bannerAdKey,
                      adUnitId: bannerAdUnitId,
                      adSize: adSize,
                      listener: this,
                      placementName: 'DefaultBanner',
                    ),
                  ),
                ),
              ],
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

  /// Bottom Banner Ad listener methods ----------------------------------///
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    logMethodName('Bottom Banner Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {
    logMethodName('Bottom Banner Ad', 'onAdCollapsed', adInfo);
  }

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {
    logMethodName('Bottom Banner Ad', 'onAdDisplayFailed', '$error | $adInfo');
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    logMethodName('Bottom Banner Ad', 'onAdDisplayed', adInfo);
  }

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {
    logMethodName('Bottom Banner Ad', 'onAdExpanded', adInfo);
  }

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {
    logMethodName('Bottom Banner Ad', 'onAdLeftApplication', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    logMethodName('Bottom Banner Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    logMethodName('Bottom Banner Ad', 'onAdLoaded', adInfo);
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
      const Text("Rewarded Ad", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      const SizedBox(height: 10),
      HorizontalButtons([
        ButtonInfo("Load Rewarded", _loadAd),
        ButtonInfo("Show Rewarded", _showAd),
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
      const Text("Interstitial Ad", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      const SizedBox(height: 10),
      HorizontalButtons([
        ButtonInfo("Load Interstitial", _loadAd),
        ButtonInfo("Show Interstitial", _showAd),
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
  final VoidCallback onLoadBanner;
  final VoidCallback onDestroyBanner;
  
  const LevelPlayBannerAdSection({
    Key? key,
    required this.onLoadBanner,
    required this.onDestroyBanner,
  }) : super(key: key);

  @override
  _LevelPlayBannerAdSectionState createState() => _LevelPlayBannerAdSectionState();
}

class _LevelPlayBannerAdSectionState extends State<LevelPlayBannerAdSection> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Banner Ad", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      const SizedBox(height: 10),
      HorizontalButtons([
        ButtonInfo("Load Banner", widget.onLoadBanner),
        ButtonInfo("Destroy Banner", widget.onDestroyBanner)
      ]),
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
      const Text("Native Ad", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
      const SizedBox(height: 10),
      HorizontalButtons([
        ButtonInfo("Load Native Ad", _loadAd),
        ButtonInfo("Destroy Native Ad", _destroyAd),
      ]),
      const SizedBox(height: 15),
      SizedBox(
        width: _width,
        height: _height,
        child: LevelPlayNativeAdView(
          key: _nativeAdKey,
          height: _height,
          width: _width,
          nativeAd: _nativeAd,
          templateType: _templateType,
        ),
      )
    ],
    );
  }

  // LevelPlay NativeAd listener
  @override
  void onAdClicked(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    logMethodName('Native Ad', 'onAdClicked', adInfo);
  }

  @override
  void onAdImpression(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    logMethodName('Native Ad', 'onAdImpression', adInfo);
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd nativeAd, IronSourceError error) {
    logMethodName('Native Ad', 'onAdLoadFailed', error);
  }

  @override
  void onAdLoaded(LevelPlayNativeAd nativeAd, AdInfo adInfo) {
    logMethodName('Native Ad', 'onAdLoaded', adInfo);
    setState(() {
      // Update the state with the loaded native ad.
      _nativeAd = nativeAd;
    });
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
    return Row(
        children: buttons
            .map((btn) => Expanded(
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: btn.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  btn.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )),
        ))
            .toList());
  }
}