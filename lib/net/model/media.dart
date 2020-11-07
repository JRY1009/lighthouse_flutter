
import 'package:lighthouse/utils/object_util.dart';

class Media {
  int id;
  String image_url;
  String compress_image;
  String play_url;
  int media_type;
  int media_status = 1;   //0审核中，1审核通过

  String created_at;
  String photo_hue;

  int width;
  int height;
  int photo_code;

  Media({
    this.id,
    this.image_url,
    this.compress_image,
    this.play_url,
    this.media_type,
    this.media_status,
    this.created_at,
    this.photo_hue,
    this.width,
    this.height,
    this.photo_code,
  });

  Media.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    image_url = jsonMap['image_url'];
    compress_image = jsonMap['compress_image'];
    play_url = jsonMap['play_url'];
    media_type = jsonMap['media_type'];
    media_status = jsonMap['media_status'];
    created_at = jsonMap['created_at'];
    photo_hue = jsonMap['photo_hue'];
    width = jsonMap['width'];
    height = jsonMap['height'];
    photo_code = jsonMap['photo_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap['id'] = this.id;
    jsonMap['image_url'] = this.image_url;
    jsonMap['compress_image'] = this.compress_image;
    jsonMap['play_url'] = this.play_url;
    jsonMap['media_type'] = this.media_type;
    jsonMap['media_status'] = this.media_status;
    jsonMap['created_at'] = this.created_at;
    jsonMap['photo_hue'] = this.photo_hue;
    jsonMap['width'] = this.width;
    jsonMap['height'] = this.height;
    jsonMap['photo_code'] = this.photo_code;

    return jsonMap;
  }

  static List<Media> fromJsonList(List<dynamic> mapList) {
    if (ObjectUtil.isEmptyList(mapList)) {
      return null;
    }

    List<Media> medias = new List<Media>();
    for(Map<String, dynamic> map in mapList) {
      medias.add(Media.fromJson(map));
    }
    return medias;
  }
}
