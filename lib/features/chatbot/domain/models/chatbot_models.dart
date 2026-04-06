

class ChatBotActionExecutionResult {
  final String reply;
  final Map<String, dynamic>? data;

  const ChatBotActionExecutionResult({
    required this.reply,
    this.data,
  });
}

class ActionIntentData {
  final Map<String, dynamic>? _data;

  ActionIntentData(this._data);

  Map<String, dynamic>? get raw => _data;

  int? safeInt(String key) {
    if (_data == null || !_data.containsKey(key)) return null;
    final val = _data[key];
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    if (val is double) return val.toInt();
    return null;
  }

  String? safeString(String key) {
    if (_data == null || !_data.containsKey(key)) return null;
    final val = _data[key];
    return val?.toString();
  }

  bool? safeBool(String key) {
    if (_data == null || !_data.containsKey(key)) return null;
    final val = _data[key];
    if (val is bool) return val;
    if (val is String) {
      if (val.toLowerCase() == 'true') return true;
      if (val.toLowerCase() == 'false') return false;
    }
    return null;
  }
}
