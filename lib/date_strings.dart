///
///Author: YoungChan
///Date: 2019-07-07 23:42:08
///LastEditors: YoungChan
///LastEditTime: 2019-07-08 01:04:03
///Description: file content
///
import 'package:flutter/material.dart';

class DateLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'today': 'Today',
      'sun': 'Sun',
      'mon': 'Mon',
      'tue': 'Tur',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
    },
    'zh': {
      'today': '今天',
      'sun': '日',
      'mon': '一',
      'tue': '二',
      'wed': '三',
      'thu': '四',
      'fri': '五',
      'sat': '六',
    }
  };

  static DateLocalizations of(BuildContext context) {
    return DateLocalizations(Localizations.localeOf(context));
  }

  DateLocalizations(this.locale);

  final Locale locale;

  String get today {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['today'];
  }

  String get sunday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['sun'];
  }

  String get monday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['mon'];
  }

  String get tuesday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['tue'];
  }

  String get wednesday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['wed'];
  }

  String get thursday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['thu'];
  }

  String get friday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['fri'];
  }

  String get saturday {
    var code = locale.languageCode;
    if (_localizedValues[code] == null) {
      code = 'zh';
    }
    return _localizedValues[code]['sat'];
  }
}
