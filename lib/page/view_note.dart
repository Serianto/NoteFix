// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notefix/model/notes_model.dart';
import 'package:notefix/page/add_edit_screen.dart';
//import 'package:notefix/page/add_edit_screen.dart';
import 'package:notefix/sevice/database_helper.dart';

class ViewNoteScreen extends StatelessWidget {
  final Note note;
  ViewNoteScreen({super.key, required this.note});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context), 
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            )
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditNoteScreen(note: note)));
            }, 
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            )
          ),
          SizedBox(width: 8,)
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.white,),

                          SizedBox(width: 8),
                          Text(_formatDateTime(note.dateTime), style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),),
                      ],
                    )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)
                  )
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.8),
                      height: 1.6,
                      letterSpacing: 0.2
                    ),),
                ),
              ))
          ],
        )),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Hapus',
          style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text('Yakin ingin dihapus?', style: TextStyle(color: Colors.black45, fontSize: 16),),
          actions: [
            TextButton(onPressed: ()=> Navigator.pop(context, false), child: Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
            TextButton(onPressed: ()=> Navigator.pop(context, true), child: Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600))),
          ],
      ));
      if(confirm == true) {
        await _databaseHelper.deleteNote(note.id!);
        Navigator.pop(context);
      }
  }
}