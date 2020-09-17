// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.connectivity;

import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/** Reports connectivity related information such as connectivity type and wifi information. */
class Connectivity {
  private ConnectivityManager connectivityManager;
  private WifiManager wifiManager;

  Connectivity(ConnectivityManager connectivityManager, WifiManager wifiManager) {
    this.connectivityManager = connectivityManager;
    this.wifiManager = wifiManager;
  }

  String getNetworkType() {
    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      Network network = connectivityManager.getActiveNetwork();
      NetworkCapabilities capabilities = connectivityManager.getNetworkCapabilities(network);
      if (capabilities == null) {
        return "none";
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
          || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
        return "wifi";
      }
      if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
        return "mobile";
      }
    }

    return getNetworkTypeLegacy();
  }

  String getWifiName() {
    WifiInfo wifiInfo = getWifiInfo();
    String ssid = null;
    if (wifiInfo != null) ssid = wifiInfo.getSSID();
    if (ssid != null) ssid = ssid.replaceAll("\"", ""); // Android returns "SSID"
    return ssid;
  }

  String getWifiBSSID() {
    WifiInfo wifiInfo = getWifiInfo();
    String bssid = null;
    if (wifiInfo != null) {
      bssid = wifiInfo.getBSSID();
    }
    return bssid;
  }

  String getWifiIPAddress() {
    WifiInfo wifiInfo = null;
    if (wifiManager != null) wifiInfo = wifiManager.getConnectionInfo();

    String ip = null;
    int i_ip = 0;
    if (wifiInfo != null) i_ip = wifiInfo.getIpAddress();

    if (i_ip != 0)
      ip =
          String.format(
              "%d.%d.%d.%d",
              (i_ip & 0xff), (i_ip >> 8 & 0xff), (i_ip >> 16 & 0xff), (i_ip >> 24 & 0xff));

    return ip;
  }

  private WifiInfo getWifiInfo() {
    return wifiManager == null ? null : wifiManager.getConnectionInfo();
  }

  @SuppressWarnings("deprecation")
  private String getNetworkTypeLegacy() {
    // handle type for Android versions less than Android 9
    NetworkInfo info = connectivityManager.getActiveNetworkInfo();
    if (info == null || !info.isConnected()) {
      return "none";
    }
    int type = info.getType();
    switch (type) {
      case ConnectivityManager.TYPE_ETHERNET:
      case ConnectivityManager.TYPE_WIFI:
      case ConnectivityManager.TYPE_WIMAX:
        return "wifi";
      case ConnectivityManager.TYPE_MOBILE:
      case ConnectivityManager.TYPE_MOBILE_DUN:
      case ConnectivityManager.TYPE_MOBILE_HIPRI:
        return "mobile";
      default:
        return "none";
    }
  }

  @Nullable
  String getNetworkSubType() {

    NetworkInfo info = this.connectivityManager.getActiveNetworkInfo();

    if (info == null || !info.isConnected()) {
      return null;
    }

    /// Telephony Manager documentation  https://developer.android.com/reference/android/telephony/TelephonyManager
    /// Information about mobile broadband - https://en.wikipedia.org/wiki/Mobile_broadband#Generations

    switch (info.getSubtype()) {
      case TelephonyManager.NETWORK_TYPE_1xRTT: {
        return "1xRTT"; // ~ 50-100 kbps
      }
      case TelephonyManager.NETWORK_TYPE_CDMA: {
        return "cdma"; // ~ 14-64 kbps
      }
      case TelephonyManager.NETWORK_TYPE_EDGE: {
        return "edge"; // ~ 50-100 kbps
      }
      case TelephonyManager.NETWORK_TYPE_EVDO_0: {
        return "evdo_0"; // ~ 400-1000 kbps
      }
      case TelephonyManager.NETWORK_TYPE_EVDO_A: {
        return "evdo_a"; // ~ 600-1400 kbps
      }
      case TelephonyManager.NETWORK_TYPE_GPRS: {
        return "gprs"; // ~ 100 kbps
      }
      case TelephonyManager.NETWORK_TYPE_HSDPA: {
        return "hsdpa"; // ~ 2-14 Mbps
      }
      case TelephonyManager.NETWORK_TYPE_HSPA: {
        return "hspa"; // ~ 700-1700 kbps
      }
      case TelephonyManager.NETWORK_TYPE_HSUPA: {
        return "hsupa"; // ~ 1-23 Mbps
      }
      case TelephonyManager.NETWORK_TYPE_UMTS: {
        return "umts"; // ~ 400-7000 kbps
      }
      /*
       * Above API level 7, make sure to set android:targetSdkVersion
       * to appropriate level to use these
       */
      case TelephonyManager.NETWORK_TYPE_EHRPD: { // API level 11
        return "ehrpd"; // ~ 1-2 Mbps
      }
      case TelephonyManager.NETWORK_TYPE_EVDO_B: { // API level 9
        return "evdo_b"; // ~ 5 Mbps
      }
      case TelephonyManager.NETWORK_TYPE_HSPAP: { // API level 13
        return "hspap"; // ~ 10-20 Mbps
      }
      case TelephonyManager.NETWORK_TYPE_IDEN: { // API level 8
        return "iden"; // ~25 kbps
      }
      case TelephonyManager.NETWORK_TYPE_LTE: { // API level 11
        return "lte"; // ~ 10+ Mbps
      }
      // Unknown
      case TelephonyManager.NETWORK_TYPE_UNKNOWN: {
        return "unknown"; // is connected but cannot tell the speed
      }
      default: {
        return null;
      }
    }
  }
}
