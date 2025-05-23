import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notefix/model/notes_model.dart';
import 'package:notefix/page/add_edit_screen.dart';
import 'package:notefix/page/view_note.dart';
import 'package:notefix/sevice/database_helper.dart';
import 'package:notefix/widgets/no_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }
  
  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    final dayName = DateFormat.EEEE().format(dt);

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return '$dayName, ${dt.hour.toString().padLeft(2, '0')} : ${dt.minute.toString().padLeft(2, '0')}';
    }

    return '$dayName, ${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')} : ${dt.minute.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Catatan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _notes.isEmpty
        ? Center(child: NoNotes())
        : GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16),
          itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
            Color color;
              try {
                color = Color(int.parse(note.color));
              } catch (e) {
                color = Colors.amber; // fallback color
              }
          //final color = Color(int.parse(note.color));

          return GestureDetector(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNoteScreen(note: note)));
              _loadNotes();
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _formatDateTime(note.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),)
                ],
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed:() async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditNoteScreen()));
      },
      backgroundColor: Color(0xFF50C878),
      foregroundColor: Colors.white,
      child: Icon(Icons.add),
      ),
    );
  }
}