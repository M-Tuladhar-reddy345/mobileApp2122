import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_complete_guide/main.dart' as main;
import 'dart:io';
get_products() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getProducts_all/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.post(url, body: {'phone':main.storage.getItem('phone')});
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['products'];
    }
  }
getTransactions(type) async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getTransactions/' +
        main.storage.getItem('branch') +
        '/');
    final response = await http.post(url, body: {'phone':main.storage.getItem('phone'), 'type':type});
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['transactions'];
    }
  }