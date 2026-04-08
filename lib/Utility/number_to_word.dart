class NumberToWord {
  String? input;
  List<String> one = [
    '',
    'One ',
    'Two ',
    'Three ',
    'Four ',
    'Five ',
    'Six ',
    'Seven ',
    'Eight ',
    'Nine ',
    'Ten ',
    'Eleven ',
    'Twelve ',
    'Thirteen ',
    'Fourteen ',
    'Fifteen ',
    'Sixteen ',
    'Seventeen ',
    'Eighteen ',
    'Nineteen '
  ];
  List<String> ten = [
    '',
    '',
    'Twenty ',
    'Thirty ',
    'Forty ',
    'Fifty ',
    'Sixty ',
    'Seventy ',
    'Eighty ',
    'Ninety '
  ];
  List<String> maxs = ['', '', ' Hundred ', ' Thousand ', ' Lakh ', ' Crore '];

  int convertDivToInt(int number, int div) {
    List dividList = '${(number / div)}'.split('.');
    return int.parse(dividList[0]);
  }

  String numToWords(int n, String s) {
    String str = '';
    if (n > 19) {
      str += ten[convertDivToInt(n, 10)] + one[n % 10];
    } else {
      str += one[n];
    }
    if (n != 0) {
      str += s;
    }
    return str;
  }

  String convertToWords(num nn) {
    String paiseWord = '';
    List ruppeePaise = '$nn'.split('.');
    if (ruppeePaise.length >= 2) {
      int paise = int.parse(ruppeePaise[1]);
      paiseWord = numToWords((paise % 100), 'Paise');
    }
    int n = int.parse('${ruppeePaise[0]}');
    if (n < 10 && n > 0) {
      return paiseWord != ''? '${one[n]}Rupees and $paiseWord Only': '${one[n]}Rupees Only';
    }
    String out = '';
    out += numToWords(convertDivToInt(n, 10000000), 'crore ');
    out += numToWords((convertDivToInt(n, 100000) % 100), 'lakh ');
    out += numToWords((convertDivToInt(n, 1000) % 100), 'thousand ');
    out += numToWords((convertDivToInt(n, 100) % 10), 'hundred ');
    if (n > 100 && (n % 100 > 0)) {
      out += 'and ';
    }
    out += numToWords((n % 100), 'Rupees ');
    if (paiseWord != '') {
      if (out == '') {
        out += '$paiseWord ';
      } else {
        out += 'and $paiseWord ';
      }
    }
    if (paiseWord != '' || out != '') {
      out += 'Only';
    }
    return out;
  } 
}