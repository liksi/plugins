/// Connection status check result.
enum ConnectivityResult {
  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Mobile: Device connected to cellular network
  mobile,

  /// None: Device not connected to any network
  none
}

// ignore: public_member_api_docs
class ConnectivityDetailedResult {
  // ignore: public_member_api_docs
  ConnectivityDetailedResult({
    this.result = ConnectivityResult.none,
    this.subtype = ConnectionSubtype.none,
  });

  final ConnectivityResult result;
  final ConnectionSubtype subtype;
}

/// Subtype enum
enum ConnectionSubtype {
  /// no subtype
  none,

  /// unknown subtypes
  unknown,

  /// ~ 50-100 kbps
  m1xRTT,

  /// ~ 14-64 kbps
  cdma,

  /// ~ 50-100 kbps
  edge,

  /// ~ 400-1000 kbps
  evdo_0,

  /// ~ 600-1400 kbps
  evdo_a,

  /// ~ 100 kbps
  gprs,

  /// ~ 2-14 Mbps
  hsdpa,

  /// ~ 700-1700 kbps
  hspa,

  /// ~ 1-23 Mbps
  hsupa,

  /// ~ 400-7000 kbps
  umts,

  /// ~ 1-2 Mbps
  ehrpd,

  /// ~ 5 Mbps
  evdo_b,

  /// ~ 10-20 Mbps
  hspap,

  /// ~25 kbps
  iden,

  /// ~ 10+ Mbps
  lte,
}

/// Map with the subtypes
Map<String, ConnectionSubtype> connectionTypeMap = <String, ConnectionSubtype>{
  "1xRTT": ConnectionSubtype.m1xRTT, // ~ 50-100 kbps
  "cdma": ConnectionSubtype.cdma, // ~ 14-64 kbps
  "edge": ConnectionSubtype.edge, // ~ 50-100 kbps
  "evdo_0": ConnectionSubtype.evdo_0, // ~ 400-1000 kbps
  "evdo_a": ConnectionSubtype.evdo_a, // ~ 600-1400 kbps
  "gprs": ConnectionSubtype.gprs, // ~ 100 kbps
  "hsdpa": ConnectionSubtype.hsdpa, // ~ 2-14 Mbps
  "hspa": ConnectionSubtype.hspa, // ~ 700-1700 kbps
  "hsupa": ConnectionSubtype.hsupa, // ~ 1-23 Mbps
  "umts": ConnectionSubtype.umts, // ~ 400-7000 kbps
  "ehrpd": ConnectionSubtype.ehrpd, // ~ 1-2 Mbps
  "evdo_b": ConnectionSubtype.evdo_b, // ~ 5 Mbps
  "hspap": ConnectionSubtype.hspap, // ~ 10-20 Mbps
  "iden": ConnectionSubtype.iden, // ~25 kbps
  "lte": ConnectionSubtype.lte, // ~ 10+ Mbps
  "unknown": ConnectionSubtype.unknown, // is connected but cannot tell the speed
  "none": ConnectionSubtype.none
};

/// The status of the location service authorization.
enum LocationAuthorizationStatus {
  /// The authorization of the location service is not determined.
  notDetermined,

  /// This app is not authorized to use location.
  restricted,

  /// User explicitly denied the location service.
  denied,

  /// User authorized the app to access the location at any time.
  authorizedAlways,

  /// User authorized the app to access the location when the app is visible to them.
  authorizedWhenInUse,

  /// Status unknown.
  unknown
}
