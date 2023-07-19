import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_pref.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> getSharedPreferences(
    GetSharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}
