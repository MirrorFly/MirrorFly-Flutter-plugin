package com.mirrorfly.mirrorfly_plugin.call.widgets

import android.content.Context
import android.graphics.drawable.Drawable
import androidx.core.content.ContextCompat
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.getColourCode
import com.mirrorfly.mirrorfly_plugin.call.getDisplayName
import com.mirrorflysdk.api.contacts.ProfileDetails

open class BaseDrawable {

    protected var context: Context? = null
    protected var profileDetails: ProfileDetails? = null

    @Synchronized
    fun setDrawable(name: String): Drawable? {
        var nameValue = name
        nameValue = nameValue.trim { it <= ' ' }.replace("\\s+".toRegex(), " ")
        context?.let { context ->
            profileDetails?.let { profileDetails ->
                val icon = CustomDrawable(context)
                return if (profileDetails.getDisplayName().isNullOrBlank())
                    ContextCompat.getDrawable(context, R.drawable.profile_img)
                else {
                    val initialName = nameValue.split(" ".toRegex()).toTypedArray()
                    if (initialName.size == 1) {
                        val charLength = initialName[0].toCharArray().size
                        when {
                            charLength <= 0 -> {
                                icon.setDrawableColour(nameValue.getColourCode())
                                icon.setText("")
                                icon
                            }
                            charLength <= 1 -> {
                                val firstLetter = String(Character.toChars(initialName[0].codePointAt(0)))
                                icon.setDrawableColour(nameValue.getColourCode())
                                icon.setText(firstLetter.uppercase())
                                icon
                            }
                            else -> {
                                val firstLetter = String(Character.toChars(initialName[0].codePointAt(0)))
                                val secondLetter = String(Character.toChars(initialName[0].codePointAt(1)))
                                icon.setDrawableColour(nameValue.getColourCode())
                                icon.setText(firstLetter.uppercase() + secondLetter.uppercase())
                                icon
                            }
                        }
                    } else {
                        val firstLetter = String(Character.toChars(initialName[0].codePointAt(0)))
                        val secondLetter = String(Character.toChars(initialName[1].codePointAt(0)))
                        icon.setText(firstLetter.uppercase() + secondLetter.uppercase())
                        icon.setDrawableColour(nameValue.getColourCode())
                        icon
                    }
                }
            }
        }
        return null
    }

}