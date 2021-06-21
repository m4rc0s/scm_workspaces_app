import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:scm_workspaces_app/core/workspace.dart';
import 'package:scm_workspaces_app/core/repo.dart';

class DashboardModel extends ChangeNotifier {
  final List<Workspace> _workspaces = [];
  late List<Repo> _repos = [];

  UnmodifiableListView<Workspace> get workspaces => UnmodifiableListView(_workspaces);
  UnmodifiableListView<Repo> get repos => UnmodifiableListView(_repos);

  void add(Workspace item) {
    _workspaces.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeAll() {
    _workspaces.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addRepos(List<Repo> repos) {
    _repos = repos;
    notifyListeners();
  }
}
