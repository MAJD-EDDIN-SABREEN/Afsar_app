import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
class SetLocalization{
  final Locale locale;
  SetLocalization(this.locale);
  static SetLocalization of(BuildContext context) {
    return Localizations.of<SetLocalization>(context, SetLocalization);
  }
  static const LocalizationsDelegate<SetLocalization>localizationsDelegate=_GetLocalizationDelegate();
  Map <String,String> _localizedValue;
  Future load() async{
    String jsonStringValue=await rootBundle.loadString('language/${locale.languageCode}.json');
    Map <String,dynamic> mappedJson=json.decode(jsonStringValue);
    _localizedValue=mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }
  String getTranslateValue(String key){
    return _localizedValue[key];
  }

}
class _GetLocalizationDelegate extends LocalizationsDelegate<SetLocalization>{
  const _GetLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en','ar'].contains(locale.languageCode);
  }

  @override
  Future<SetLocalization> load(Locale locale) async {
    SetLocalization localization =new SetLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<SetLocalization> old) {
    return false;
  }

}
