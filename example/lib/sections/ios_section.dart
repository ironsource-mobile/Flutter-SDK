import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import '../widgets/horizontal_buttons.dart';
import '../utils.dart';

class IOSSection extends StatefulWidget {
  const IOSSection({Key? key}) : super(key: key);
  
  @override
  _IOSSectionState createState() => _IOSSectionState();
}

class _IOSSectionState extends State<IOSSection> with IronSourceConsentViewListener {
  @override
  void initState() {
    super.initState();
    IronSource.setConsentViewListener(this);
  }

  /// load here and show on the listener callback
  Future<void> loadAndShowConsentView() async {
    await IronSource.loadConsentViewWithType('pre');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("iOS 14", style: Utils.headingStyle),
      HorizontalButtons([
        ButtonInfo("GetConversionValue", () async {
          final cv = await IronSource.getConversionValue();
          Utils.showTextDialog(context, "ConversionValue", cv.toString());
        }),
      ]),
      HorizontalButtons([ButtonInfo("ShowConsentView", () => loadAndShowConsentView())])
    ]);
  }

  // ConsentView listener //////////////////////////////////////////////////////////////////////////
  
  @override
  void consentViewDidAccept(String consentViewType) {
    print('consentViewDidAccept consentViewType:$consentViewType');
  }

  @override
  void consentViewDidFailToLoad(IronSourceConsentViewError error) {
    print('consentViewDidFailToLoad error:$error');
  }

  @override
  void consentViewDidFailToShow(IronSourceConsentViewError error) {
    print('consentViewDidFailToShow error:$error');
  }

  @override
  void consentViewDidLoadSuccess(String consentViewType) {
    print('consentViewDidLoadSuccess consentViewType:$consentViewType');
    if (mounted) {
      IronSource.showConsentViewWithType(consentViewType);
    }
  }

  @override
  void consentViewDidShowSuccess(String consentViewType) {
    print('consentViewDidLoadSuccess consentViewType:$consentViewType');
  }
}
