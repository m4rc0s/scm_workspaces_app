import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scm_workspaces_app/core/repo.dart';

class ReposNotifier extends StateNotifier<List<Repo>> {

  ReposNotifier(): super([]);

  void add(Repo repo) {
    state = [...state, repo];
  }

  void addRepos(List<Repo> repos) {
    state = repos;
  }

}
