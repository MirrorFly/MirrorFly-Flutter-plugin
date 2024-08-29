package com.mirrorfly.mirrorfly_plugin.call

import android.util.Log
import androidx.annotation.Keep
import com.mirrorflysdk.flycommons.Constants
import com.mirrorflysdk.flycommons.FlyUtils.decodedToken
import com.mirrorflysdk.flycommons.LogMessage
import okhttp3.*
import okhttp3.Request
import okhttp3.Response
import okhttp3.ResponseBody.Companion.toResponseBody
import okhttp3.internal.http2.ConnectionShutdownException
import java.io.IOException
import java.lang.Exception
import java.net.SocketTimeoutException
import java.net.UnknownHostException


@Keep
class RequestTokenInterceptor : Interceptor {

    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request: Request = chain.request()
        return if (Constants.getBaseUrl().contains(request.url.host)) {
            val newRequest: Request
            val token = decodedToken().trim { it <= ' ' }
            newRequest = request.newBuilder().header("Authorization", token).method(request.method, request.body).build()
            LogMessage.d("RequestTokenInterceptor", newRequest.toString())
            try {
                chain.proceed(newRequest)
            } catch (e: Exception) {
                LogMessage.e("RequestTokenInterceptor", "Exception::" + e.message)
                e.printStackTrace()
                val msg = when (e) {
                    is SocketTimeoutException -> "Timeout - Please check your internet connection"
                    is UnknownHostException -> "Unable to make a connection. Please check your internet"
                    is ConnectionShutdownException -> "Connection shutdown. Please check your internet"
                    is IOException -> "Server is unreachable, please try again later."
                    is IllegalStateException -> "${e.message}"
                    else -> "${e.message}"
                }
                Response.Builder().request(request).protocol(Protocol.HTTP_1_1).code(999)
                    .message(msg).body("{${e}}".toResponseBody(null)).build()
            }
        } else {
            Log.d("RequestTokenInterceptor", "skipped adding auth headers")
            chain.proceed(request)
        }
    }
}