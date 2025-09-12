import 'package:flutter/material.dart';
import '../language/BaseLanguage.dart';
import '../language/LanguageAr.dart';
import '../language/LanguageEn.dart';
import '../language/LanguageHi.dart';
import '../models/LanguageDataModel.dart';

import 'LanguageAf.dart';
import 'LanguageDe.dart';
import 'LanguageEs.dart';
import 'LanguageFr.dart';
import 'LanguageId.dart';
import 'LanguageNl.dart';
import 'LanguagePt.dart';
import 'LanguageTr.dart';
import 'LanguageVi.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'hi':
        return LanguageHi();
      case 'ar':
        return LanguageAr();
      case 'es':
        return LanguageEs();
      case 'af':
        return LanguageAf();
      case 'fr':
        return LanguageFr();
      case 'de':
        return LanguageDe();
      case 'id':
        return LanguageId();
      case 'pt':
        return LanguagePt();
      case 'tr':
        return LanguageTr();
      case 'vi':
        return LanguageVi();
      case 'nl':
        return LanguageNl();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
