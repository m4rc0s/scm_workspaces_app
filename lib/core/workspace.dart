import 'package:scm_workspaces_app/core/repo.dart';

class Workspace {
  final String name;
  final List<dynamic> repos;

  Workspace(this.name, this.repos);

  Workspace.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        repos = json['repos'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'repos': repos,
  };
}