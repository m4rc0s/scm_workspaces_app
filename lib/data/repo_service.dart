import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scm_workspaces_app/core/repo.dart';

class RepoService {

  Future<List<Repo>> findAll() async {
    final res = await http.get(
        Uri.http(
            'localhost:8080',
            '/repos')
    );

    Iterable resultList = json.decode(res.body);

    List<Repo> repos = List<Repo>.from(resultList.map((model) => Repo.fromJson(model)));

    if (res.statusCode == 200) return repos;

    throw Exception('Failed to load Repos');
  }

}