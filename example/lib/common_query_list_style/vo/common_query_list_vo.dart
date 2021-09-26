import 'common_query_extra_vo.dart';

/// picurl : "图片路径"
/// spicurl : "缩略图"
/// id : "唯一id"
/// data : "extra数据（json串）"

class CommonQueryListVo {
  String? picurl;
  String? spicurl;
  String? id;
  CommonQueryExtraVo? data;


  CommonQueryListVo({this.picurl, this.spicurl, this.id, this.data});

  static CommonQueryListVo fromMap(Map<String, dynamic> map) {
    CommonQueryListVo commonQueryListVoBean = CommonQueryListVo();
    commonQueryListVoBean.picurl = map['picurl'];
    commonQueryListVoBean.spicurl = map['spicurl'];
    commonQueryListVoBean.id = map['id'];
    commonQueryListVoBean.data = CommonQueryExtraVo.fromMap(map['data']);
    return commonQueryListVoBean;
  }

  Map toJson() => {
    "picurl": picurl,
    "spicurl": spicurl,
    "id": id,
    "data": data,
  };
}