import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../utils.dart';
import '../widgets/horizontal_buttons.dart';

class InterstitialSection extends StatefulWidget {
  const InterstitialSection({Key? key}) : super(key: key);

  @override
  _InterstitialSectionState createState() => _InterstitialSectionState();
}

class _InterstitialSectionState extends State<InterstitialSection>
    with IronSourceInterstitialListener {
  bool _isInterstitialAvailable = false;

  @override
  void initState() {
    super.initState();
    IronSource.setInterstitialListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Interstitial", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Test Suite", () {
          IronSource.launchTestSuite();
        }),
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
                    print('Interstitial Default placement capped: $isCapped');
                    if (!isCapped && await IronSource.isInterstitialReady()) {
                      IronSource.showInterstitial();
                    }
                  }
                : null)
      ])
    ]);
  }

  // Interstitial listener

  @override
  void onInterstitialAdClicked() {
    print("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    print("onInterstitialAdClosed");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = false;
      });
    }
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    print("onInterstitialAdLoadFailed Error:$error");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = false;
      });
    }
  }

  @override
  void onInterstitialAdOpened() {
    print("onInterstitialAdOpened");
  }

  @override
  void onInterstitialAdReady() {
    print("onInterstitialAdReady");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = true;
      });
    }
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    print("onInterstitialAdShowFailed Error:$error");
    if (mounted) {
      setState(() {
        _isInterstitialAvailable = false;
      });
    }
  }

  @override
  void onInterstitialAdShowSucceeded() {
    print("onInterstitialAdShowSucceeded");
  }
}
