class Env {
  static const Map<String, String> _Keys = {
    "API_Key": String.fromEnvironment("API_Key"),
    "LocalHost": String.fromEnvironment("LocalHost")
  };

  static String _getKey(String Key) {
    final value = _Keys[Key] ?? '';
    if (value.isEmpty) {
      throw Exception("$Key não está no arquivo local Env ");
    }
    return value;
  }

  static String get apiKey => _getKey("API_Key");
  static String get localHost => _getKey("LocalHost");
}
