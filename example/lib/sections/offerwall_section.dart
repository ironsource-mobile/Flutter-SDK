import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../widgets/horizontal_buttons.dart';
import '../utils.dart';

class OfferwallSection extends StatefulWidget {
  const OfferwallSection({Key? key}) : super(key: key);
  
  @override
  _OfferwallSectionState createState() => _OfferwallSectionState();
}

class _OfferwallSectionState extends State<OfferwallSection> with IronSourceOfferwallListener {
  bool _isOWAvailable = false;

  @override
  void initState() {
    super.initState();
    IronSource.setOWListener(this);
  }

  /// Sample OW Custom Params - current DateTime milliseconds
  /// Must be called before show
  Future<void> setOWCustomParams() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    await IronSource.setOfferwallCustomParams({'dateTimeMillSec': time});
    Utils.showTextDialog(context, "OW Custom Param Set", time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Offerwall", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo(
            "ShowOfferwall",
            _isOWAvailable
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
        ButtonInfo("SetOWCustomParams", () {
          setOWCustomParams();
        })
      ]),
    ]);
  }

  /// OW listener ==================================================================================

  @override
  void onOfferwallAvailabilityChanged(bool isAvailable) {
    print("onOfferwallAvailabilityChanged isAvailable:$isAvailable");
    if (mounted) {
      setState(() {
        _isOWAvailable = isAvailable;
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
  void onOfferwallAdCredited(IronSourceOWCreditInfo creditInfo) {
    print("onOfferwallAdCredited creditInfo:$creditInfo");
    if (mounted) {
      Utils.showTextDialog(context, 'Offerwall Credited', creditInfo.toString());
    }
  }

  @override
  void onOfferwallClosed() {
    print("onOfferwallClosed");
  }
}
