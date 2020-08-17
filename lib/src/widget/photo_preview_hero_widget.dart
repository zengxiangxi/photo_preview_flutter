import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

typedef UniqueTagBuilder = void Function(Object uniqueTag);

///hero封装
// ignore: must_be_immutable
class PhotoPreviewHeroWidget extends StatelessWidget {
  final Widget child;
  final Object tag;
  final bool isUserHero;
  final bool transitionOnUserGestures;
  final bool isShowPlaceHolderBuilder;
  final bool isCreateUniqueTag; //优先tag tag为空才生效
  final UniqueTagBuilder uniqueTagCallBack;
  final UniqueTagBuilder onClickForTag;
  Object _uniqueTag;

  PhotoPreviewHeroWidget(
      {Key key,
      this.tag,
      this.isUserHero = true,
      @required this.child,
      this.transitionOnUserGestures = true,
      this.isShowPlaceHolderBuilder = true,
      this.isCreateUniqueTag = false,
      this.uniqueTagCallBack, this.onClickForTag})
      : assert(child != null),
        super(key: key) {
    if (tag == null && isCreateUniqueTag == true) {
      _uniqueTag = Uuid().v1();
      if (uniqueTagCallBack != null) {
        uniqueTagCallBack(_uniqueTag);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: onClickForTag== null ? true: false,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
         if(onClickForTag != null){
           onClickForTag(tag ?? _uniqueTag);
         }
        },
        child: isUserHero == null || isUserHero == false || (isUserHero == true && tag == null && isCreateUniqueTag != true)
            ? child ?? Container()
            : Hero(
                tag: tag ?? _uniqueTag,
                child: child ?? Container(),
                transitionOnUserGestures: transitionOnUserGestures ?? true,
                flightShuttleBuilder: (BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext) {
                  return Material(
                      type: MaterialType.transparency,
                      child: toHeroContext?.widget ?? Container());
                },
                placeholderBuilder: isShowPlaceHolderBuilder == null ||
                        isShowPlaceHolderBuilder == false
                    ? null
                    : (BuildContext ctx, Size size, Widget result) {
                        return result;
                      },
              ),
      ),
    );
  }
}
