// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:notefix/model/notes_model.dart';
import 'package:notefix/page/home_screen.dart';
import 'package:notefix/sevice/database_helper.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
    Colors.amber,
    Color(0xFF50C878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent
  ];

  @override
  void initState() {
    super.initState();
    if(widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        widget.note == null ? 'Tambah Catatan' : 'Edit Catatan',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Judul
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Judul Catatan',
                prefixIcon: Icon(Icons.title_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Masukkan Judul' : null,
            ),
            SizedBox(height: 16),

            // Input Isi Catatan
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Isi Catatan',
                prefixIcon: Icon(Icons.notes_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 10,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Masukkan Isi' : null,
            ),
            SizedBox(height: 16),

            // Pilihan Warna
            Text(
              'Pilih Warna:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _colors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black54
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF50C878),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              icon: Icon(Icons.save, color: Colors.white),
              label: Text(
                'Simpan Catatan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _saveNote();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HomeScreen()));
              },
            ),
          ],
        ),
      ),
    ),
  );
}
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       elevation: 0,
  //       backgroundColor: Colors.white,
  //       title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
  //     ),
  //     body: Form(
  //       key: _formKey,
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.all(16),
  //             child: Column(
  //               children: [
  //                 TextFormField(
  //                   controller: _titleController,
  //                   decoration: InputDecoration(
  //                     hintText: 'Judul',
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12)
  //                     )
  //                   ),
  //                   validator: (value) {
  //                     if(value == null || value.isEmpty) {
  //                       return 'Masukkan Judul';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 SizedBox(height: 16),
  //                 TextFormField(
  //                   controller: _contentController,
  //                   decoration: InputDecoration(
  //                     hintText: 'Isi',
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12)
  //                     )
  //                   ),
  //                   maxLines: 10,
  //                   validator: (value) {
  //                     if(value == null || value.isEmpty) {
  //                       return 'Masukkan Isi';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.all(16),
  //                   child: SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Row(
  //                       children: _colors.map((color) {
  //                         return GestureDetector(
  //                           onTap: ()=> setState(() => _selectedColor = color),
  //                           child: Container(
  //                             height: 48,
  //                             width: 48,
  //                             margin: EdgeInsets.only(right: 8),
  //                             decoration: BoxDecoration(
  //                               color: color,
  //                               shape: BoxShape.circle,
  //                               border: Border.all(
  //                                 color: _selectedColor == color ? Colors.black45 : Colors.transparent,
  //                                 width: 2,
  //                               )
  //                             ), 
  //                           ),
  //                         );
  //                       }
  //                     ).toList()
  //                     ),
  //                   ),
  //                 ),
  //           InkWell(
  //             onTap: (){
  //               _saveNote();
  //               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //             },
  //             child: Container(
  //               margin: EdgeInsets.all(20),
  //               padding: EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: Color(0xFF50C878),
  //                 borderRadius: BorderRadius.circular(10)
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   'Simpan',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold
  //                   ),),
  //               ),
  //             ),
  //           )
  //               ],
  //             ),
  //           ),
  //         ],
  //       )),
  //   );
  // }

  Future<void> _saveNote() async {
    if(_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString()
      );

      if(widget.note == null){
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
    }
  }
}