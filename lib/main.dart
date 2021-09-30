import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base_converter/calculations.dart';

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
  String fromBase = "2", savedFromBase = "";
  String toBase = "10", savedToBase = "";
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
    return GestureDetector(
      onTap: () => hidekbd,
      child: Scaffold(
        resizeToAvoidBottomInset: false, //new line
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
        body: Container(
          margin: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(children: [
            mainBody(),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Center(child: resultToRichText())),
            ),
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
              keyboardType: TextInputType.phone,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [baseSelector("From:", 0), baseSelector("To:", 1)]),
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

  void hidekbd() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  RichText resultToRichText() {
    switch (result) {
      case "error-negative-in-cp2":
        return errorString("Error: 2CP number can't have a negative sign");
      case "error-bcd-greater-nine":
        return errorString("Error: BCD can only code digits from 0 to 9");
      case "error-invalid-number-for-base":
        return errorString(
            "Error: a digit is greater than or equal to the base");
      case "":
        return RichText(
          text: TextSpan(
            text: '',
            style: DefaultTextStyle.of(context).style,
            children: const <TextSpan>[],
          ),
        );
      default:
        return RichText(
          text: TextSpan(
            text: '',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              mainNumber(_controller.text),
              baseSubtitle("($savedFromBase)"),
              mainNumber(" = $result"),
              baseSubtitle("($savedToBase)"),
            ],
          ),
        );
    }
  }

  RichText errorString(String content) {
    return RichText(
      text: TextSpan(
        text: '',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: content,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Roboto")),
        ],
      ),
    );
  }

  TextSpan mainNumber(String text) {
    return TextSpan(
        text: text,
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold));
  }

  TextSpan baseSubtitle(String text) {
    return TextSpan(
        text: text, style: const TextStyle(color: Colors.black, fontSize: 14));
  }

  Container baseSelector(String labelText, int i) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(labelText),
          const SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: i == 0 ? fromBase : toBase,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 16,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                if (i == 0) {
                  fromBase = newValue!;
                } else if (i == 1) {
                  toBase = newValue!;
                }
              });
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<String> items = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    'Hex',
    'BCD',
    "2CP"
  ];

  void calculate() {
    setState(() {
      hidekbd();
      savedFromBase = fromBase;
      savedToBase = toBase;

      String s = baseToDecimal(_controller.text.toUpperCase(), savedFromBase);
      if (!s.startsWith("error")) s = decimalToBase(int.parse(s), savedToBase);
      result = s;
    });
  }
}
