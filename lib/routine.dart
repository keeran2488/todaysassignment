import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Routine extends StatelessWidget {
  final String day =  DateFormat('EEEE').format(DateTime.now().add(Duration(hours: 8)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Routine'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Routine').document(day).collection("Sem V").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data.documents[index].data["Subject"]),
                  subtitle: Text(snapshot.data.documents[index].data["Time"]),
                  onTap: (){

                  },
                );
              });
        },
      ),
    );
  }
}