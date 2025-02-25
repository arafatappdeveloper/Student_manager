import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


String formatTimestamp(DocumentSnapshot doc) {
  if (doc.data() != null && doc.data() is Map<String, dynamic>) {
    var data = doc.data() as Map<String, dynamic>;

    if (data.containsKey('date') && data['date'] != null) {
      Timestamp timestamp = data['date'];
      DateTime dateTime = timestamp.toDate();
      return DateFormat('MMMM dd').format(dateTime);
    }
  }

  return "No Date Available"; // Return fallback text if date is missing
}