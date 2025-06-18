package com.mirrorfly.mirrorfly_plugin.call;

import androidx.annotation.Keep;
import java.io.IOException;
import java.util.Objects;
import okhttp3.Authenticator;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okhttp3.Route;
import org.jetbrains.annotations.NotNull;
import org.json.JSONException;
import org.json.JSONObject;

import com.mirrorflysdk.FlyExtensions;
import com.mirrorflysdk.api.ChatManager;
import com.mirrorflysdk.flycommons.Constants;
import com.mirrorflysdk.flycommons.FlyUtils;
import com.mirrorflysdk.flycommons.LogMessage;
import com.mirrorflysdk.flycommons.SharedPreferenceManager;

/**
 * The authenticator is used to handle authorization errors like 401 ,403, if authorization error occurred, it will
 * refresh the token and execute the request with new access token.
 *
 * @author ContusTeam <developers@contus.in>
 * @version 1.0
 */
@Keep
public class FlutterTokenAuthenticator implements Authenticator {
    private static final String TAG = FlutterTokenAuthenticator.class.getSimpleName();
    private static final okhttp3.OkHttpClient client = new OkHttpClient();
    private static final String TOKEN = "token";
    private static final int RETRY_LIMIT = 3;

    public FlutterTokenAuthenticator() {
    }

    public okhttp3.Request authenticate(Route route, @NotNull okhttp3.Response response) throws IOException {
        int retryCount = this.responseCount(response);
        if (retryCount >= 3) {
            LogMessage.i(TAG, "Retry count exceeded! Giving up.");
            return null;
        } else {
            LogMessage.d(TAG, "Retrying count: " + retryCount);
            LogMessage.i(TAG, "Refreshing Auth token...");
            if (this.refreshToken()) {
                LogMessage.i(TAG, "Proceeding the request with new Auth token...");
                String newAccessToken = FlyUtils.decodedToken().trim();
                return response.request().newBuilder().header("Authorization", newAccessToken).build();
            } else {
                LogMessage.e(TAG, "Refreshing Auth token Failed...");
                return response.request();
            }
        }
    }

    private int responseCount(okhttp3.Response response) {
        int result;
        for(result = 1; (response = response.priorResponse()) != null; ++result) {
        }

        return result;
    }

    private boolean refreshToken() throws IOException {
        String userName = SharedPreferenceManager.instance.getString("username");
        String password = SharedPreferenceManager.instance.getString("password");
        JSONObject params = new JSONObject();

        try {
            params.put("password", password);
            params.put("currentTimestamp", System.currentTimeMillis());
        } catch (JSONException var15) {
            var15.printStackTrace();
            return false;
        }

        String paramsString = params.toString();
        String licenseKey = ChatManager.getLicenseKey();//Prefs.getString("licenseKey");
        String shaString = FlyUtils.keyText(licenseKey, 3);
        String encryptedData;
//        if (Prefs.getBoolean("is_trial_licence_key")) {
        if (ChatManager.isTrailLicenceKey()) {
            encryptedData = password;
        } else {
            encryptedData = FlyUtils.encryptString(paramsString, shaString);
        }

        JSONObject jsonObject = new JSONObject();

        try {
            jsonObject.put("username", userName);
            jsonObject.put("password", encryptedData);
            jsonObject.put("type", "android");
        } catch (JSONException var14) {
            var14.printStackTrace();
            return false;
        }

        okhttp3.MediaType json = MediaType.parse("application/json; charset=utf-8");
        okhttp3.RequestBody body = RequestBody.create(json, jsonObject.toString());
        LogMessage.d(TAG, "request body: " + jsonObject.toString());
        okhttp3.Request.Builder requestBuilder = new Request.Builder();
        requestBuilder.url(Constants.getBaseUrl() + "login");
        requestBuilder.post(body);
        Response response = client.newCall(requestBuilder.build()).execute();
        if (response.body() != null) {
            String responseString = ((ResponseBody)Objects.requireNonNull(response.body())).string();
            this.updateToken(responseString);
            return true;
        } else {
            return false;
        }
    }

    private void updateToken(String response) {
        String userName = SharedPreferenceManager.instance.getString("username");
        String sha = FlyUtils.keyText(userName, 3);

        try {
            String result = FlyExtensions.returnEmptyIfNull(response);
            JSONObject jsonResponseObject = new JSONObject(result);
            if ("200".equals(jsonResponseObject.getString("status"))) {
                String data = jsonResponseObject.getString("data");
                JSONObject responseObject = new JSONObject(FlyExtensions.returnEmptyIfNull(data));
                LogMessage.d(TAG, "Response: " + responseObject.toString());
                String newToken = FlyUtils.encryptString(responseObject.getString("token"), sha);
                SharedPreferenceManager.instance.storeString("authToken", newToken);
                LogMessage.i(TAG, "Token Refresh status : success");
                LogMessage.d(TAG, "new token : " + FlyUtils.decodedToken());
            } else {
                LogMessage.e(TAG, "Token Refresh status : failed");
            }
        } catch (Exception var9) {
            LogMessage.e(TAG, "Exception : " + var9.getMessage());
        }

    }
}