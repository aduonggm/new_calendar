import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'Helpers/Helpers.dart';
import 'PageHelpers/LiquidController.dart';
import 'PageHelpers/page.dart';
import 'PageHelpers/page_dragger.dart';
import 'PageHelpers/page_reveal.dart';
import 'Provider/iamariderprovider.dart';

final key = new GlobalKey<_LiquidSwipe>();

typedef OnPageChangeCallback = void Function(int activePageIndex);
typedef CurrentUpdateTypeCallback = void Function(UpdateType updateType);
typedef SlidePercentCallback = void Function(double slidePercentHorizontal, double slidePercetnVertical);

class LiquidSwipe extends StatefulWidget {
  final List<Widget> pages;
  final double fullTransitionValue;
  final int initialPage;
  final bool enableSlideIcon;
  final Widget slideIconWidget;
  final double positionSlideIcon;
  final bool enableLoop;
  final LiquidController liquidController;
  final WaveType waveType;
  final OnPageChangeCallback onPageChangeCallback;
  final CurrentUpdateTypeCallback currentUpdateTypeCallback;
  final SlidePercentCallback slidePercentCallback;

  const LiquidSwipe(
      {Key key,
      @required this.pages,
      this.fullTransitionValue = FULL_TARNSITION_PX,
      this.initialPage = 0,
      this.enableSlideIcon = false,
      this.slideIconWidget = const Icon(Icons.arrow_back_ios),
      this.positionSlideIcon = 0.54,
      this.enableLoop = true,
      this.liquidController,
      this.waveType = WaveType.liquidReveal,
      this.onPageChangeCallback,
      this.currentUpdateTypeCallback,
      this.slidePercentCallback})
      : assert(pages != null),
        assert(fullTransitionValue != null),
        assert(initialPage != null && initialPage >= 0 && initialPage < pages.length),
        assert(positionSlideIcon >= -1 && positionSlideIcon <= 1),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LiquidSwipe();
}

class _LiquidSwipe extends State<LiquidSwipe> with TickerProviderStateMixin {
  LiquidController liquidController;

  @override
  void initState() {
    liquidController = widget.liquidController ?? LiquidController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = widget.pages;
    return ChangeNotifierProvider<IAmARiderProvider>(
      create: (BuildContext context) {
        return IAmARiderProvider(widget.initialPage, widget.enableLoop, pages.length, this, widget.positionSlideIcon,
            widget.onPageChangeCallback, widget.currentUpdateTypeCallback, widget.slidePercentCallback);
      },
      child: Consumer(builder: (BuildContext context, IAmARiderProvider model, _) {
        liquidController.setContext(context);
        return Stack(
          children: <Widget>[
            CustomPage(
              pageView: model.slideDirection == SlideDirection.leftToRight
                  ? pages[model.activePageIndex]
                  : pages[model.nextPageIndex],
            ),
            //Pages
            PageReveal(
              //next page reveal
              revealPercent: model.slidePercentHor,
              child: CustomPage(
                pageView: model.slideDirection == SlideDirection.leftToRight
                    ? pages[model.nextPageIndex]
                    : pages[model.activePageIndex],
              ),
              slideDirection: model.slideDirection,
              iconPosition: widget.positionSlideIcon,
              waveType: widget.waveType,
              vertReveal: model.slidePercentVer,
            ),
            PageDragger(
              //Used for gesture control
              fullTransitionPX: widget.fullTransitionValue,
              enableSlideIcon: widget.enableSlideIcon,
              slideIconWidget: widget.slideIconWidget,
              iconPosition: widget.positionSlideIcon,
            ), //PageDragger
          ], //Widget//Stack
        );
      }),
    ); //Scaffold
  }
}
