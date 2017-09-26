// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'i18n/stock_messages_all.dart';

// Information about how this file relates to i18n/stock_messages_all.dart and how the i18n files
// were generated can be found in i18n/regenerate.md.

class StockStrings {
  final String _localeName;

  StockStrings(Locale locale) : _localeName = locale.toString();

  String market() => Intl.message(
        'MARKET',
        name: 'market',
        desc: 'Label for the Market tab',
        locale: _localeName,
      );

  String portfolio() => Intl.message(
        'PORTFOLIO',
        name: 'portfolio',
        desc: 'Label for the Portfolio tab',
        locale: _localeName,
      );

  String title() {
    return Intl.message(
      '<Stocks>',
      name: 'title',
      desc: 'Title for the Stocks application',
      locale: _localeName,
    );
  }

  static Future<StockStrings> load(Locale locale) {
    return initializeMessages(locale.toString()).then((Null _) {
      return new StockStrings(locale);
    });
  }

  static StockStrings of(BuildContext context) {
    return Localizations.of<StockStrings>(context, StockStrings);
  }
}