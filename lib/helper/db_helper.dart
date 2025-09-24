import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/main.dart';

class DbHelper{
  static insertOrUpdate({required String id, required CacheResponseCompanion data}) async {
    final response = await database.getCacheResponseById(id);

    if(response?.endPoint != null){
      await database.updateCacheResponse(id, data);
    }else{
      await database.insertCacheResponse(data);
    }
  }


}