import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            'Firestore Demo',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                //// VIEW DATA HERE
                FutureBuilder<QuerySnapshot>(
                    future: users.get(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading...");
                      } else if (snapshot.hasError) {
                        return Text("error : ${snapshot.error}");
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return Column(
                          children: snapshot.data?.docs.map((e) {
                                final data = e.data() as Map<String, dynamic>;
                                return ItemCard(
                                  data['username'],
                                  data['age'],
                                );
                              }).toList() ??
                              [],
                        );
                      } else {
                        return Text("No Data");
                      }
                    }),
                SizedBox(
                  height: 150,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 3)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: nameController,
                              decoration: InputDecoration(hintText: "Name"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: ageController,
                              decoration: InputDecoration(hintText: "Age"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[
                                900], // Ganti `color` dengan `backgroundColor`
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            //// ADD DATA HERE
                            users.add({
                              'username': nameController.text,
                              'age': int.tryParse(ageController.text) ?? 0,
                            }).then((value) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Data Berhasil Ditambahkan"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ],
                                    );
                                  });
                            });
                            nameController.clear();
                            ageController.clear();
                          },
                          child: Text(
                            'Add Data',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
