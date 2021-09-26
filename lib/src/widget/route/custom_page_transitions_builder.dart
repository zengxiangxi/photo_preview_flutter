// Slides the page upwards and fades it in, starting from 1/4 screen
// below the top.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///自定义转场
class CustomFadePageTransitionsBuilder extends PageTransitionsBuilder {
  /// Construct a [FadeUpwardsPageTransitionsBuilder].
  const CustomFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T>? route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return _CustomFadePageTransition(routeAnimation: animation, child: child);
  }
}

class _CustomFadePageTransition extends StatelessWidget {
  _CustomFadePageTransition({
    Key? key,
    required Animation<double> routeAnimation, // The route's linear 0.0 - 1.0 animation.
    required this.child,
  }) : 
        _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  // Fractional offset from 1/4 screen below the top to fully on screen.
  static final Tween<Offset> _bottomUpTween = Tween<Offset>(
    begin: const Offset(0.0, 0.25),
    end: Offset.zero,
  );
  static final Animatable<double> _fastOutSlowInTween = CurveTween(curve: Curves.fastOutSlowIn);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: child,
    );
  }
}