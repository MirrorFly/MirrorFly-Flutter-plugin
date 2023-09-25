package com.mirrorfly.mirrorfly_plugin.call

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorflysdk.api.FlyMessenger
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycall.webrtc.api.CallLogManager
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.flycommons.PendingIntentHelper
import java.security.SecureRandom

object CallNotificationUtils {

    var unReadCallCount = 0
    /**
     * Creates the missed call notification
     *
     * @param context        Instance of Context
     * @param message        message
     * @param messageContent notification message content
     */
    fun createNotification(context: Context, message: String?, messageContent: String?) {
        val randomNumberGenerator = SecureRandom()
        val bound = 1000
        val channelId = randomNumberGenerator.nextInt(bound).toString()
        val notificationManager = context
                .getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        unReadCallCount += 1
//        unReadCallCount = if (NotificationBuilder.chatNotifications.size == 0) getTotalUnReadCount() else unReadCallCount
        unReadCallCount = getTotalUnReadCount()

        Log.d("CallNotification","unReadCallCount $unReadCallCount ${RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)}")
        val notBuilder = NotificationCompat.Builder(context, channelId)
        notBuilder.setSmallIcon(getNotificationIcon(context))
//        notBuilder.color = ContextCompat.getColor(context, R.color.colorAccent)
        notBuilder.setContentTitle(message)
        notBuilder.setContentText(messageContent)
        notBuilder.setAutoCancel(true)
        notBuilder.setCategory(NotificationCompat.CATEGORY_MISSED_CALL)
        notBuilder.setNumber(unReadCallCount)
//        val createdChannel: NotificationChannel
//        val notificationSoundUri = Uri.parse(SharedPreferenceManager().getString(Constants.NOTIFICATION_URI))
        val isRing = true//SharedPreferenceManager().getBoolean(Constants.NOTIFICATION_SOUND)
        val isVibrate = false//SharedPreferenceManager().getBoolean(Constants.VIBRATION)
        val channelImportance = getChannelImportance(isRing, isVibrate)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the channel for the notification
            val mChannel = NotificationChannel(channelId, channelId, channelImportance)
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build()
            mChannel.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),audioAttributes)
            notificationManager.createNotificationChannel(mChannel)
            notBuilder.setChannelId(channelId)
            /*when {
                isRing -> {
                    val mChannel = NotificationChannel(channelId, channelId, channelImportance)
                    val audioAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .build()
                    if(notificationSoundUri != null) {
                        NotifyRefererUtils.setNotificationChannelSound(notificationSoundUri,audioAttributes,
                            mChannel,context)
                        if (isVibrate) {
                            mChannel.vibrationPattern =
                                NotifyRefererUtils.defaultVibrationPattern
                        } else {
                            mChannel.vibrationPattern = longArrayOf(0L, 0L, 0L, 0L, 0L)
                        }
                    } else {
                        notificationSoundUri?.let {
                            NotifyRefererUtils.setNotificationChannelSound(
                                it,audioAttributes,
                                mChannel,context)
                        }
                    }
                    createdChannel = mChannel
                }
                isVibrate -> {
                    val priorityChannel = NotificationChannel(channelId, channelId, channelImportance)
                    priorityChannel.shouldVibrate()
                    priorityChannel.vibrationPattern = NotifyRefererUtils.defaultVibrationPattern
                    priorityChannel.shouldVibrate()
                    priorityChannel.enableVibration(true)
                    priorityChannel.setSound(null, null)
                    createdChannel = priorityChannel
                }
                else -> {
                    val lowPriorityChannel = NotificationChannel(channelId, channelId, channelImportance)
                    createdChannel = lowPriorityChannel
                }
            }
            // Set the Notification Channel for the Notification Manager.

            notificationManager.createNotificationChannel(createdChannel)
            notBuilder.setChannelId(channelId)*/

        } else {
            //NotifyRefererUtils.setNotificationSound(notBuilder)
            notBuilder.setChannelId(channelId)
            notBuilder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
        }

        val notificationIntent = AppUtils.getAppIntent(context)
        notificationIntent?.let {
            it.flags = Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            it.putExtra(Constants.IS_CALL_NOTIFICATION, true)
            val pendingIntent = PendingIntentHelper.getActivity(
                context, CallConstants.CALL_NOTIFICATION_ID,
                it
            )
            notBuilder.setContentIntent(pendingIntent)
        }
        val notification = notBuilder.build()
        //if (!SharedPreferenceManager.getBoolean(Constants.MUTE_NOTIFICATION))
        Log.d("CallNotification","notify $notification")
        notificationManager.notify(CallConstants.CALL_NOTIFICATION_ID, notification)
    }

    private fun getChannelImportance(isRing: Boolean, isVibrate: Boolean): Int {
        return if (isRing || isVibrate)
            NotificationManager.IMPORTANCE_HIGH
        else
            NotificationManager.IMPORTANCE_LOW
    }

    private fun getNotificationIcon(context:Context): Int {
        Log.d("CallNotification", "getNotificationIcon()")
        return getDrawableResourceId(context,"ic_notification")//R.drawable.ic_notification_blue
    }

    private fun getTotalUnReadCount(): Int {
//        return if (NotificationBuilder.chatNotifications.size == 0) FlyMessenger.getUnreadMessageCountExceptMutedChat() + CallLogManager.getUnreadMissedCallCount() else 1
        return  FlyMessenger.getUnreadMessageCountExceptMutedChat() + CallLogManager.getUnreadMissedCallCount()
    }

    fun cancelNotifications() {
        unReadCallCount = 0
    }
    private fun getDrawableResourceId(context: Context, name: String): Int {
        return context.resources.getIdentifier(name, "drawable", context.packageName)
    }

}