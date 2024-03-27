import 'dart:io' show Platform;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import './sections/rewarded_video_section.dart';
import './sections/rewarded_video_manual_load_section.dart';
import './sections/interstitial_section.dart';
import './sections/banner_section.dart';
import './sections/offerwall_section.dart';
import './sections/ios_section.dart';
import './utils.dart';

const _APP_USER_ID = 'some-unique-app-user-id-123';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>
    with IronSourceImpressionDataListener, IronSourceInitializationListener {
  @override
  void initState() {
    super.initState();

    // Wait until all listeners are set in the child widgets.
    // instance is always initialized when this is called since it's only called in runApp.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initIronSource();
    });
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

  Future<void> enableDebug() async {
    await IronSource.setAdaptersDebug(true);
    // this function doesn't have to be awaited
    IronSource.validateIntegration();
  }

  // Sample Segment Params
  Future<void> setSegment() {
    final segment = IronSourceSegment();
    segment.age = 20;
    segment.gender = IronSourceUserGender.Female;
    segment.level = 3;
    segment.isPaying = false;
    segment.userCreationDateInMillis = DateTime.now().millisecondsSinceEpoch;
    segment.iapTotal = 1000;
    segment.setCustom(key: 'DemoCustomKey', value: 'DemoCustomVal');
    return IronSource.setSegment(segment);
  }

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

  Future<void> initIronSource() async {
    final appKey = Platform.isAndroid
        ? "1dc3db545"
        : Platform.isIOS
            ? "1dc3deecd"
            : throw Exception("Unsupported Platform");
    try {
      IronSource.setFlutterVersion('3.3.0'); // fetch automatically
      IronSource.setImpressionDataListener(this);
      await enableDebug();
      await IronSource.shouldTrackNetworkState(true);

      // GDPR, CCPA, COPPA etc
      await setRegulationParams();

      // Segment info
      // await setSegment();

      // For Offerwall
      // Must be called before init
      // await IronSource.setClientSideCallbacks(true);

      // GAID, IDFA, IDFV
      String id = await IronSource.getAdvertiserId();
      print('AdvertiserID: $id');

      // Do not use AdvertiserID for this.
      await IronSource.setUserId(_APP_USER_ID);

      // Authorization Request for IDFA use
      if (Platform.isIOS) {
        await checkATT();
      }

      // Finally, initialize
      await IronSource.init(
          appKey: appKey,
          adUnits: [
            IronSourceAdUnit.RewardedVideo,
            IronSourceAdUnit.Interstitial,
            IronSourceAdUnit.Banner,
            IronSourceAdUnit.Offerwall
          ],
          initListener: this);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Widget _getRewardedVideoSection() {
    return const RewardedVideoManualLoadSection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // header logo
              Image.asset('assets/images/iS_logo.png'),
              Utils.spacerLarge,
              // RewardedVideo
              _getRewardedVideoSection(),
              Utils.spacerLarge,
              // Interstitial
              const InterstitialSection(),
              Utils.spacerLarge,
              // Banner
              const BannerSection(),
              Utils.spacerLarge,
              // OfferWall
              const OfferwallSection(),
              Utils.spacerLarge,
              // iOS14
              if (Platform.isIOS) const IOSSection()
            ],
          ),
        ),
      ),
    );
  }

  // ImpressionData listener

  @override
  void onImpressionSuccess(IronSourceImpressionData? impressionData) {
    print('Impression Data: $impressionData');
  }

  // Initialization listener
  @override
  void onInitializationComplete() {
    print('onInitializationComplete');
  }
}
