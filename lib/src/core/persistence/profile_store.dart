import '../models/profile_models.dart';
import 'profile_json_codec.dart';

abstract class AdvancedCustomizerProfileStore {
  Future<String?> readCommittedProfileJson();

  Future<void> writeCommittedProfileJson(String json);
}

class InMemoryAdvancedCustomizerProfileStore
    implements AdvancedCustomizerProfileStore {
  String? _raw;

  @override
  Future<String?> readCommittedProfileJson() async => _raw;

  @override
  Future<void> writeCommittedProfileJson(String json) async {
    _raw = json;
  }
}

class AdvancedCustomizerProfileStoreAdapter {
  AdvancedCustomizerProfileStoreAdapter({
    required AdvancedCustomizerProfileStore store,
    AdvancedCustomizerProfileCodec? codec,
  }) : _store = store,
       _codec = codec ?? AdvancedCustomizerProfileCodec();

  final AdvancedCustomizerProfileStore _store;
  final AdvancedCustomizerProfileCodec _codec;

  Future<AdvancedProfileParseResult?> loadProfile() async {
    final String? raw = await _store.readCommittedProfileJson();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return _codec.parse(raw);
  }

  Future<AdvancedProfileEncodeResult> saveProfile(
    AdvancedCustomizerProfile profile,
  ) async {
    final AdvancedProfileEncodeResult encoded = _codec.encode(profile);
    if (encoded.success && encoded.json != null) {
      await _store.writeCommittedProfileJson(encoded.json!);
    }
    return encoded;
  }
}
