part of "./gif.dart";

class GifCacheManager {
  static final GifCacheManager _singleton = GifCacheManager._internal();

  factory GifCacheManager() {
    return _singleton;
  }

  GifCacheManager._internal();

  final Map<String, GifInfo> _caches = {};

  /// Clears all the stored gifs from the cache.
  void clear() => _caches.clear();

  /// Removes single gif from the cache.
  bool removeCachedGif(String key) =>
      _caches.remove(key) != null ? true : false;

  // Get gif by path
  GifInfo? getGifByPath(String gif) => _caches[gif];

  /// Add gif to cache
  /// [image] - gif provider to cache
  /// [clearTimeout] - afterTimeout remove gif from cache to avoid ram usage
  /// if [clearTimeout] is null - not call clear func.
  Future<void> addGifToCache(ImageProvider<Object> image,
      {Duration? clearTimeout}) async {
    final path = _getImageKey(image);
    if (_caches.containsKey(path)) {
      return;
    }
    final frames = await _fetchFrames(image);

    _caches.putIfAbsent(_getImageKey(image), () => frames);

    if (clearTimeout != null) {
      Future.delayed(clearTimeout, () {
        removeCachedGif(path);
      });
    }
  }
}

/// Get unique image string from [ImageProvider]
String _getImageKey(ImageProvider provider) {
  return provider is NetworkImage
      ? provider.url
      : provider is AssetImage
          ? provider.assetName
          : provider is FileImage
              ? provider.file.path
              : provider is MemoryImage
                  ? provider.bytes.toString()
                  : "";
}

/// Fetches the single gif frames and saves them into the [GifCache] of [Gif]
Future<GifInfo> _fetchFrames(ImageProvider provider) async {
  late final Uint8List bytes;

  if (provider is NetworkImage) {
    final Uri resolved = Uri.base.resolve(provider.url);
    final Response response = await _httpClient.get(
      resolved,
      headers: provider.headers,
    );
    bytes = response.bodyBytes;
  } else if (provider is AssetImage) {
    AssetBundleImageKey key =
        await provider.obtainKey(const ImageConfiguration());
    bytes = (await key.bundle.load(key.name)).buffer.asUint8List();
  } else if (provider is FileImage) {
    bytes = await provider.file.readAsBytes();
  } else if (provider is MemoryImage) {
    bytes = provider.bytes;
  }

  final buffer = await ImmutableBuffer.fromUint8List(bytes);
  Codec codec = await PaintingBinding.instance.instantiateImageCodecWithSize(
    buffer,
  );
  List<ImageInfo> infos = [];
  Duration duration = Duration();

  for (int i = 0; i < codec.frameCount; i++) {
    FrameInfo frameInfo = await codec.getNextFrame();
    infos.add(ImageInfo(image: frameInfo.image));
    duration += frameInfo.duration;
  }

  return GifInfo(frames: infos, duration: duration);
}
