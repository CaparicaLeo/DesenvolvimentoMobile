import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Future<void> create(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> read() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }

  Future<void> update(String docID, String note) {
    return notes.doc(docID).update({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> delete(String docID) {
    return notes.doc(docID).delete();
  }
}
