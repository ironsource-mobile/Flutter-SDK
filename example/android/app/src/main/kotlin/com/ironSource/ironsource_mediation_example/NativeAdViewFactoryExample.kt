package com.ironSource.ironsource_mediation_example

import com.ironSource.ironsource_mediation.LevelPlayNativeAdViewFactory
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.ironsource.mediationsdk.ads.nativead.LevelPlayMediaView
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAd
import com.ironsource.mediationsdk.ads.nativead.NativeAdLayout
import io.flutter.plugin.common.BinaryMessenger

/**
 * This class is an example of how to implement custom native ad.
 * The Class must receive BinaryMessenger and the layoutId of the
 * native ad layout that the developer wants to load. It also
 * must extend the LevelPlayNativeAdViewFactory and override the
 * method bindNativeAdToView in order to fill the view with the
 * loaded native ad.
 */
class NativeAdViewFactoryExample(
    levelPlayBinaryMessenger: BinaryMessenger,
    layoutId: Int
) : LevelPlayNativeAdViewFactory(levelPlayBinaryMessenger, layoutId) {

    override fun bindNativeAdToView(nativeAd: LevelPlayNativeAd?, nativeAdLayout: NativeAdLayout) {
        // Extract views
        val titleView = nativeAdLayout.findViewById<TextView>(R.id.adTitle)
        val bodyView = nativeAdLayout.findViewById<TextView>(R.id.adBody)
        val advertiserView = nativeAdLayout.findViewById<TextView>(R.id.adAdvertiser)
        val callToActionView = nativeAdLayout.findViewById<Button>(R.id.adCallToAction)
        val iconView = nativeAdLayout.findViewById<ImageView>(R.id.adAppIcon)
        val mediaView = nativeAdLayout.findViewById<LevelPlayMediaView>(R.id.adMedia)

        // Bind native ad to view
        if (nativeAd != null) {
            if (nativeAd.title != null) {
                titleView.text = nativeAd.title
                nativeAdLayout.setTitleView(titleView)
            }

            if (nativeAd.body != null) {
                bodyView.text = nativeAd.body
                nativeAdLayout.setBodyView(bodyView)
            }

            if (nativeAd.advertiser != null) {
                advertiserView.text = nativeAd.advertiser
                nativeAdLayout.setAdvertiserView(advertiserView)
            }

            if (nativeAd.callToAction != null) {
                callToActionView.text = nativeAd.callToAction
                nativeAdLayout.setCallToActionView(callToActionView)
            }

            if (nativeAd.icon != null) {
                iconView!!.setImageDrawable(nativeAd.icon!!.drawable)
                nativeAdLayout.setIconView(iconView)
            }

            if (mediaView != null) {
                nativeAdLayout.setMediaView(mediaView)
            }

            nativeAdLayout.registerNativeAdViews(nativeAd)
        }
    }
}