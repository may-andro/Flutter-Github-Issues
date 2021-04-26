import 'package:flutter/material.dart';

class BaseSliverHeader extends StatelessWidget {
  final Widget bodyWidget;
  final Widget headerWidget;
  final double headerHeight;

  const BaseSliverHeader({@required this.bodyWidget, @required this.headerWidget, @required this.headerHeight});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: bodyWidget,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              expandedHeight: headerHeight,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              floating: false,
              iconTheme: const IconThemeData(color: Colors.black),
              pinned: false,
              brightness: Brightness.dark,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.pin, background: headerWidget)),
        ];
      },
    );
  }
}
