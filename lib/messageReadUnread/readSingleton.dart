class ReadSingleton{
  static final ReadSingleton _singleton = ReadSingleton._internal();
  factory ReadSingleton() => _singleton;
  ReadSingleton._internal();

  static ReadSingleton get shared => _singleton;

  Map<String, bool> readCache = new Map();

  Map<String, bool> getReadCacheMap(){
    return readCache;
  }
}