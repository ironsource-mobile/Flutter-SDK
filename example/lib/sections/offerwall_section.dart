import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../widgets/horizontal_buttons.dart';
import '../utils.dart';

class OfferwallSection extends StatefulWidget {
  const OfferwallSection({Key? key}) : super(key: key);

  @override
  _OfferwallSectionState createState() => _OfferwallSectionState();
}

class _OfferwallSectionState extends State<OfferwallSection>
    with IronSourceOfferwallListener {
  bool _isOfferWallAvailable = false;

  @override
  void initState() {
    super.initState();
    IronSource.setOfferWallListener(this);
  }

  /// Sample OfferWall Custom Params - current DateTime milliseconds\
  /// Must be called before show
  Future<void> setOfferWallCustomParams() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    await IronSource.setOfferwallCustomParams({'dateTimeMillSec': time});
    Utils.showTextDialog(context, "OfferWall Custom Param Set", time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Offerwall", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo(
            "ShowOfferwall",
            _isOfferWallAvailable
                ? () async {
                    if (await IronSource.isOfferwallAvailable()) {
                      // IronSource.showOfferwall(placementName: 'DefaultOfferwall');
                      IronSource.showOfferwall();
                    }
                  }
                : null),
      ]),
      HorizontalButtons([
        ButtonInfo("GetOfferwallCredits", () {
          IronSource.getOfferwallCredits();
        })
      ]),
      HorizontalButtons([
        ButtonInfo("SetOfferWallCustomParams", () {
          setOfferWallCustomParams();
        })
      ]),
    ]);
  }

  // OfferWall listener

  @override
  void onOfferwallAvailabilityChanged(bool isAvailable) {
    print("onOfferwallAvailabilityChanged isAvailable:$isAvailable");
    if (mounted) {
      setState(() {
        _isOfferWallAvailable = isAvailable;
      });
    }
  }

  @override
  void onOfferwallOpened() {
    print("onOfferwallOpened");
  }

  @override
  void onOfferwallShowFailed(IronSourceError error) {
    print("onOfferwallShowFailed Error:$error");
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {
    print("onGetOfferwallCreditsFailed Error:$error");
  }

  @override
  void onOfferwallAdCredited(IronSourceOfferWallCreditInfo creditInfo) {
    print("onOfferwallAdCredited creditInfo:$creditInfo");
    if (mounted) {
      Utils.showTextDialog(
          context, 'Offerwall Credited', creditInfo.toString());
    }
  }

  @override
  void onOfferwallClosed() {
    print("onOfferwallClosed");
  }
}
