import 'package:flutter/material.dart';
import 'webview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'My Portals'),
    );
  }
}

class Portal {
  final String name;
  final String url;
  final IconData icon;
  final Color color;

  const Portal({
    required this.name,
    required this.url,
    required this.icon,
    required this.color,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Portal> portals = [
    const Portal(
      name: 'Outlook',
      url: 'https://outlook.live.com/',
      icon: Icons.email,
      color: Colors.blue,
    ),
    const Portal(
      name: 'Google Drive',
      url: 'https://drive.google.com/',
      icon: Icons.cloud,
      color: Colors.green,
    ),
    const Portal(
      name: 'Google',
      url: 'https://www.google.com/',
      icon: Icons.search,
      color: Colors.red,
    ),
    const Portal(
      name: 'Bing',
      url: 'https://www.bing.com/',
      icon: Icons.web,
      color: Colors.teal,
    ),
    const Portal(
      name: 'Yahoo',
      url: 'https://www.yahoo.com/',
      icon: Icons.newspaper,
      color: Colors.purple,
    ),
    const Portal(
      name: 'Wikipedia',
      url: 'https://www.wikipedia.org/',
      icon: Icons.book,
      color: Colors.grey,
    ),
    const Portal(
      name: 'GitHub',
      url: 'https://github.com/',
      icon: Icons.code,
      color: Colors.black,
    ),
    const Portal(
      name: 'Stack Overflow',
      url: 'https://stackoverflow.com/',
      icon: Icons.question_answer,
      color: Colors.orange,
    ),
  ];

  void _openPortal(Portal portal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: portal.url,
          title: portal.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: portals.length,
          itemBuilder: (context, index) {
            final portal = portals[index];
            return Card(
              elevation: 4.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                onTap: () => _openPortal(portal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: portal.color.withValues(alpha: 0.2),
                      child: Icon(
                        portal.icon,
                        size: 32,
                        color: portal.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      portal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
