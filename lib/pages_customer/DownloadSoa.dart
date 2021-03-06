import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import '../widgets/navbar.dart' as navbar;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

import 'package:file_picker/file_picker.dart';

// ignore: must_be_immutable
class PdfSoaCustomer extends StatefulWidget {
  String message;

  PdfSoaCustomer();
  DateTime dateTimefrom = DateTime.now();
  DateTime dateTimeto = DateTime.now();
  DateTime dateTimeExExtract = DateTime.now();

  @override
  State<PdfSoaCustomer> createState() => _PdfSoaCustomer();
}

class _PdfSoaCustomer extends State<PdfSoaCustomer> {
  bool isLoading = false;

  var progress;

  Future<File> _storeFile(String url, List<int> bytes) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    String fileName = datefrom + 'to' + dateto + '.pdf';


    await Permission.storage.request();
    String dir = await FilePicker.platform.getDirectoryPath();
              
    final File file = File('${dir}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<File> fetchPDF(context) async {
    var datefrom = DateFormat("y-M-d").format(widget.dateTimefrom);
    var dateto = DateFormat("y-M-d").format(widget.dateTimeto);
    var brch = main.storage.getItem('branch');

    final response = await http.get(Uri.parse(main.url_start +
        'mobileApp/getSoa/' +
        datefrom.toString() +
        '/' +
        dateto.toString() +
        '/' +
    main.storage.getItem('phone').toString()));
    if (response.statusCode == 200) {
      setState(() {
        isLoading= false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('successfully Downloaded pdf'),backgroundColor: Colors.green,));
         
        
      });
      return _storeFile(response.body, response.bodyBytes);
    } else {
      setState(() {
        isLoading= true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to download pdf'),backgroundColor: Colors.red,));
         
        
      });
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (main.storage.getItem('module_accessed').toString().contains('SoaDownload')==false){main.storage.setItem('module_accessed', main.storage.getItem('module_accessed').toString()+' SoaDownload');}
  }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(       
        drawer: navbar.Navbar(),
        appBar: AppBarCustom('Download Statement', Size(MediaQuery.of(context).size.width, 56)),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              widget.dateTimefrom = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimefrom),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            Text(
              'To',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              widget.dateTimeto = value;
                            });
                          }
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat("d-M-y").format(widget.dateTimeto),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final File pdf = await fetchPDF(context);
                  OpenFile.open(pdf.path);
                  // print(pdf);
                  // openPDF(context, pdf);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Download PDF',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
            
            isLoading == true ? CircularProgressIndicator() : Text('')
          ]),
        ));
  }
}
