import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String id;
  final String object;
  final String text;
  final DateTime date;

  Notice(DocumentSnapshot snapshot)
    : id = snapshot.documentID,
      object = snapshot.data['object'],
      text = snapshot.data['text'],
      date = snapshot.data['date'].toDate();

  String get formatedDate => "${date.day}/${date.month}/${date.year}";

  String toString() => "Notice($id)<objet: $object, date: $formatedDate, text : $text>";
}