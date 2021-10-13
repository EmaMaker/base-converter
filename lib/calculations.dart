import 'dart:math';

String decimalToBase(int number, toBase) {
  //current base as integer
  String tmpBase = toBase.toUpperCase();
  if (tmpBase == "HEX") tmpBase = "16";

  bool negative = number < 0;
  if (negative) number *= -1;

  String res = "";
  switch (tmpBase) {
    case "BCD":
      String n = number.toString();
      for (int i = 0; i < n.length; i++) {
        String digit = decimalToBase(int.parse(n[i]), "2");
        int missingZeros = 4 - digit.length;
        for (int i = 0; i < missingZeros; i++) {
          digit = "0" + digit;
        }
        res += digit;
      }
      if (negative) res = "-" + res;
      break;
    case "2CP":
      String binary = decimalToBase(number, 2);
      bool gotOne = false;
      if (negative) {
        for (int i = 0; i < binary.length; i++) {
          if (gotOne) {
            if (binary[i] == "1")
              binary[i] == "0";
            else
              binary[i] == "1";
          } else {
            if (binary[i] == "1") gotOne = true;
          }
        }
        res = binary;
      } else {
        res = "0" + binary;
      }
      break;
    default:
      int base = int.parse(tmpBase); //current base as integer
      List<int> digits = [];

      while (number != 0) {
        digits.add(number % base);
        number = number ~/ base;
      }
      digits = digits.reversed.toList();

      for (int i = 0; i < digits.length; i++) {
        if (digits[i] >= 10) {
          res += String.fromCharCode(digits[i] + 55);
        } else {
          res += digits[i].toString();
        }
      }
      if (negative) res = "-" + res;
      break;
  }
  return res;
}

String baseToDecimal(String number, String pBase) {
  bool negative = number.startsWith('-');
  if (negative) number = number.split('-')[1];

  //current base as integer
  String tmpBase = pBase.toUpperCase();
  if (tmpBase == "HEX") tmpBase = "16";

  String cBase = tmpBase;
  if (cBase == "BCD" || cBase == "2CP") cBase = "2";
  int controlBase = int.parse(cBase);

  for (int i = 0; i < number.length; i++) {
    if (charToDigit(number, i) >= controlBase) {
      return "error-invalid-number-for-base";
    }
  }

  String res = "";
  switch (tmpBase) {
    case "BCD":
      int missingZeros = (4 - number.length % 4) % 4;
      for (int i = 0; i < missingZeros; i++) number = "0" + number;

      for (int i = 0; i < number.length; i += 4) {
        String n = number[i];
        n += number[i + 1];
        n += number[i + 2];
        n += number[i + 3];
        String n1 = baseToDecimal(n, "2");
        if (int.parse(n1) > 9) return "error-bcd-greater-nine";
        res += n1;
      }
      break;
    case "2CP":
      if (negative) {
        return "error-negative-cp2";
      }

      int dres = 0;
      number = number.split('').reversed.join('').toString();
      for (int i = 0; i < number.length; i++) {
        int add = int.parse(number[i]) * pow(2, i).toInt();
        if (i == number.length - 1) add *= -1;
        dres += add;
      }
      res = dres.toString();
      break;
    default:
      int base = int.parse(tmpBase);
      List<int> digits = [];

      // Get the value in decimal of the current digit
      for (int i = 0; i < number.length; i++) {
        int digit = charToDigit(number, i);
        digits.add(digit);
      }

      //Reverse the list
      digits = digits.reversed.toList();

      int dres = 0;
      for (int i = 0; i < digits.length; i++) {
        dres += digits[i] * pow(base, i).toInt();
      }
      res = dres.toString();
      break;
  }
  return res;
}

int charToDigit(String s, int i) {
  return isDigit(s, i) ? int.parse(s[i]) : s.codeUnitAt(i) - 55;
}

// https://stackoverflow.com/questions/25872456/dart-what-is-the-fastest-way-to-check-if-a-particular-symbol-in-a-string-is-a-d
bool isDigit(String s, int i) => (s.codeUnitAt(i) ^ 0x30) <= 9;
