import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tiffin/asistantMethods/cartItemCounter.dart';
import 'package:my_tiffin/asistantMethods/totalAmount.dart';
import 'package:my_tiffin/models/items.dart';
import 'package:my_tiffin/widgets/cartPageWidget.dart';
import 'package:my_tiffin/widgets/simple_appbar.dart';
import 'package:my_tiffin/widgets/user_drawer.dart';
import 'package:provider/provider.dart';

import '../asistantMethods/cartItemMethods.dart';
import '../riders_app/widgets/progress_bar.dart';
import 'address_screen.dart';


class CartPage extends StatefulWidget {


  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<int>? itemCountList;
  num totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    itemCountList= separateItemQuantiteis();
  }
  cartBottomNavBar(){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children:[
                const Text("Total: ",style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(
                  width: 15,
                ),
                Consumer<TotalAmount>(builder: (context,amountProvider,c){
                  return Text("\$ ${amountProvider.totalamt}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,

                    ),
                  );

                }),
              ],
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (c)=>AddressScreen(
                        totalAmount : totalAmount.toDouble(),
                    )));
              },
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.green),
                padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15,horizontal: 20,),),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),)),
              ),
              child: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,),),
            )],
        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            size: 33,
            color: Colors.green
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                        left: 10,
                      ),
                    child: Text(
                      "Order List",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  //Item
                  itemCountList!.isEmpty?
                 const Center(
                child: Text("No items found.First Add Items to Cart.",style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),)
                 ):
                  StreamBuilder<QuerySnapshot>(
                    stream:    FirebaseFirestore.instance
                        .collection('items')
                        .where("itemID", whereIn: separateItemIds()).
                    orderBy("publishedDate", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: circularProgress());
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No items found."),
                        );
                      } else {
                        return Container(
                          width: 380,
                          height: MediaQuery.of(context).size.height * 0.3, // Adjust the height as needed
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: List.generate(snapshot.data!.docs.length, (index) {
                              Items model = Items.fromJson(
                                snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                              );
                              if(index == 0)
                                {
                                  totalAmount = 0;
                                  totalAmount = totalAmount + (double.parse(model.itemPrice!) * itemCountList![index]);
                                }
                              else{
                                totalAmount = totalAmount + (double.parse(model.itemPrice!) * itemCountList![index]);

                              }
                              if(snapshot.data!.docs.length-1== index)
                              {
                                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,listen: false).displayTotalAmount(totalAmount.toDouble());
                                });

                              }
                                return CartPageWidget(
                                model: model,
                                context: context,
                                quantityNumber: itemCountList![index],
                              );
                            }),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow:[ BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0,3),
                          ),
                          ]),
                      child:  Column(
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Items:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Consumer<CartItemCounter>(builder: (context,countProvider,c){
                                  return Text(countProvider.count.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,

                                    ),
                                  );

                                }),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Sub-Total:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text("10",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,

                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery Fee:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text("10",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,

                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),

                           Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Consumer<TotalAmount>(builder: (context,amountProvider,c){
                                  return Text(amountProvider.totalamt.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,

                                    ),
                                  );

                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

          )
        ],
      ),
      bottomNavigationBar: cartBottomNavBar(),
    );
  }

}

