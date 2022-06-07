import 'package:intl/intl.dart';

String getFormattedDate(num date, String pattern){
    //date.toInt() gives us the value as seconds. so need to be multiplication by 1000 to covert
    //milliseconds
    return DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(date.toInt() * 1000));
}