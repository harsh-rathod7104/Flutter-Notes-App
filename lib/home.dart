import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/models/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }

  void onSearchTextChange(String searchText) {
    setState(
      () {
        filteredNotes = sampleNotes
            .where((note) =>
                note.content.toLowerCase().contains(searchText.toLowerCase()) ||
                note.title.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      },
    );
  }

  sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
      filteredNotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notes",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      filteredNotes = sortNotesByModifiedTime(filteredNotes);
                    });
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: onSearchTextChange,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes...",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey.shade800,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 30),
                itemCount: filteredNotes.length,
                itemBuilder: ((context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 20),
                    color: backgroundColors[index],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: "${filteredNotes[index].title}\n",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: "${filteredNotes[index].content}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "${DateFormat('EEE MMM d,yyyy h:mm a').format(filteredNotes[index].modifiedTime)}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade800,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey.shade900,
                                  icon: Icon(
                                    Icons.info,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    "Are you sure you want to delete ? ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade500),
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade500),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text(
                                          "No",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            if (result != null && result) {
                              deleteNote(index);
                            }
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }
}