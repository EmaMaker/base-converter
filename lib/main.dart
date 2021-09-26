import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Converter',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fromBase = "One";
  String toBase = "One";

  String result = "";

  late TextEditingController _controller;
  RichText richText = RichText(text: const TextSpan());

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Base Converter"),
        actions: [
          IconButton(
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("How to use:"),
                              content: const Text(
                                "Input the number you want to convert, select the base it is in and the base you want convert it into. Then click \"Calculate\" and the result will appear at the bottom of the screen!",
                                style: TextStyle(fontSize: 13),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 16, 24, 8),
                              actions: [
                                TextButton(
                                    onPressed: () => {Navigator.pop(context)},
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [Text("Close")]))
                              ]);
                        }),
                  },
              icon: const Icon(Icons.info_outline_rounded))
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(children: [
            mainBody(),
            Expanded(
              child: Center(child: richText),
            )
          ]),
        ),
      ),
    );
  }

  Container mainBody() {
    return Container(
      height: 320,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Number "),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              baseSelector("From:", fromBase),
              baseSelector("To:", toBase)
            ]),
            Row(children: [
              Expanded(
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      onPressed: calculate,
                      child: const Text("CALCULATE!",
                          style: TextStyle(color: Colors.white))))
            ]),
          ],
        ),
      ),
    );
  }

  void calculate() {}

  void decimalToBase() {}

  void baseToDecimal() {}

  Container baseSelector(String labelText, String value) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(labelText),
          const SizedBox(
            width: 10,
          ),
          dpb(value),
        ],
      ),
    );
  }

  DropdownButton dpb(String dropdownValue) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'One',
        'Two',
        'Three',
        'Four',
        'Five',
        'Six',
        'Seven',
        'Eight',
        'Nine',
        'Ten',
        'Eleven',
        'Twelve',
        'Thirteen',
        'Fourteen',
        'Fifteen',
        'Hex',
        'BCD',
        '2\'s CP'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
