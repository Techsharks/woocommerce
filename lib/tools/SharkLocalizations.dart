import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class SharkLocalizations {
  SharkLocalizations(this.locale);

  final Locale locale;

  static SharkLocalizations of(BuildContext context) {
    return Localizations.of<SharkLocalizations>(context, SharkLocalizations);
  }
  
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'برنامه خبری',
      'app_name': 'برنامه خبری',
      'search': 'جستجو...',
      'exit_app_message': 'برای خروج دوباره بزنید',
      'about': 'درباره',
      'settings': 'تنظیمات',
      'on_refreshed': 'بروز رسانی شد',
      'no_more_data': 'داده دیگری وجود ندارد',
      'unsuccess_refresh': 'ناموفق',
      'loading_failed_internet_connection_or_server_error': 'ناموفق خطا در اتصال با انترنت',
      'empty_favorite_list': 'لیست مطالب خالی می‌باشد',
      'empty_gallery':'گالری خالی ',
      'check_out_our_website': 'مطالب در وب سایت',
      'related_post':'مطالب مشابه',
      'nothing_found':'چیزی یافت نشد',
      'home_tab_title':'خانه'
    },
    'es': {
      'title': 'Hola Mundo',
      'app_name': 'Whats APp!',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String getString(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}

class SharkLocalizationsDelegate extends LocalizationsDelegate<SharkLocalizations> {
  const SharkLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<SharkLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of SharkLocalizations.
    return SynchronousFuture<SharkLocalizations>(SharkLocalizations(locale));
  }

  @override
  bool shouldReload(SharkLocalizationsDelegate old) => true;
}
