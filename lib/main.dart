import 'package:flutter/material.dart';
import 'package:majoo_pretest/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pretest API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _api = Api();
  bool _isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _api.getHttpId(_controller.text);
              setState(() {
                _isSearch = false;
                _controller.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _api.getHttpId(_controller.text);
                    setState(() {
                      _isSearch = true;
                    });
                  },
                ),
              ],
            ),
          ),
          _isSearch
              ? Expanded(
                  child: FutureBuilder<Map>(
                    future: _api.getHttpId(_controller.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          title: Text(snapshot.data!['title']),
                          subtitle: Text(snapshot.data!['body']),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              : Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _api.getHttp(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(snapshot.data![index]['title']),
                              subtitle: Text(snapshot.data![index]['body']),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
