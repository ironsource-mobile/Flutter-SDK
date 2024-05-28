package com.ironSource.ironsource_mediation

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAd
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import java.io.ByteArrayOutputStream

/**
 * Extension function to convert a Placement object to a Map.
 * This function converts the Placement object's properties into a HashMap with String keys
 * and Any values, allowing easy serialization or mapping of the object.
 *
 * @return A HashMap representing the Placement object.
 */
fun Placement.toMap(): HashMap<String, Any> {
    return hashMapOf(
        "placementName" to this.placementName,
        "rewardName" to this.rewardName,
        "rewardAmount" to this.rewardAmount
    )
}

/**
 * Extension function to convert an IronSourceError object to a Map.
 * This function converts the IronSourceError object's properties into a HashMap with String keys
 * and Any values, allowing easy serialization or mapping of the object.
 *
 * @return A HashMap representing the IronSourceError object.
 */
fun IronSourceError.toMap(): HashMap<String, Any> {
    return hashMapOf(
        "errorCode" to this.errorCode,
        "message" to this.errorMessage
    )
}

/**
 * Extension function to convert an ImpressionData object to a Map.
 * This function converts the ImpressionData object's properties into a HashMap with String keys
 * and Any values, allowing easy serialization or mapping of the object.
 *
 * @return A HashMap representing the ImpressionData object.
 */
fun ImpressionData.toMap(): HashMap<String, Any> {
    return hashMapOf(
        "auctionId" to this.auctionId,
        "adUnit" to this.adUnit,
        "country" to this.country,
        "ab" to this.ab,
        "segmentName" to this.segmentName,
        "placement" to this.placement,
        "adNetwork" to this.adNetwork,
        "instanceName" to this.instanceName,
        "instanceId" to this.instanceId,
        "revenue" to this.revenue,
        "precision" to this.precision,
        "lifetimeRevenue" to this.lifetimeRevenue,
        "encryptedCPM" to this.encryptedCPM
    )
}

/**
 * Extension function to convert an AdInfo object to a Map.
 * This function converts the AdInfo object's properties into a HashMap with String keys
 * and Any values, allowing easy serialization or mapping of the object.
 *
 * @return A HashMap representing the AdInfo object.
 */
fun AdInfo.toMap(): HashMap<String, Any> {
    return hashMapOf(
        "auctionId" to this.auctionId,
        "adUnit" to this.adUnit,
        "adNetwork" to this.adNetwork,
        "ab" to this.ab,
        "country" to this.country,
        "instanceId" to this.instanceId,
        "instanceName" to this.instanceName,
        "segmentName" to this.segmentName,
        "revenue" to this.revenue,
        "precision" to this.precision,
        "encryptedCPM" to this.encryptedCPM
    )
}

/**
 * Extension function to convert a LevelPlayNativeAd object to a Map.
 * This function converts the LevelPlayNativeAd object's properties into a HashMap with String keys
 * and nullable Any values, allowing easy serialization or mapping of the object.
 *
 * @return A HashMap representing the LevelPlayNativeAd object.
 */
fun LevelPlayNativeAd.toMap(): HashMap<String, Any?> {
    return hashMapOf(
        "title" to this.title,
        "body" to this.body,
        "advertiser" to this.advertiser,
        "callToAction" to this.callToAction,
        "iconUri" to this.icon?.uri.toString(),
        "iconImageData" to this.icon?.drawable?.toBytes()
    )
}

/**
 * Extension function to convert a Drawable to a byte array.
 * This function allows converting any Drawable object to a byte array,
 * which can be useful for various purposes such as saving to disk or sending over a network.
 * If the Drawable is a BitmapDrawable, it directly converts the contained Bitmap to bytes.
 * Otherwise, it draws the Drawable onto a new Bitmap and then converts the Bitmap to bytes.
 *
 * @return A byte array representing the Drawable.
 */
fun Drawable.toBytes(): ByteArray {
    // Check if the Drawable is a BitmapDrawable
    if (this is BitmapDrawable) {
        // If it is, convert the contained Bitmap to bytes using the toBytes() extension function for Bitmaps
        return bitmap.toBytes()
    }

    // If the Drawable is not a BitmapDrawable, create a new Bitmap with the intrinsic dimensions of the Drawable
    // Intrinsic dimensions represent the natural width and height of the Drawable
    // ARGB8888 is a color encoding scheme commonly used in computer graphics
    // A stands for Alpha channel, representing transparency.
    // R stands for Red channel.
    // G stands for Green channel.
    // B stands for Blue channel.
    val bitmap = Bitmap.createBitmap(intrinsicWidth, intrinsicHeight, Bitmap.Config.ARGB_8888)

    // Create a Canvas object with the newly created Bitmap
    // Canvas is used for drawing graphics on a Bitmap
    val canvas = Canvas(bitmap)

    // Set the bounds of the Drawable to match the Canvas dimensions
    // This ensures that the Drawable will be drawn at the correct size on the Canvas
    setBounds(0, 0, canvas.width, canvas.height)

    // Draw the Drawable onto the Canvas
    // This effectively renders the Drawable onto the Bitmap
    draw(canvas)

    // Convert the Bitmap to bytes using the toBytes() extension function for Bitmaps and return the result
    return bitmap.toBytes()
}

/**
 * Extension function to convert a Bitmap to a byte array.
 * This function compresses the Bitmap into a PNG format with maximum quality
 * and converts the compressed data into a byte array.
 *
 * @return A byte array representing the Bitmap.
 */
fun Bitmap.toBytes(): ByteArray {
    // Create a ByteArrayOutputStream to hold the bytes of the Bitmap
    val stream = ByteArrayOutputStream()

    // Compress the Bitmap into the ByteArrayOutputStream using PNG format with maximum quality (quality level 100)
    // PNG format is lossless, preserving the quality of the image
    compress(Bitmap.CompressFormat.PNG, 100, stream)

    // Convert the ByteArrayOutputStream to a byte array and return the result
    return stream.toByteArray()
}