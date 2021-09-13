import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String text;
  final String creator;
  final Timestamp timestamp;

  PostModel({this.id, this.text, this.creator, this.timestamp});
}
