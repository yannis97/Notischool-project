import 'package:cloud_firestore/cloud_firestore.dart';

class Classes {
  final String id;
  final List noticesId;
  //final DateTime date;

  Classes(DocumentSnapshot snapshot)
    : id = snapshot.documentID,
      noticesId = snapshot.data['noticesId'];
      //date = snapshot.data['date'].toDate();

  //String get formatedDate => "${date.day}/${date.month}/${date.year}";

  String toString() => "Class($id)<noticesId: $noticesId>";
}