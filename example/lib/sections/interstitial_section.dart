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
  bool _isISAvailable = false;

  @override
  void initState() {
    super.initState();
    IronSource.setISListener(this);
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
            _isISAvailable
                ? () async {
                    final isCapped =
                        await IronSource.isInterstitialPlacementCapped(placementName: "Default");
                    print('IS Default placement capped: $isCapped');
                    if (!isCapped && await IronSource.isInterstitialReady()) {
                      IronSource.showInterstitial();
                    }
                  }
                : null)
      ])
    ]);
  }

  /// IS listener ==================================================================================
  @override
  void onInterstitialAdClicked() {
    print("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    print("onInterstitialAdClosed");
    if (mounted) {
      setState(() {
        _isISAvailable = false;
      });
    }
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    print("onInterstitialAdLoadFailed Error:$error");
    if (mounted) {
      setState(() {
        _isISAvailable = false;
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
        _isISAvailable = true;
      });
    }
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    print("onInterstitialAdShowFailed Error:$error");
    if (mounted) {
      setState(() {
        _isISAvailable = false;
      });
    }
  }

  @override
  void onInterstitialAdShowSucceeded() {
    print("onInterstitialAdShowSucceeded");
  }
}
