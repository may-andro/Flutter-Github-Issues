import 'package:flutter/material.dart';
import 'package:flutter_github/utils/theme/color_utility.dart';

class DialogContent extends StatelessWidget {
  final String title;
  final Widget child;
  final String positiveText;
  final String negativeText;
  final Function onPositiveCallback;
  final Function onNegativeCallBack;

  DialogContent(
      {@required this.title,
      @required this.child,
      this.positiveText,
      this.negativeText,
      this.onPositiveCallback,
      this.onNegativeCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    color: Theme.of(context).primaryColor),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: MediaQuery.of(context).size.shortestSide * 0.05),
                      )),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: child,
            ),
            Visibility(
              visible: (negativeText != null && negativeText.isNotEmpty) ||
                  (positiveText != null && positiveText.isNotEmpty),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Visibility(
                        visible: negativeText != null && negativeText.isNotEmpty,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              negativeText,
                              style: TextStyle(
                                  color: Color(getColorHexFromStr(COLOR_WARNING)),
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
                            ),
                          ),
                          onTap: onNegativeCallBack,
                        ),
                      ),
                      Visibility(
                        visible: positiveText != null && positiveText.isNotEmpty,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              positiveText,
                              style: TextStyle(
                                  color: Color(getColorHexFromStr(COLOR_GOOD)),
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
                            ),
                          ),
                          onTap: onPositiveCallback,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
