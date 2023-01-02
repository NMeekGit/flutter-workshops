import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Welcome to Flutter',
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                ),
            ),
            home: const RandomWords()
        );
    }
}

class RandomWords extends StatefulWidget {
    const RandomWords({super.key});

    @override
    _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
    final _suggestions = <WordPair>[];
    final _saved = <WordPair>{};
    final _biggerFont = const TextStyle(fontSize: 18);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Startup Name Generator'),
                actions: [
                    IconButton(
                        onPressed: _pushSaved, 
                        icon: const Icon(Icons.list), 
                        tooltip: 'Saved Suggestions',
                    ),
                ],
            ),
            body: _buildSuggestions(),
        );
    }

    Widget _buildSuggestions() {
        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
                if (index.isOdd) {
                    return const Divider();
                }

                final int i = index ~/ 2;

                if (i >= _suggestions.length) {
                    _suggestions.addAll(generateWordPairs().take(10));
                }

                final alreadySaved = _saved.contains(_suggestions[i]);

                return _buildRow(_suggestions[i], alreadySaved);
            },
        );
    }

    Widget _buildRow(WordPair pair, bool alreadySaved) {
        return ListTile(
            title: Text(
                pair.asPascalCase,
                style: _biggerFont,
            ),
            trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
                setState(() {
                    if (alreadySaved) {
                        _saved.remove(pair);
                    } else {
                        _saved.add(pair);
                    }
                });
            },
        );
    }

    void _pushSaved() {
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (context) {
                    final tiles = _saved.map(
                        (pair) {
                            return ListTile(
                                title: Text(
                                    pair.asPascalCase,
                                    style: _biggerFont,
                                ),
                            );
                        },
                    );
                    final divided = tiles.isNotEmpty ? ListTile.divideTiles(
                        context: context,
                        tiles: tiles,
                    ).toList() : <Widget>[];

                    return Scaffold(
                        appBar: AppBar(
                            title: const Text('SavedSuggestions'),
                        ),
                        body: ListView(
                            children: divided
                        ),
                    );
                },
            ),
        );
    }
}
