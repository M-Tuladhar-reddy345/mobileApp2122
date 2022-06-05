// ignore_for_file: unused_label, missing_return

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/commonApi/commonApi.dart';
import 'package:flutter_complete_guide/pages_Operators/Order.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';

import '../widgets/navbar.dart' as navbar;
class Orders_base extends StatefulWidget {

  @override
  State<Orders_base> createState() => _Orders_baseState();
}

class _Orders_baseState extends State<Orders_base> {
  Future getOrdersList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrdersList = getOrders_list();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('Orders List', Size(MediaQuery.of(context).size.width,56)),
      
      body: SingleChildScrollView(
        child: FutureBuilder(builder: (context, snapshot) {
           switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                                  return Container(
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  );
              case ConnectionState.done:
                                if(snapshot.data != null){
                                  final data = snapshot.data as List;
                                  return Column(
                                    children: data.reversed.map<Widget>((valueDict)=> GestureDetector(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Orderpage(valueDict['orderNo'].toString()))),
                                      child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      color: Theme.of(context).primaryColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration:BoxDecoration(),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                    
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(valueDict['orderNo'].toString()+'                 ', style: Theme.of(context).primaryTextTheme.titleMedium,),
                                                Text('Status: '+valueDict['status'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall,),
                                    
                                              ],
                                            ),
                                            Expanded(child: Align(alignment: Alignment.centerRight,child: Text(valueDict['date'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall,))),
                                            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_right,size: 30,color: Colors.white,)))
                                          ],),
                                        ),
                                      )
                                      ),
                                    )).toList(),
                                  );
                                  //child: Flexible(child: Text(snapshot.data.toString())),);
                                }else{return  Container();}
                   break;             
             case ConnectionState.none:
               // TODO: Handle this case.
               break;
             case ConnectionState.active:
               // TODO: Handle this case.
               break;
        }}
          ,future: getOrdersList,),
      ),
    );
  }
}