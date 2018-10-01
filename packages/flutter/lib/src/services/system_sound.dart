// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter2js/flutter_internals.dart' as flutter2js;

/// A sound provided by the system.
enum SystemSoundType {
  /// A short indication that a button was pressed.
  click,
}

/// Provides access to the library of short system specific sounds for common
/// tasks.
class SystemSound {
  SystemSound._();

  /// Play the specified system sound. If that sound is not present on the
  /// system, the call is ignored.
  static Future<Null> play(SystemSoundType type) async {
    return flutter2js.PlatformPlugin.current.playSystemSound(type);
  }
}