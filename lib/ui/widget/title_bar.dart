import 'package:flutter/material.dart';
import 'package:flutter_github/utils/theme/color_utility.dart';

class TitleBar extends StatelessWidget {
  final String label;
  final String titleColor;

  final IconData leftIconData;
  final Function leftIconDataClick;

  final IconData rightIconData;
  final Function rightIconDataClick;

  TitleBar({
    @required this.label,
    this.titleColor,
    this.leftIconData,
    this.leftIconDataClick,
    this.rightIconData,
    this.rightIconDataClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: leftIconData != null,
            child: IconButton(
              icon: Icon(
                leftIconData,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: leftIconDataClick != null ? leftIconDataClick : () => Navigator.pop(context),
              color: Color(getColorHexFromStr(titleColor != null ? titleColor : BLACK)),
            ),
          ),
          Visibility(
            visible: leftIconData != null,
            child: SizedBox(
              width: 24,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.shortestSide * 0.07,
              color: titleColor != null ? Color(getColorHexFromStr(titleColor)) : Theme.of(context).primaryColorDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          Spacer(
            flex: 1,
          ),
          Visibility(
            visible: rightIconData != null,
            child: SizedBox(
              width: 24,
            ),
          ),
          Visibility(
            visible: rightIconData != null,
            child: IconButton(
              icon: Icon(
                rightIconData,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: rightIconDataClick != null ? rightIconDataClick : () => Navigator.pop(context),
              color: Color(getColorHexFromStr(titleColor != null ? titleColor : BLACK)),
            ),
          ),
        ],
      ),
    );
  }
}
