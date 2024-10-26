import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalStorage {

 static final LocalStorage _instance = LocalStorage._internal();

 factory LocalStorage() {
   return _instance;
 }

 LocalStorage._internal();

 late Box _userBox;

 Future<void> init() async {
  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);


  _userBox = await Hive.openBox('userBox');

 }

 Future<void> clear() async {
   await _userBox.clear();
 }


 Future<void> saveUserData(String usernameOrEmail, String password) async {
  //guardar datos del usuario
    await _userBox.put('usernameOrEmail', usernameOrEmail);
    await _userBox.put('password', password);
 }

 Future<dynamic> getUserData(String usernameOrEmail) async {
  final String password =
  _userBox.get('password', defaultValue: '') as String;

  return {
    'usernameOrEmail': usernameOrEmail,
    'password': password,
  };
 }

 String getEmailOrUsername(){
  return _userBox.get('usernameOrEmail', defaultValue: '') as String;
 }

 String getPassword(){
  return _userBox.get('password', defaultValue: '') as String;
 }  
  
 Future<void> setIsSignedIn(bool isSignedIn) async {
  await _userBox.put('isSignedin', isSignedIn);
 }
 bool getIsSignedIn(){
  return _userBox.get('isSignedin', defaultValue: false) as bool;
 }

 Future<void> deleteIsSignedIn() async {
  //borrar el estado de inicio de sesion
  await _userBox.delete('isSignedin');
 }

 Future<void> setIsLoggedIn(bool isLoggedIn) async {
  await _userBox.put('isLoggedIn', isLoggedIn);
 }
  bool getIsLoggedIn(){
    return _userBox.get('isLoggedIn', defaultValue: false) as bool;
  }

  Future<bool> getIsFirstTime() async {
    final bool isFirstTime = _userBox.get('isFirstTime', defaultValue: true) as bool;

    if (isFirstTime) {
      await _userBox.put('isFirstTime', false);
      return true;
    }
    return false;
  }

  Future<void> savePageIndex(int index) async {
    await _userBox.put('pageIndex', index);
  }

  int getPageIndex() {
    return _userBox.get('pageIndex', defaultValue: 0) as int;
  }

}