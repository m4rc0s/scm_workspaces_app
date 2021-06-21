import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:scm_workspaces_app/core/repo.dart';

class WorkspaceModel extends ChangeNotifier {
  final List<Repo> _repos = [];

  UnmodifiableListView<Repo> get repos => UnmodifiableListView(_repos);

  void add(Repo item) {
    _repos.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeAll() {
    _repos.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
