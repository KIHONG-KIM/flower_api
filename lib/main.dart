import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=flowers&per_page=30'),
      headers: {
        'Authorization':
            'TMkI6JMaisFz6RVyAn1ynCiaBqGRHFoqZE6rOzzsvH2Fvfkv0RNHg0Up',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        items = List<Item>.from(data['photos'].map((photo) => Item(
            name: photo['photographer'], imageUrl: photo['src']['medium'])));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load images')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(item: items[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(items[index].imageUrl,
                              fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(items[index].name,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail for ${item.name}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            item.imageUrl,
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text('URL: ${item.imageUrl}', style: TextStyle(fontSize: 24)),
          ElevatedButton(
              onPressed: () {
                print('Predict');
              },
              child: Text('Predict'))
        ],
      ),
    );
  }
}

class Item {
  final String name;
  final String imageUrl;

  Item({required this.name, required this.imageUrl});
}

// final response = await http.get(
//       Uri.parse('https://api.pexels.com/v1/search?query=flowers&per_page=30'),
//       headers: {
//         'Authorization':
//             'TMkI6JMaisFz6RVyAn1ynCiaBqGRHFoqZE6rOzzsvH2Fvfkv0RNHg0Up',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         items = List<Item>.from(data['photos'].map((photo) => Item(
//             name: photo['photographer'], imageUrl: photo['src']['medium'])));
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load images')),
//       );
//     }
//   }