import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../utils.dart';
import '../widgets/horizontal_buttons.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({Key? key}) : super(key: key);

  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> with IronSourceBannerListener {
  bool _isBNLoaded = false;

  @override
  void initState() {
    super.initState();
    IronSource.setBNListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Banner", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Load Banner", () async {
          final isCapped = await IronSource.isBannerPlacementCapped('DefaultBanner');
          print('BN DefaultBanner capped: $isCapped');
          if (!isCapped) {
            final size = IronSourceBannerSize.BANNER;
            // size.isAdaptive = true; // Adaptive Banner
            IronSource.loadBanner(
                size: size,
                position: IronSourceBannerPosition.Bottom,
                verticalOffset: -50,
                placementName: 'DefaultBanner');
          }
        }),
        ButtonInfo(
            "Destroy Banner",
            _isBNLoaded
                ? () {
                    IronSource.destroyBanner();
                    setState(() {
                      _isBNLoaded = false;
                    });
                  }
                : null)
      ]),
      HorizontalButtons([
        ButtonInfo("Display Banner", () {
          IronSource.displayBanner();
        }),
        ButtonInfo("Hide Banner", () {
          IronSource.hideBanner();
        })
      ]),
    ]);
  }

  /// BN listener ==================================================================================
  @override
  void onBannerAdClicked() {
    print("onBannerAdClicked");
  }

  @override
  void onBannerAdLoadFailed(IronSourceError error) {
    print("onBannerAdLoadFailed Error:$error");
    if (mounted) {
      setState(() {
        _isBNLoaded = false;
      });
    }
  }

  @override
  void onBannerAdLoaded() {
    print("onBannerAdLoaded");
    if (mounted) {
      setState(() {
        _isBNLoaded = true;
      });
    }
  }

  @override
  void onBannerAdScreenDismissed() {
    print("onBannerAdScreenDismissed");
  }

  @override
  void onBannerAdScreenPresented() {
    print("onBannerAdScreenPresented");
  }

  @override
  void onBannerAdLeftApplication() {
    print("onBannerAdLeftApplication");
  }
}
