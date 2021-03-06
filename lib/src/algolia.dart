part of algolia;

class Algolia {
  const Algolia.init({
    required String applicationId,
    required String apiKey,
    this.extraHeaders = const {},
  })  : applicationId = applicationId,
        _apiKey = apiKey;

  const Algolia._({
    required String applicationId,
    required String apiKey,
    this.extraHeaders = const {},
  })  : applicationId = applicationId,
        _apiKey = apiKey;

  final String applicationId;
  final String _apiKey;
  final Map<String, String> extraHeaders;

  Algolia get instance => Algolia._(
        applicationId: applicationId,
        apiKey: _apiKey,
        extraHeaders: _header,
      );

  String get _host => 'https://$applicationId-dsn.algolia.net/1/';

  Map<String, String> get _header {
    Map<String, String> map = {
      'X-Algolia-Application-Id': applicationId,
      'X-Algolia-API-Key': _apiKey,
      'Content-Type': 'application/json',
    };
    map.addEntries(extraHeaders.entries);
    return map;
  }

  Algolia setHeader(String key, String value) {
    Map<String, String> map = extraHeaders;
    map[key] = value;
    return Algolia._(
      applicationId: applicationId,
      apiKey: _apiKey,
      extraHeaders: _header,
    );
  }

  AlgoliaIndexReference index(String index) {
    return AlgoliaIndexReference._(this, index);
  }

  AlgoliaMultiIndexesReference get multipleQueries =>
      AlgoliaMultiIndexesReference._(this);

  Future<AlgoliaIndexesSnapshot> getIndices() async {
    String _url = '${_host}indexes';
    Response response = await get(
      Uri.parse(_url),
      headers: _header,
    );
    Map<String, dynamic> body = json.decode(response.body);

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw AlgoliaError._(body, response.statusCode);
    }

    return AlgoliaIndexesSnapshot._(this, body);
  }
}
