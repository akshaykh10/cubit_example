import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

const names = ["Foo", "Bear", "Boo"];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  pickRandomName() => emit(names.getRandomElement());

  sendNone() => emit(null);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late final NamesCubit cubit;
  @override
  void initState() {
    cubit = NamesCubit();

    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
            child: StreamBuilder(
                stream: cubit.stream,
                builder: ((context, snapshot) {
                  final button = TextButton(
                      onPressed: () => cubit.pickRandomName(),
                      child: const Text("Pick a random name"));
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return button;
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator(
                          color: Colors.blue);
                    case ConnectionState.active:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data.toString()),
                          const SizedBox(height: 8.0),
                          button
                        ],
                      );
                    case ConnectionState.done:
                      return const SizedBox();
                  }
                }))),
      ),
    );
  }
}
