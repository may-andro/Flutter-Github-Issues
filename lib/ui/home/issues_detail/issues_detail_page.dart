import 'package:flutter/material.dart';
import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:flutter_github/ui/widget/base_sliver_header.dart';
import 'package:flutter_github/ui/widget/title_bar.dart';
import 'package:flutter_github/utils/text/text_constant.dart';

class IssuesDetailPage extends StatelessWidget {
  final IssueItem issueItem;

  IssuesDetailPage({Key key, @required this.issueItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BaseSliverHeader(
          headerHeight: MediaQuery.of(context).size.height * 0.1,
          headerWidget: TitleBar(
            label: ISSUE_TITLE,
            leftIconData: Icons.arrow_back_outlined,
          ),
          bodyWidget: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: _buildUIState(),
    );
  }

  Widget _buildUIState() {
    return _buildSuccessState();
  }

  Widget _buildSuccessState() {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: ListView(children: [
          _CardItem(
            label: "Title",
            value: issueItem.title,
          ),
          _CardItem(
            label: "Number",
            value: "${issueItem.number}",
          ),
          _CardItem(
            label: "Author",
            value: issueItem.user.login,
          ),
          _CardItem(
            label: "Url",
            value: issueItem.url,
          ),
          _CardItem(
            label: "Created data",
            value: "${issueItem.createdAt}",
          ),
          _CardItem(
            label: "Closed date",
            value: "${issueItem.closedAt}",
          ),
        ]));
  }
}

class _CardItem extends StatelessWidget {
  final double dotSize = 12.0;
  final String label;
  final String value;

  _CardItem({@required this.label, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.03, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
