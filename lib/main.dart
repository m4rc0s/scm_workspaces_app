import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:scm_workspaces_app/core/dashboard_model.dart';
import 'package:scm_workspaces_app/core/repo.dart';
import 'package:scm_workspaces_app/core/workspace.dart';
import 'package:scm_workspaces_app/data/repo_service.dart';
import 'core/sse.dart';

void main() {

  var myStream = Sse.connect(
    uri: Uri.parse('http://localhost:3333/scm-events'),
    closeOnError: true,
    withCredentials: false,
  ).stream;

  myStream.listen((event) {
    print('Received:' + DateTime.now().millisecondsSinceEpoch.toString() + ' : ' + event.toString());
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => DashboardModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCM Workspace',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: MaterialColor(0xFF000000, {
          50:Color.fromRGBO(136,14,79, .1),
          100:Color.fromRGBO(136,14,79, .2),
          200:Color.fromRGBO(136,14,79, .3),
          300:Color.fromRGBO(136,14,79, .4),
          400:Color.fromRGBO(136,14,79, .5),
          500:Color.fromRGBO(136,14,79, .6),
          600:Color.fromRGBO(136,14,79, .7),
          700:Color.fromRGBO(136,14,79, .8),
          800:Color.fromRGBO(136,14,79, .9),
          900:Color.fromRGBO(136,14,79, 1),
        }),
      ),
      home: MyHomePage(title: 'SCM Workspace'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Workspace> futureWorkspace;
  late Future<List<Repo>> futureRepos;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    var dashboard = context.read<DashboardModel>();

    futureWorkspace = findWorkspace();
    futureWorkspace.then((value) => dashboard.add(value));

    futureRepos = RepoService().findAll();
    futureRepos.then((value) => dashboard.addRepos(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.green.withOpacity(0.8)),),
      ),
      body: Container(
        color: Colors.black87,
          child: Consumer<DashboardModel>(builder: (context, dashboard, child) {
            final cardStruct = (Repo e) => Card(color: Colors.black38,child:
            Column(
                children: [
                  Expanded(child: ListTile(
                      leading: Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.green.withOpacity(0.8),),
                      title: Text(e.name, style: TextStyle(color: Colors.green.withOpacity(0.8))),
                      subtitle: Text(
                          e.owner,
                          style: TextStyle(color: Colors.green.withOpacity(0.8)))
                  ), flex: 1),
                  Container(
                      padding:EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child:
                            Column(children: [
                              IconButton(onPressed: () => {}, icon: Icon(
                                Icons.done_all_sharp,
                                color: Colors.green.withOpacity(0.4),
                                size: 24.0,
                                semanticLabel: 'Text to announce in accessibility modes',
                              )),
                              Text("Review Requested", style: TextStyle(fontSize: 12  , color: Colors.green.withOpacity(0.4))),
                            ]))
                          ],
                        )
                      ],)
                  )
                ]
            ));
        List<Widget> reps = dashboard.repos.map((e) =>
          new Card(
              color: Colors.black87,
              child: cardStruct(e)
          )
        ).toList();

        return GridView.count(
            primary: false,
            padding: EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: reps);
      })),
      floatingActionButton: FloatingActionButton(
        onPressed: findWorkspace,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Workspace> findWorkspace() async {
    final res = await http.get(
        Uri.http('localhost:8080', '/workspaces/607fd007b2bfe241dd55a03c'));
    if (res.statusCode == 200) return Workspace.fromJson(jsonDecode(res.body));

    throw Exception('Failed to load Workspace');
  }
}
