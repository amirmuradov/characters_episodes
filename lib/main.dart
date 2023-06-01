import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/characters-bloc.dart';
import 'bloc/characters-event.dart';
import 'data/pages/episodes_page.dart';
import 'data/pages/characters_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => CharactersBloc()
          ..add(
            FetchCharacters(1),
          ),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const CharactersPage(),
    EpisodesPage(),
  ];
//test
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(
          "Rick and Morty",
          style: GoogleFonts.montserrat(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.red,
        selectedIconTheme: const IconThemeData(
          color: Colors.red,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Characters",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_task,
            ),
            label: "Episodes",
          ),
        ],
      ),
    );
  }
}
