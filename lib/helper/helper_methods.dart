import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp){
  DateTime dateTime = timestamp.toDate();
  // by year
  String year = dateTime.year.toString();
  // by month
  String month = dateTime.month.toString();
  // by day
  String day = dateTime.day.toString();
  // final date time
  String formattedData = '$day/$month/$year';
  return formattedData;
}