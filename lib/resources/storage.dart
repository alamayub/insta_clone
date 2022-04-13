import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(String folder, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(folder).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot task = await uploadTask;
    String url = await task.ref.getDownloadURL();
    return url;
  }
}