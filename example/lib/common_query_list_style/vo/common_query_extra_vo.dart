/// extra1 : "额外数据1"
/// extra2 : "额外数据2"

class CommonQueryExtraVo {
  String? extra1;
  String? extra2;


  CommonQueryExtraVo({this.extra1, this.extra2});

  static CommonQueryExtraVo? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    CommonQueryExtraVo commonQueryExtraVoBean = CommonQueryExtraVo();
    commonQueryExtraVoBean.extra1 = map['extra1'];
    commonQueryExtraVoBean.extra2 = map['extra2'];
    return commonQueryExtraVoBean;
  }

  Map toJson() => {
    "extra1": extra1,
    "extra2": extra2,
  };
}