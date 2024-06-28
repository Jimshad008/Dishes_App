import 'package:dishes/core/error_text.dart';
import 'package:dishes/core/loader.dart';
import 'package:dishes/feature/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/global_constants.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(

          children: [
            Text("Favourites",style: TextStyle(fontWeight:FontWeight.bold,fontSize: width*0.05,color: Colors.black),),
          ],
        ),
      ),
      body: Consumer(
        builder: (context,ref,child) {
         List wishlist=ref.watch(wishlistItems);
          return ref.watch(getFavouriteDishesProvider(wishlist)).when(data: (dishes) {
           return  Padding(
             padding:  EdgeInsets.all(width*0.03),
             child: SizedBox(
                width: width,
                child: GridView.builder(
                  itemCount: dishes.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: width*0.01,childAspectRatio:0.75,mainAxisSpacing: width*0.01), itemBuilder: (context, index) {
                  return   Card(
                    color: Colors.white,
                    child: SizedBox(
                      width: width*0.45,
                      height: height*0.3,
                      child: Column(
                        children: [
                          Container(
                            height: height*0.18,
                            decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(width*0.015),
                                image: DecorationImage(image: NetworkImage(dishes[index].imageUrl),fit: BoxFit.cover)
                            ) ,
                          ),
                          SizedBox(height: height*0.01,),
                          Text(dishes[index].dishName,style: TextStyle(fontWeight: FontWeight.w400,fontSize: width*0.04,color: Colors.black)),
                          Padding(
                            padding:  EdgeInsets.all(width*0.015),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.time,size: width*0.04,),
                                        Text(" 20 minutes",style: TextStyle(fontSize: width*0.03,color: Colors.black))
                                      ],
                                    ),
                                    Row(

                                      children: [
                                        Icon(Icons.circle,color:Colors.green,size: width*0.038,),
                                        Text(" Vegetarian",style: TextStyle(fontSize: width*0.03,color: Colors.black))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: height*0.01,),
                                Row(
                                  children: List.generate(5, (index) =>  Icon(Icons.star,color: Colors.grey,size:width*0.038, )),
                                )
                              ],
                            ),
                          )



                        ],
                      ),
                    ),
                  );
                },),
              ),
           );
          }, error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          }, loading: () => const Loader(),);

        }
      ),
    );
  }
}
