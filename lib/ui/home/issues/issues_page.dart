import 'package:flutter/material.dart';
import 'package:flutter_github/redux/app_actions.dart';
import 'package:flutter_github/ui/widget/dialog_content.dart';
import 'package:flutter_github/utils/theme/theme_list.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:flutter_github/locator.dart';
import 'package:flutter_github/redux/app_state.dart';
import 'package:flutter_github/ui/home/issues/bloc/bloc_provider.dart';
import 'package:flutter_github/ui/home/issues/bloc/issues_bloc.dart';
import 'package:flutter_github/ui/home/issues_detail/issues_detail_page.dart';
import 'package:flutter_github/ui/widget/base_sliver_header.dart';
import 'package:flutter_github/ui/widget/title_bar.dart';
import 'package:flutter_github/utils/text/text_constant.dart';

class IssuesPage extends StatefulWidget {
  @override
  _IssuesPageState createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> with TickerProviderStateMixin {
  IssuesBloc _bloc;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    animationController.forward();
    _bloc = getIt<IssuesBloc>();
    _bloc.issueTypeStream.listen(_refreshList);
    _bloc.issueTypeSink.add(false);
  }

  @override
  void dispose() {
    animationController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  Future _refreshList(bool isOpen) async {
    _bloc.fetchAllIssues(isOpen);
  }

  _updateTheme() {
    ThemeData currentTheme = StoreProvider.of<AppState>(context).state.themeData;
    int index = themeList.indexOf(currentTheme);
    ThemeData newTheme = index == 0 ? themeList[1] : themeList[0];
    StoreProvider.of<AppState>(context).dispatch(ChangeThemeAction(themeData: newTheme));
  }

  @override
  Widget build(BuildContext context) {
    return IssuesBlocProvider(
      bloc: _bloc,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _updateTheme();
            },
            child: Icon(
              Icons.color_lens_rounded,
              color: Colors.white,
              size: 29,
            ),
            backgroundColor: Theme.of(context).primaryColorDark,
            tooltip: 'Theme',
            elevation: 5,
            splashColor: Theme.of(context).accentColor,
          ),
          body: BaseSliverHeader(
            headerHeight: MediaQuery.of(context).size.height * 0.1,
            headerWidget: TitleBar(
              label: ISSUE_TITLE,
              rightIconData: Icons.filter_alt,
              rightIconDataClick: () {
                _showFilterDialog();
              },
            ),
            bodyWidget: _buildBody(),
          ),
        ),
      ),
    );
  }

  _buildBody() {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: _buildUIState(),
            ),
          );
        });
  }

  _buildUIState() {
    return StreamBuilder(
      stream: _bloc.allIssuesStream,
      builder: (context, AsyncSnapshot<List<IssueItem>> snapshot) {
        if (snapshot.hasData) {
          return _buildSuccessState(snapshot);
        } else if (snapshot.hasError) {
          return _buildErrorState(snapshot);
        }
        return _buildLoadingState();
      },
    );
  }

  _buildLoadingState() {
    return Center(child: CircularProgressIndicator());
  }

  _buildSuccessState(AsyncSnapshot<List<IssueItem>> snapshot) {
    return Stack(fit: StackFit.expand, children: <Widget>[_buildTimeline(), _buildIssueList(snapshot)]);
  }

  _buildTimeline() {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 40.0,
      child: Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  _buildIssueList(AsyncSnapshot<List<IssueItem>> snapshot) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return _CardItem(issueItem: snapshot.data[index]);
          }),
    );
  }

  _buildErrorState(AsyncSnapshot<List<IssueItem>> snapshot) {
    return Center(child: Text(snapshot.error.toString()));
  }

  _buildFilterOptions() {
    return StreamBuilder<bool>(
        stream: _bloc.issueTypeStream,
        builder: (context, snapshot) {
          bool filterType = snapshot.hasData ? snapshot.data : true;
          return _FilterList(
            isOpen: filterType,
            doOnSelection: (bool) {
              _bloc.issueTypeSink.add(bool);
              Navigator.of(context).pop();
            },
          );
        });
  }

  Future<bool> _showFilterDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: DialogContent(
              title: "Filter Issues",
              child: _buildFilterOptions(),
              positiveText: "",
              negativeText: "",
            ),
          );
        });
  }
}

class _FilterList extends StatelessWidget {
  final bool isOpen;
  final ValueChanged<bool> doOnSelection;

  _FilterList({@required this.isOpen, @required this.doOnSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<bool>(
          title: const Text('Open Issue'),
          value: true,
          groupValue: isOpen,
          onChanged: (value) => doOnSelection(value),
        ),
        RadioListTile<bool>(
          title: const Text('Closed Issue'),
          value: false,
          groupValue: isOpen,
          onChanged: (value) => doOnSelection(value),
        ),
      ],
    );
  }
}

class _CardItem extends StatelessWidget {
  final double dotSize = 12.0;
  final IssueItem issueItem;

  _CardItem({@required this.issueItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssuesDetailPage(issueItem: issueItem),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDot(MediaQuery.of(context).size.shortestSide, Theme.of(context).primaryColor),
          _buildData(MediaQuery.of(context).size.shortestSide)
        ],
      ),
    );
  }

  _buildData(double size) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            issueItem.title,
            style: TextStyle(fontSize: size * 0.04),
          ),
          SizedBox(height: 4),
          Text(
            issueItem.createdAt,
            style: TextStyle(fontSize: size * 0.03, color: Colors.grey),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  _buildDot(double size, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 8),
      child: Container(
        height: dotSize,
        width: dotSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
