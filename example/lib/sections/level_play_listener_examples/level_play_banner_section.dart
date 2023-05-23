import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../../utils.dart';
import '../../widgets/horizontal_buttons.dart';

/// LevelPlayBannerListener integration example\
/// Can be swapped with BannerSection
class LevelPlayBannerSection extends StatefulWidget {
  const LevelPlayBannerSection({Key? key}) : super(key: key);

  @override
  _LevelPlayBannerSectionState createState() => _LevelPlayBannerSectionState();
}

class _LevelPlayBannerSectionState extends State<LevelPlayBannerSection>
    with LevelPlayBannerListener {
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    IronSource.setLevelPlayBannerListener(this);
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

  // Banner listener

  @override
  void onAdLoaded(IronSourceAdInfo adInfo) {
    print("onAdLoaded: $adInfo");
    if (mounted) {
      setState(() {
        _isBannerLoaded = true;
      });
    }
  }

  @override
  void onAdLoadFailed(IronSourceError error) {
    print("Banner - onAdLoadFailed Error:$error");
    if (mounted) {
      setState(() {
        _isBannerLoaded = false;
      });
    }
  }

  @override
  void onAdClicked(IronSourceAdInfo adInfo) {
    print("Banner - onAdClicked: $adInfo");
  }

  @override
  void onAdScreenDismissed(IronSourceAdInfo adInfo) {
    print("Banner - onAdScreenDismissed: $adInfo");
  }

  @override
  void onAdScreenPresented(IronSourceAdInfo adInfo) {
    print("Banner - onAdScreenPresented: $adInfo");
  }

  @override
  void onAdLeftApplication(IronSourceAdInfo adInfo) {
    print("Banner - onAdLeftApplication: $adInfo");
  }
}
