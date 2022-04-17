// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../widgets/navbar.dart' as navbar;
import '../widgets/form.dart' as form;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_complete_guide/models.dart' as models;


class Cartpage extends StatefulWidget {
  String message;
  Map<String, models.Customerprod> cart = {};
  int cartProds = 0;
  double ttlamt = 0;
  String prodtype = 'All';  
  List prodtypes=['All'];
  StateSetter setModalState;
  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  void add(pcode, unitrate){
      if (widget.cart[pcode] != null){
        setState(() {
         
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) + 1).toString();
        if (widget.cart[pcode].Quantity == '1.0'){
          widget.cartProds = widget.cartProds+1;
        }
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
        widget.ttlamt = widget.ttlamt + (double.parse(widget.cart[pcode].UnitRate));
        main.storage.setItem('cart', widget.cart);
         main.storage.setItem('ttl', widget.ttlamt.toString());
         main.storage.setItem('products', widget.cartProds.toString());
      });
      
      }
     }
    void subtract(pcode, unitrate){
      if (widget.cart[pcode].Quantity != '0.0'){
        setState(() {
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) - 1).toString();
        if (widget.cart[pcode].Quantity == '0.0'){
          widget.cartProds = widget.cartProds-1;
        }
        
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
        widget.ttlamt = widget.ttlamt - (double.parse(widget.cart[pcode].UnitRate));
        main.storage.setItem('cart', widget.cart);
        main.storage.setItem('ttl', widget.ttlamt.toString());
        main.storage.setItem('products', widget.cartProds.toString());
      });
      }
     }
  @override
  Widget build(BuildContext context) {
    widget.cart = main.storage.getItem('cart');
    widget.cartProds = int.parse(main.storage.getItem('products'));
    widget.ttlamt = double.parse(main.storage.getItem('ttl'));

    return Scaffold(
        drawer: navbar.Navbar(),
        appBar: AppBar(
          title: Text('Cart'),
          actions: [
            
          ],
        ),
        body: SingleChildScrollView(child: Column(
          children:[ 
            Text('Total Amt: '+ main.storage.getItem('ttl').toString(), style: TextStyle(fontWeight: FontWeight.w100, color: Colors.black, fontSize: 30),),
            Column(children: 
            widget.cart.values.map((e) {
              var image = e.pImage;
              if(e.Quantity != '0.0'){ 
                       return Card(child: Row(children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child:  Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                         ),
                         Column(children: [Text(e.pname, style: TextStyle( fontWeight: FontWeight.bold), ), Text('Rs.'+e.UnitRate),Row(children: [ElevatedButton(onPressed: ()=>subtract(e.product ,e.UnitRate), child: Text('-')),Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(child: Center(child: Text(e.Quantity.toString())), color: Colors.white, width: 50,),
                         ),ElevatedButton(onPressed: ()=>
                           add(e.product, e.UnitRate)
                         , child: Text('+')) ],),Padding(
                           padding: const EdgeInsets.all(2.0),
                           child: Row(children: [Text('Total: Rs.'),Container(child: Center(child: Text(e.Amount.toString())), color: Colors.white, width: 100,), ]),
                         ),])
                       ],),color: Theme.of(context).primaryColorLight,);}else{
                         return Container();
                       }
            }).toList()
           ),]
        )),);
        }
}