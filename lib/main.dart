import 'package:deniz/deniz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deniz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController urlController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    urlController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: urlController,

              focusNode: focusNode,
              autovalidateMode: AutovalidateMode.onUnfocus,
              onTapOutside: (_) => focusNode.unfocus(),
              enabled: true,
              onEditingComplete:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DenizScreen(url: urlController.text),
                    ),
                  ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                counter: SizedBox(),
                labelText: 'Url',
                hintText: 'Write url',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Please enter a URL')));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DenizScreen(url: urlController.text),
                    ),
                  );
                }
              },
              child: Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
