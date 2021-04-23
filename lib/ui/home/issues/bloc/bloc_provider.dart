import 'package:flutter/material.dart';
import 'package:flutter_github/ui/home/issues/bloc/issues_bloc.dart';

class IssuesBlocProvider extends InheritedWidget {
  final IssuesBloc bloc;

  const IssuesBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static IssuesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<IssuesBlocProvider>()).bloc;
  }
}
