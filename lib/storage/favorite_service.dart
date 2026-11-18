import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/show_model.dart';

class FavoriteService {
  static Box get _box => Hive.box('favorites');

  static ValueListenable<Box> listenable() => _box.listenable();

  static bool isFavorite(int showId) => _box.containsKey(showId);

  static Future<void> toggle(ShowModel show) async {
    if (isFavorite(show.id)) {
      await _box.delete(show.id);
    } else {
      await _box.put(show.id, show.toMap());
    }
  }

  static List<ShowModel> getAll() {
    return _box.values
        .whereType<Map>()
        .map((item) => ShowModel.fromStored(item))
        .toList();
  }
}
