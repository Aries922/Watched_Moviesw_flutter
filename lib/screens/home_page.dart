import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watched_movies/Services/movies.dart';
import 'package:watched_movies/screens/add_movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final MoviesService get = Provider.of<MoviesService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Watched Movies ")),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddMoviesPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("users")
                .doc(auth!.uid)
                .collection("movies")
                .get()
                .asStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return snapshot.data != null
                  ? Expanded(
                      child: ListView.builder(
                          
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            String docId = snapshot.data!.docs[index].id;

                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: double.infinity,
                                        height: 150,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: Image.network(
                                            data["image"] ??
                                                "https://images.unsplash.com/photo-1638735806473-501223cf3866?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data["name"] ?? "",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                data["director"] ?? "",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            print(docId);
                                            await MoviesService()
                                                .deleteMovie(context, docId);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : const Center(
                      child: Text("No data Found"),
                    );
            },
          ),
        ]),
      ),
    );
  }
}
