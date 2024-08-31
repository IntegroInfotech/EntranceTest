import 'dart:convert';

import 'package:entrancetest/models/question.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entrance Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Entrance Test'),
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
  bool _isLoading = true;

  bool _isSubmitting = false;
  final List<TextEditingController> answers = [];

  String result = '';

  List<String> questions = [];

  @override
  void didChangeDependencies() {
    loadQuestion();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: result.isNotEmpty
          ? Center(
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => index ==
                                questions.length
                            ? Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 50),
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    elevation: WidgetStatePropertyAll(5),
                                    fixedSize:
                                        WidgetStatePropertyAll(Size(200, 45)),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isSubmitting = true;
                                    });
                                    await Future.delayed(
                                      const Duration(seconds: 3),
                                    );
                                    setState(() {
                                      _isSubmitting = false;
                                      result =
                                          'You have secured Admission In AirTribe.\nAnd Your Score is 10';
                                    });
                                  },
                                  child: _isSubmitting
                                      ? const CircularProgressIndicator()
                                      : const Text('SUBMIT'),
                                ),
                              )
                            : Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${index + 1}. ${questions.elementAt(index)}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: answers.elementAt(index),
                                        decoration: InputDecoration(
                                          hintText: 'Describe your answer',
                                          hintMaxLines: 5,
                                          hintFadeDuration:
                                              const Duration(milliseconds: 500),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        textInputAction:
                                            index < questions.length - 1
                                                ? TextInputAction.next
                                                : TextInputAction.go,
                                        minLines: null,
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        itemCount: questions.length + 1,
                        separatorBuilder: (context, index) =>
                            index < questions.length - 1
                                ? const Divider()
                                : Container(),
                      ),
                    ),
                  ],
                ),
    );
  }

  void loadQuestion() async {
    answers.clear();
    questions.clear();
    final res = await http.get(
      Uri.parse(
          'https://3648-2409-40f2-204f-7663-3449-7141-5c1f-e918.ngrok-free.app/question'),
      headers: {'Content-Type': 'application/json'},
    );
    final decodedQuestion = json.decode(res.body) as Map<String, dynamic>;
    print(decodedQuestion['questions'].length);
    if (decodedQuestion.containsKey('questions')) {
      setState(() {
        questions.addAll(List<String>.from(
            (decodedQuestion['questions'] as List<dynamic>).map((e) => e)));
      });
    }
    for (var string in questions) {
      answers.add(TextEditingController());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
