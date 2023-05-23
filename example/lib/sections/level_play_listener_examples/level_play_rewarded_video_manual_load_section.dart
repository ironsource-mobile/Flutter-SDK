import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../../utils.dart';
import '../../widgets/horizontal_buttons.dart';

/// LevelPlayRewardedVideoManualListener integration example\
/// Can be swapped with RewardedVideoManualLoadSection
class LevelPlayRewardedVideoManualLoadSection extends StatefulWidget {
  const LevelPlayRewardedVideoManualLoadSection({Key? key}) : super(key: key);

  @override
  _LevelPlayRewardedVideoManualLoadSectionState createState() =>
      _LevelPlayRewardedVideoManualLoadSectionState();
}

class _LevelPlayRewardedVideoManualLoadSectionState
    extends State<LevelPlayRewardedVideoManualLoadSection>
    with LevelPlayRewardedVideoManualListener {
  bool _isRewardedVideoAvailable = false;
  bool _isVideoAdVisible = false;
  IronSourceRewardedVideoPlacement? _placement;

  @override
  void initState() {
    super.initState();
    IronSource.setLevelPlayRewardedVideoManualListener(this);
  }

  /// Sample RewardedVideo Custom Params - current DateTime milliseconds
  Future<void> setRewardedVideoCustomParams() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    await IronSource.setRewardedVideoServerParams({'dateTimeMillSec': time});
    Utils.showTextDialog(context, "RewardedVideo Custom Param Set", time);
  }

  /// Solely for debug/testing purpose
  Future<void> checkRewardedVideoPlacement() async {
    final placement = await IronSource.getRewardedVideoPlacementInfo(
        placementName: 'DefaultRewardedVideo');
    print('DefaultRewardedVideo info $placement');

    // this falls back to the default placement, not null
    final noSuchPlacement =
        await IronSource.getRewardedVideoPlacementInfo(placementName: 'NoSuch');
    print('NoSuchPlacement info $noSuchPlacement');

    final isPlacementCapped = await IronSource.isRewardedVideoPlacementCapped(
        placementName: 'CAPPED_PLACEMENT');
    print('CAPPED_PLACEMENT isPlacementCapped: $isPlacementCapped');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Rewarded Video", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo(
            "Load RewardedVideo",
            !_isRewardedVideoAvailable
                ? () {
                    IronSource.loadRewardedVideo();
                  }
                : null),
        ButtonInfo(
            "Show RewardedVideo",
            _isRewardedVideoAvailable
                ? () async {
                    // checkRewardedVideoPlacement();
                    if (await IronSource.isRewardedVideoAvailable()) {
                      // for the RewardedVideo server-to-server callback param
                      // await IronSource.setDynamicUserId('some-dynamic-user-id');

                      // for placement capping test
                      // IronSource.showRewardedVideo(placementName: 'CAPPED_PLACEMENT');
                      IronSource.showRewardedVideo();

                      // onRewardedVideoAvailabilityChanged(false) won't be called on show
                      // So, the state must be changed manually.
                      setState(() {
                        _isRewardedVideoAvailable = false;
                      });
                    }
                  }
                : null),
      ]),
      HorizontalButtons([
        ButtonInfo("SetRewardedVideoServerParams",
            () => setRewardedVideoCustomParams()),
      ]),
      HorizontalButtons([
        ButtonInfo("ClearRewardedVideoServerParams",
            () => IronSource.clearRewardedVideoServerParams())
      ]),
    ]);
  }

  // LevelPlay RewardedVideo Manual listener

  @override
  void onAdReady(IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdReady: $adInfo");
    if (mounted) {
      setState(() {
        _isRewardedVideoAvailable = true;
      });
    }
  }

  @override
  void onAdLoadFailed(IronSourceError error) {
    print("RewardedVideo - onAdLoadFailed: $error");
    if (mounted) {
      setState(() {
        _isRewardedVideoAvailable = false;
      });
    }
  }

  @override
  void onAdOpened(IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdOpened: $adInfo");
    if (mounted) {
      setState(() {
        _isVideoAdVisible = true;
      });
    }
  }

  @override
  void onAdClosed(IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdClosed: $adInfo");
    setState(() {
      _isVideoAdVisible = false;
    });
    if (mounted && _placement != null && !_isVideoAdVisible) {
      Utils.showTextDialog(
          context, 'Video Reward', _placement?.toString() ?? '');
      setState(() {
        _placement = null;
      });
    }
  }

  @override
  void onAdRewarded(
      IronSourceRewardedVideoPlacement placement, IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdRewarded: $placement, $adInfo");
    setState(() {
      _placement = placement;
    });
    if (mounted && _placement != null && !_isVideoAdVisible) {
      Utils.showTextDialog(
          context, 'Video Reward', _placement?.toString() ?? '');
      setState(() {
        _placement = null;
      });
    }
  }

  @override
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdShowFailed: $error, $adInfo");
    if (mounted) {
      setState(() {
        _isVideoAdVisible = false;
      });
    }
  }

  @override
  void onAdClicked(
      IronSourceRewardedVideoPlacement placement, IronSourceAdInfo adInfo) {
    print("RewardedVideo - onAdClicked: $placement, $adInfo");
  }
}
