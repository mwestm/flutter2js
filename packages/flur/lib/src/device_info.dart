import 'package:flur/js.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as flutter;

enum PlatformType {
  flutter,
  browser,
  reactNative,
  other,
}

enum OperatingSystemType {
  ios,
  android,
  osx,
  windows,
  fuchsia,
  other,
}

const bool isRunningInFlur = !(const bool.fromEnvironment("dart.ui"));

class DeviceInfo {
  /// By default, obtains device information from Flutter APIs.
  static DeviceInfo current = new DeviceInfo.fromSystem();

  /// Platform (browser, React Native, etc.).
  /// Usually known at compile time.
  /// Must be non-null.
  final PlatformType platformType;

  /// Operating system of the device.
  /// May be null.
  final OperatingSystemType operatingSystemType;

  /// Browser user agent.
  /// May be null.
  final String userAgent;

  DeviceInfo({this.platformType, this.userAgent, this.operatingSystemType});

  factory DeviceInfo.fromSystem() {
    if (JsValue.global != null) {
      // Running in browser.
      return new DeviceInfo.fromBrowser();
    }
    if (isRunningInFlur) {
      // Running in Flur, but not in browser.
      // This can happen in tests.
      return new DeviceInfo(
        platformType: PlatformType.browser,
        operatingSystemType: OperatingSystemType.android,
      );
    }

    // Otherwise running in Flutter engine
    return new DeviceInfo(
        platformType: PlatformType.flutter,
        operatingSystemType: _getOperatingSystemTypeFromFlutter());
  }

  factory DeviceInfo.fromBrowser(
      {String userAgent, OperatingSystemType osType}) {
    if (userAgent == null) {
      userAgent = _getUserAgent();
    }
    return new DeviceInfo(
        platformType: PlatformType.browser,
        userAgent: userAgent,
        operatingSystemType:
            osType ?? getOperatingSystemTypeFromUserAgent(userAgent));
  }

  /// Flur can be used to build Desktop apps too!
  /// This method allows you to check whether the device looks like mobile.
  bool get isMobile {
    if (platformType == PlatformType.flutter) return true;
    switch (operatingSystemType) {
      case OperatingSystemType.android:
        return true;
      case OperatingSystemType.ios:
        return true;
      default:
        switch (platformType) {
          case PlatformType.flutter:
            return true;
          case PlatformType.reactNative:
            return true;
          case PlatformType.browser:
            var ua = this.userAgent;
            if (ua != null) {
              ua = ua.toLowerCase();
              if (ua.contains(" mobile safari")) return true;
              if (ua.contains("; mobile;")) return true;
              if (ua.contains(" iphone ")) return true;
            }
            return false;
          default:
            return false;
        }
    }
  }

  /// Obtains operating system type from Flutter.
  static OperatingSystemType _getOperatingSystemTypeFromFlutter() {
    switch (defaultTargetPlatform) {
      case flutter.TargetPlatform.android:
        return OperatingSystemType.android;
      case flutter.TargetPlatform.iOS:
        return OperatingSystemType.ios;
      case flutter.TargetPlatform.fuchsia:
        return OperatingSystemType.fuchsia;
      default:
        return OperatingSystemType.other;
    }
  }

  /// Attempts to determine operating system type by parsing user agent.
  static OperatingSystemType getOperatingSystemTypeFromUserAgent(String ua) {
    if (ua == null) {
      return null;
    }
    ua = ua.toLowerCase();
    if (ua.contains("android")) {
      return OperatingSystemType.android;
    }
    if (ua.contains(" iphone ")) {
      return OperatingSystemType.ios;
    }
    return OperatingSystemType.other;
  }

  static String _getUserAgent() {
    return (JsValue.global?.get("navigator")?.get("userAgent")?.asDartObject()
        as String);
  }
}
