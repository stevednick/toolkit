// class AssetManager {
//   final FlameGame game;
//   final Map<String, Sprite> _spriteCache = {};

//   AssetManager(this.game);

//   Future<void> preloadAssets(List<String> imagePaths) async {
//     await game.images.loadAll(imagePaths);
//     for (var path in imagePaths) {
//       _spriteCache[path] = game.images.fromCache(path);
//     }
//   }

//   Sprite getSprite(String imagePath) {
//     return _spriteCache[imagePath]!;
//   }
// }