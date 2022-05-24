import 'localization_service.dart';

enum TKeys { settings, language, common, enable_not, sign_out }

//TKeys.hello
extension TKeysExtention on TKeys {
  String get _string => toString().split('.')[1];

  String translate(context) {
    return LocalizationService.of(context).translate(_string) ?? '';
  }
}
