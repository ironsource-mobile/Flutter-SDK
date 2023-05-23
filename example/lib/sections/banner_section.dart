import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../utils.dart';
import '../widgets/horizontal_buttons.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({Key? key}) : super(key: key);

  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection>
    with IronSourceBannerListener {
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    IronSource.setBannerListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Banner", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("Load Banner", () async {
          final isCapped =
              await IronSource.isBannerPlacementCapped('DefaultBanner');
          print('Banner DefaultBanner capped: $isCapped');
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
            _isBannerLoaded
                ? () {
                    IronSource.destroyBanner();
                    setState(() {
                      _isBannerLoaded = false;
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

  /// Banner listener ==================================================================================
  @override
  void onBannerAdClicked() {
    print("onBannerAdClicked");
  }

  @override
  void onBannerAdLoadFailed(IronSourceError error) {
    print("onBannerAdLoadFailed Error:$error");
    if (mounted) {
      setState(() {
        _isBannerLoaded = false;
      });
    }
  }

  @override
  void onBannerAdLoaded() {
    print("onBannerAdLoaded");
    if (mounted) {
      setState(() {
        _isBannerLoaded = true;
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
