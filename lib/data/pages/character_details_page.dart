import 'package:flutter/material.dart';

class CharacterDetailsPage extends StatelessWidget {
  final dynamic hero;

  const CharacterDetailsPage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Character details"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  hero['name'],
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  hero['species'],
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  hero['gender'],
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  hero['origin']['name'],
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  hero['location']['name'],
                  style: const TextStyle(fontSize: 20),
                ),
                Column(
                  children: hero['episode'].map<Widget>(
                    (episode) {
                      return Text(
                        'Episode ${episode.split('/').last}',
                        style: const TextStyle(fontSize: 20),
                      );
                    },
                  ).toList(),
                ),
                Text(
                  hero['created'],
                  style: const TextStyle(fontSize: 20),
                ),
                Image.network(
                  hero['image'],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
