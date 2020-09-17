// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:connectivity_platform_interface/connectivity_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'utils.dart';

/// An implementation of [ConnectivityPlatform] that uses method channels.
class MethodChannelConnectivity extends ConnectivityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel = MethodChannel('plugins.flutter.io/connectivity');

  /// The event channel used to receive ConnectivityResult changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel = EventChannel('plugins.flutter.io/connectivity_status');

  Stream<ConnectivityResult> _onConnectivityChanged;
  Stream<ConnectivityDetailedResult> _onConnectivityInfoChanged;

  /// Fires whenever the connectivity state changes.
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (_onConnectivityChanged == null) {
      _onConnectivityChanged = eventChannel
          .receiveBroadcastStream()
          .map((dynamic result) => result.toString())
          .map((dynamic r) => _parseConnectivityDetailedResult(r).result);
    }
    return _onConnectivityChanged;
  }

  /// Fires whenever the connectivity state changes. Return stream of [ConnectivityDetailedResult]
  Stream<ConnectivityDetailedResult> get onConnectivityInfoChanged {
    if (_onConnectivityInfoChanged == null) {
      _onConnectivityInfoChanged =
          eventChannel.receiveBroadcastStream().map((dynamic event) => _parseConnectivityDetailedResult(event));
    }
    return _onConnectivityInfoChanged;
  }

  /// You can also check the mobile broadband connectivity subtype via [getNetworkSubtype]
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    final String result = await methodChannel.invokeMethod<String>('check');
    return _parseConnectivityDetailedResult(result).result;
  }

  /// Checks connectivity info, [ConnectivityDetailedResult]
  Future<ConnectivityDetailedResult> checkConnectivityInfo() async {
    final String result = await methodChannel.invokeMethod<String>('check');
    return _parseConnectivityDetailedResult(result);
  }

  /// Checks the network mobile connection subtype of the device.
  /// Returns the appropriate mobile connectivity subtype enum [ConnectionSubtype] such
  /// as gprs, edge, hsdpa etc.
  ///
  /// More information on mobile connectivity types can be found at
  /// https://en.wikipedia.org/wiki/Mobile_broadband#Generations
  ///
  /// Return [ConnectionSubtype.unknown] if it is connected but there is not connection subtype info. eg. Wifi
  /// Returns [ConnectionSubtype.none] if there is no connection
  Future<ConnectionSubtype> getNetworkSubtype() async {
    final String result = await methodChannel.invokeMethod<String>('subtype');
    return _parseConnectionSubtype(result);
  }

  @override
  Future<String> getWifiName() async {
    String wifiName = await methodChannel.invokeMethod<String>('wifiName');
    // as Android might return <unknown ssid>, uniforming result
    // our iOS implementation will return null
    if (wifiName == '<unknown ssid>') {
      wifiName = null;
    }
    return wifiName;
  }

  @override
  Future<String> getWifiBSSID() {
    return methodChannel.invokeMethod<String>('wifiBSSID');
  }

  @override
  Future<String> getWifiIP() {
    return methodChannel.invokeMethod<String>('wifiIPAddress');
  }

  @override
  Future<LocationAuthorizationStatus> requestLocationServiceAuthorization({
    bool requestAlwaysLocationUsage = false,
  }) {
    return methodChannel.invokeMethod<String>('requestLocationServiceAuthorization',
        <bool>[requestAlwaysLocationUsage]).then(parseLocationAuthorizationStatus);
  }

  @override
  Future<LocationAuthorizationStatus> getLocationServiceAuthorization() {
    return methodChannel.invokeMethod<String>('getLocationServiceAuthorization').then(parseLocationAuthorizationStatus);
  }

  ConnectivityDetailedResult _parseConnectivityDetailedResult(String state) {
    final List<String> split = state.split(",");
    print("split");
    print(split);
    return ConnectivityDetailedResult(
      result: parseConnectivityResult(split[0]),
      subtype: (split.length > 1) ? _parseConnectionSubtype(split[1]) : ConnectionSubtype.none,
    );
  }

  ConnectionSubtype _parseConnectionSubtype(String state) {
    return connectionTypeMap[state] ?? ConnectionSubtype.unknown;
  }
}
