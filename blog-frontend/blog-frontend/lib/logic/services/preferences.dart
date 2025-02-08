import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> saveUser(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("password", password);
  }

  static Future<Map<String, dynamic>> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");
    return {
      "email": email,
      "password": password,
    };
  }

  //add and remove the favourites
  static Future<bool> addFavorite(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> favorites = sharedPreferences.getStringList("favorites") ?? [];
    favorites.add(id);

    return await sharedPreferences.setStringList("favorites", favorites);
  }

  static Future<bool> removeFavorite(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> favorites = sharedPreferences.getStringList("favorites") ?? [];
    favorites.remove(id);

    return await sharedPreferences.setStringList("favorites", favorites);
  }

  static Future<List<String>> fetchFavorites() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList("favorites") ?? [];
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // prefs.containsKey("email");
    // prefs.containsKey("password");
  }
}
