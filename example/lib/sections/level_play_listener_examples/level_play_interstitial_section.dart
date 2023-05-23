import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../../utils.dart';
import '../../widgets/horizontal_buttons.dart';

/// LevelPlayInterstitialListener integration example\
/// Can be swapped with InterstitialSection
class LevelPlayInterstitialSection extends StatefulWidget {
  const LevelPlayInterstitialSection({Key? key}) : super(key: key);

  @override
  _LevelPlayInterstitialSectionState createState() =>
      _LevelPlayInterstitialSectionState();
}

class _LevelPlayInterstitialSectionState
    extends State<LevelPlayInterstitialSection>
    with LevelPlayInterstitialListener {
  bool _isInterstitialAvailable = false;

  @override
  void initState() {
    super.initState();
    IronSource.setLevelPlayInterstitialListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Interstitial", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Load Interstitial", () {
          IronSource.loadInterstitial();
        }),
        ButtonInfo(
            "Show Interstitial",
            _isInterstitialAvailable
                ? () async {
                    final isCapped =
                        await IronSource.isInterstitialPlacementCapped(
                            placementName: "Default");
                    print('Default placement capped: $isCapped');
                    if (!isCapped && await IronSource.isInterstitialReady()) {
                      IronSource.showInterstitial();
                    }
                  }
                : null)
      ])
    ]);
  }

  // LevelPlay Interstitial listener

  @override
  void onAdReady(IronSourceAdInfo adInfo) {
    print("Interstitial - onAdReady: $adInfo");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = true;
      });
    }
  }

  @override
  void onAdLoadFailed(IronSourceError error) {
    print("Interstitial - onAdLoadFailed: $error");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = false;
      });
    }
  }

  @override
  void onAdOpened(IronSourceAdInfo adInfo) {
    print("Interstitial - onAdOpened: $adInfo");
  }

  @override
  void onAdClosed(IronSourceAdInfo adInfo) {
    print("Interstitial - onAdClosed: $adInfo");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = false;
      });
    }
  }

  @override
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo) {
    print("Interstitial - onAdShowFailed: $error, $adInfo");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = false;
      });
    }
  }

  @override
  void onAdClicked(IronSourceAdInfo adInfo) {
    print("Interstitial - onAdClicked: $adInfo");
  }

  @override
  void onAdShowSucceeded(IronSourceAdInfo adInfo) {
    print("Interstitial - onAdShowSucceeded: $adInfo");
  }
}
