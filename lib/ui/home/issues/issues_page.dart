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

class _IssuesPageState extends State<IssuesPage> {
  IssuesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<IssuesBloc>();
    _bloc.issueStateStream.listen(_refreshList);
    _bloc.issueStateSink.add(true);
  }

  @override
  void dispose() {
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
            headerWidget: _buildHeader(),
            bodyWidget: _buildBody(),
          ),
        ),
      ),
    );
  }

  //UI Setters and building Methods
  _buildHeader() {
    return StreamBuilder<List<IssueItem>>(
        stream: _bloc.allIssuesStream,
        builder: (context, snapshot) {
          return TitleBar(
            label: ISSUE_TITLE,
            rightIconData: Icons.filter_alt,
            rightIconDataClick: () {
              _showFilterDialog();
            },
            rightIconData2: _bloc.sortOrderIsLatest ? Icons.north_rounded : Icons.south_rounded,
            rightIconDataClick2: () {
              _showSortDialog();
            },
          );
        });
  }

  _buildBody() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: _buildUIState(),
      ),
    );
  }

  _buildUIState() {
    return StreamBuilder(
      stream: _bloc.allIssuesStream,
      builder: (context, AsyncSnapshot<List<IssueItem>> snapshot) {
        if (snapshot.hasData) {
          return _buildSuccessState(snapshot.data);
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

  _buildSuccessState(List<IssueItem> list) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      _buildTimeline(),
      _buildIssueList(list),
    ]);
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

  _buildIssueList(List<IssueItem> list) {
    return StreamBuilder<List<int>>(
        stream: _bloc.selectedIssuesStream,
        builder: (context, selectedListSnapshot) {
          var selectedList = selectedListSnapshot.hasData ? selectedListSnapshot.data : _bloc.selectedIssueList;
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  IssueItem item = list[index];
                  return _CardItem(issueItem: item, isSelected: selectedList.contains(item.id));
                }),
          );
        });
  }

  _buildErrorState(AsyncSnapshot<List<IssueItem>> snapshot) {
    return Center(child: Text(snapshot.error.toString()));
  }

  //Dialogs
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

  _buildFilterOptions() {
    return StreamBuilder<bool>(
        stream: _bloc.issueStateStream,
        builder: (context, snapshot) {
          bool filterType = snapshot.hasData ? snapshot.data : _bloc.selectedState;
          return _FilterList(
            isOpen: filterType,
            doOnSelection: (bool) {
              _bloc.issueStateSink.add(bool);
              Navigator.of(context).pop();
            },
          );
        });
  }

  Future<bool> _showSortDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: DialogContent(
              title: "Sort Issues",
              child: _buildSortOptions(),
              positiveText: "",
              negativeText: "",
            ),
          );
        });
  }

  _buildSortOptions() {
    return _SortList(
      isLatest: _bloc.sortOrderIsLatest,
      doOnSelection: (bool) {
        _bloc.setSortOrder(bool);
        Navigator.of(context).pop();
      },
    );
    ;
  }
}

class _SortList extends StatelessWidget {
  final bool isLatest;
  final ValueChanged<bool> doOnSelection;

  const _SortList({@required this.isLatest, @required this.doOnSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<bool>(
          title: const Text('Latest Issue First'),
          value: true,
          groupValue: isLatest,
          onChanged: (value) => doOnSelection(value),
        ),
        RadioListTile<bool>(
          title: const Text('Oldest Issue First'),
          value: false,
          groupValue: isLatest,
          onChanged: (value) => doOnSelection(value),
        ),
      ],
    );
  }
}

class _FilterList extends StatelessWidget {
  final bool isOpen;
  final ValueChanged<bool> doOnSelection;

  const _FilterList({@required this.isOpen, @required this.doOnSelection});

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
  final bool isSelected;

  _CardItem({@required this.issueItem, this.isSelected});

  _goToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IssuesDetailPage(issueItem: issueItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        IssuesBlocProvider.of(context).setSelected(issueItem.id);
        _goToNextScreen(context);
      },
      child: Container(
        color: isSelected ? Colors.grey[100] : Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildDot(MediaQuery.of(context).size.shortestSide,
                  isSelected ? Colors.grey[900] : Theme.of(context).primaryColor),
              _buildData(MediaQuery.of(context).size.shortestSide)
            ],
          ),
        ),
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
