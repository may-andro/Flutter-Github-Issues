import 'package:flutter_github/data/remote/model/issue_item.dart';
import 'package:flutter_github/domain/usecase/GetIssuesUseCase.dart';
import 'package:rxdart/rxdart.dart';

class IssuesBloc {
  GetIssuesUseCase getIssuesUseCase;

  IssuesBloc(this.getIssuesUseCase);

  List<IssueItem> issueList;
  var selectedState;
  List<int> selectedIssueList = [];
  bool sortOrderIsLatest = true;

  // Stream for issue list
  final _issuesSubject = PublishSubject<List<IssueItem>>();

  Stream<List<IssueItem>> get allIssuesStream => _issuesSubject.stream;

  Sink<List<IssueItem>> get allIssuesSink => _issuesSubject.sink;

  // Stream for selected issue list
  final _selectedIssuesSubject = PublishSubject<List<int>>();

  Stream<List<int>> get selectedIssuesStream => _selectedIssuesSubject.stream;

  Sink<List<int>> get selectedIssuesSink => _selectedIssuesSubject.sink;

  // Stream for issue filter state
  final _issuesStateSubject = PublishSubject<bool>();

  Stream<bool> get issueStateStream => _issuesStateSubject.stream;

  Sink<bool> get issueStateSink => _issuesStateSubject.sink;

  //Helper Methods
  fetchAllIssues(bool isOpen) async {
    selectedState = isOpen;
    try {
      sortOrderIsLatest = true;
      allIssuesSink.add(null);
      List<IssueItem> issuesList = await getIssuesUseCase.execute(isOpen);
      allIssuesSink.add(issuesList);
      this.issueList = issuesList;
    } catch (error) {
      print('Caught error: $error');
      _issuesSubject.addError(error);
    }
  }

  setSelected(int issueId) {
    if (!selectedIssueList.contains(issueId)) {
      selectedIssueList.add(issueId);
      selectedIssuesSink.add(selectedIssueList);
    }
  }

  setSortOrder(bool order) {
    sortOrderIsLatest = order;
    order ? allIssuesSink.add(issueList) : allIssuesSink.add(issueList.reversed.toList());
  }

  //Cleaning Methods
  dispose() {
    _issuesSubject.close();
    _issuesStateSubject.close();
    _selectedIssuesSubject.close();
  }
}
