import 'package:dishes/core/constant/global_constants.dart';
import 'package:dishes/feature/home/view/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error_text.dart';
import '../../../core/loader.dart';
import '../../../core/util.dart';
import '../../login/controller/loginController.dart';
import '../controller/home_controller.dart';
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
final searchProvider=StateProvider((ref) => "");
TextEditingController search=TextEditingController();

  @override
  void initState() {

    super.initState();
  }
  @override
  void dispose() {
   search.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Consumer(
            builder: (context,ref,child) {
              return GestureDetector(
                onTap: () {
                  ref.read(loginControllerProvider).logoutUser(context: context);
                },
                child:  Row(
                  children: [
                    SizedBox(width: width*0.04,),
                    const Icon(Icons.logout,color: Colors.black,),
                  ],
                ),
              );
            }
        ),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Dishes",style: TextStyle(fontWeight:FontWeight.bold,fontSize: width*0.05,color: Colors.black),),
          ],
        ),
        actions:[
          Consumer(
            builder: (context,ref,child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) =>const Wishlist(),));
                },
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.heart,color: Colors.black,weight: 2,),

                  ],
                ),
              );
            }
          ),
          SizedBox(width: width*0.05,)
        ] ,
      ),
      body: SizedBox(
        width: width,

        child: Consumer(
          builder: (context,ref,child) {
            final searchText=ref.watch(searchProvider);
            final randomIndex=ref.watch(randomIndexProvider);

            return ref.watch(getDishesProvider).when(data: (dishes) {
              return  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    width: width,
                    height: height*0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(dishes[randomIndex].imageUrl),fit: BoxFit.cover)
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: width*0.02,
                            right: width*0.02,
                            child: Consumer(
                              builder: (context,ref1,child) {
                                final wishlist=ref1.watch(wishlistItems);

                                return GestureDetector(
                                  onTap: () async{
                                    List<String> a=ref.watch(wishlistItems);
                                    if(ref.watch(wishlistItems).contains(dishes[randomIndex].dishId)){
                                      a.remove(dishes[randomIndex].dishId);

                                    }
                                    else{

                                      a.add(dishes[randomIndex].dishId);
                                    }
                                    ref.read(wishlistItems.notifier).update((state) => a);
                                    SharedPreferences local=await SharedPreferences.getInstance();
                                    local.setStringList("wishlist", ref.watch(wishlistItems));
                                    setState(() {
                                      
                                    });
                                  },
                                    child: (wishlist.contains(dishes[randomIndex].dishId))?const Icon(CupertinoIcons.heart_fill,color: Colors.red,):const Icon(CupertinoIcons.heart,color: Colors.white,));
                              }
                            )),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: width*0.8,
                                height: height*0.08,
                                child: TextFormField(

                                  cursorColor: Colors.orange,
                                  autofillHints: const [AutofillHints.name],
                                  onChanged: (value) {
                                    ref.read(searchProvider.notifier).update((state) => value.trim());
                                  },
                                  controller:search,
                                  obscureText: false,
                                  decoration: InputDecoration(

                                    prefixIcon:const Icon(CupertinoIcons.search),
                                    labelStyle: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: const Color(0xFF57636C),
                                      fontSize: width*0.035,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: const Color(0xFF57636C),
                                      fontSize: width*0.035,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: InputBorder.none,

                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.7),
                                    contentPadding: EdgeInsets.only(top: height*0.015,left: width*0.05),
                                  ),
                                  style:TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: const Color(0xFF1D2429),
                                    fontSize: width*0.035,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(height: height*0.05,),
                              Column(
                               children: [
                                 Text("Deal of The Day",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*0.07,color: Colors.white),),
                                 Text(dishes[randomIndex].dishName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*0.04,color: Colors.white),)
                               ] ,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(searchText.isEmpty)
                  Padding(
                    padding:  EdgeInsets.all(width*0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Discover regional delights",style: TextStyle(fontWeight: FontWeight.w300,fontSize: width*0.05,color: Colors.grey.shade900),),
                        SizedBox(height: height*0.01,),
                        SizedBox(
                          width: width,
                          height: height*0.3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount: dishes.length,
                            itemBuilder:  (context, index) {
                            return Row(
                              children: [
                                Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: width*0.45,
                                    height: height*0.3,
                                   child: Column(
                                     children: [
                                       Stack(
                                         children: [

                                           Container(
                                             height: height*0.18,
                                             decoration:BoxDecoration(
                                               borderRadius: BorderRadius.circular(width*0.015),
                                               image: DecorationImage(image: NetworkImage(dishes[index].imageUrl),fit: BoxFit.cover)
                                             ) ,
                                           ),
                                           Positioned(
                                               bottom: width*0.012,
                                               right: width*0.012,
                                               child: Consumer(
                                                   builder: (context,ref1,child) {
                                                     final wishlist=ref1.watch(wishlistItems);

                                                     return GestureDetector(
                                                         onTap: () async{
                                                           List<String> a=ref.watch(wishlistItems);
                                                           if(ref.watch(wishlistItems).contains(dishes[index].dishId)){

                                                             a.remove(dishes[index].dishId);

                                                           }
                                                           else{

                                                             a.add(dishes[index].dishId);
                                                           }
                                                           ref.read(wishlistItems.notifier).update((state) => a);

                                                           SharedPreferences local=await SharedPreferences.getInstance();
                                                           local.setStringList("wishlist", ref.watch(wishlistItems));
                                                           setState(() {

                                                           });
                                                         },
                                                         child: (wishlist.contains(dishes[index].dishId))?const Icon(CupertinoIcons.heart_fill,color: Colors.red,):const Icon(CupertinoIcons.heart,color: Colors.white,));
                                                   }
                                               )),
                                         ],
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
                                ),
                                SizedBox(width: width*0.03,)
                              ],
                            );
                          },),
                        )
                      ],
                    ),
                  ),
                    if(searchText.isEmpty)
                    Padding(
                      padding:  EdgeInsets.all(width*0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Breakfast for champions",style: TextStyle(fontWeight: FontWeight.w300,fontSize: width*0.05,color: Colors.grey.shade900),),
                          SizedBox(height: height*0.01,),
                          SizedBox(
                            width: width,
                            height: height*0.3,
                            child: ListView.builder(
                              reverse: true,
                              scrollDirection: Axis.horizontal,

                              itemCount: dishes.length,
                              itemBuilder:  (context, index) {
                                return Row(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      child: SizedBox(
                                        width: width*0.45,
                                        height: height*0.3,
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [

                                                Container(
                                                  height: height*0.18,
                                                  decoration:BoxDecoration(
                                                      borderRadius: BorderRadius.circular(width*0.015),
                                                      image: DecorationImage(image: NetworkImage(dishes[index].imageUrl),fit: BoxFit.cover)
                                                  ) ,
                                                ),
                                                Positioned(
                                                    bottom: width*0.012,
                                                    right: width*0.012,
                                                    child: Consumer(
                                                        builder: (context,ref1,child) {
                                                          final wishlist=ref1.watch(wishlistItems);

                                                          return GestureDetector(
                                                              onTap: () async{
                                                                List<String> a=ref.watch(wishlistItems);
                                                                if(ref.watch(wishlistItems).contains(dishes[index].dishId)){

                                                                  a.remove(dishes[index].dishId);

                                                                }
                                                                else{

                                                                  a.add(dishes[index].dishId);
                                                                }
                                                                ref.read(wishlistItems.notifier).update((state) => a);

                                                                SharedPreferences local=await SharedPreferences.getInstance();
                                                                local.setStringList("wishlist", ref.watch(wishlistItems));
                                                                setState(() {

                                                                });
                                                              },
                                                              child: (wishlist.contains(dishes[index].dishId))?const Icon(CupertinoIcons.heart_fill,color: Colors.red,):const Icon(CupertinoIcons.heart,color: Colors.white,));
                                                        }
                                                    )),
                                              ],
                                            ),
                                            SizedBox(height: height*0.01,),
                                            Text(dishes[index].dishName,style: TextStyle(fontWeight: FontWeight.w400,fontSize: width*0.04,color: Colors.black)),
                                            Padding(
                                              padding:  EdgeInsets.all(width*0.015),
                                              child: Column(children: [
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
                                              ],),
                                            )



                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width*0.03,)
                                  ],
                                );
                              },),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(width*0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dishes",style: TextStyle(fontWeight: FontWeight.w300,fontSize: width*0.05,color: Colors.grey.shade900),),
                          SizedBox(height: height*0.01,),
                          Consumer(
                            builder: (context,ref,child) {
                              final searchText=ref.watch(searchProvider);
                              return ref.watch(getCurrentDishesProvider(searchText)).when(data: (currentDishes) {
                                return SizedBox(
                                  width: width,
                                  child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: currentDishes.length,
                                    itemBuilder:  (context, index) {
                                      return Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: width,
                                          height: height*0.45,
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [

                                                  Container(
                                                    height: height*0.3,
                                                    decoration:BoxDecoration(
                                                        borderRadius: BorderRadius.circular(width*0.015),
                                                        image: DecorationImage(image: NetworkImage(dishes[index].imageUrl),fit: BoxFit.cover)
                                                    ) ,
                                                  ),
                                                  Positioned(
                                                      bottom: width*0.012,
                                                      right: width*0.012,
                                                      child: Consumer(
                                                          builder: (context,ref1,child) {
                                                            final wishlist=ref1.watch(wishlistItems);

                                                            return GestureDetector(
                                                                onTap: () async{
                                                                  List<String> a=ref.watch(wishlistItems);
                                                                  if(ref.watch(wishlistItems).contains(currentDishes[index].dishId)){

                                                                    a.remove(currentDishes[index].dishId);

                                                                  }
                                                                  else{

                                                                    a.add(currentDishes[index].dishId);
                                                                  }
                                                                  ref.read(wishlistItems.notifier).update((state) => a);

                                                                  SharedPreferences local=await SharedPreferences.getInstance();
                                                                  local.setStringList("wishlist", ref.watch(wishlistItems));
                                                                  setState(() {

                                                                  });
                                                                },
                                                                child: (wishlist.contains(currentDishes[index].dishId))?const Icon(CupertinoIcons.heart_fill,color: Colors.red,):const Icon(CupertinoIcons.heart,color: Colors.white,));
                                                          }
                                                      )),
                                                ],
                                              ),
                                              SizedBox(height: height*0.01,),

                                              Text(currentDishes[index].dishName,style: TextStyle(fontWeight: FontWeight.w400,fontSize: width*0.06,color: Colors.black)),

                                              Padding(
                                                padding:  EdgeInsets.all(width*0.03),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(CupertinoIcons.time,size: width*0.05,),
                                                            Column(
                                                              children: [
                                                                Text(" 20 minutes",style: TextStyle(fontSize: width*0.045,color: Colors.black)),

                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Row(

                                                          children: [
                                                            Icon(Icons.circle,color:Colors.green,size: width*0.05,),
                                                            Text(" Vegetarian",style: TextStyle(fontSize: width*0.045,color: Colors.black))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: height*0.01,),
                                                    Row(
                                                      children: List.generate(5, (index) =>  Icon(Icons.star,color: Colors.grey,size:width*0.05, )),
                                                    )
                                                  ],
                                                ),
                                              )



                                            ],
                                          ),
                                        ),
                                      );
                                    },),
                                );
                              }, error: (error, stackTrace) {
                                print(error);
                                return ErrorText(error: error.toString());
                              }, loading: () => const Loader(),);

                            }
                          )
                        ],
                      ),
                    ),
                ],),
              );

            }, error: (error, stackTrace) {
              print(error);
              showSnackBar(context,error.toString());
              return
                ErrorText(error: error.toString());
            }, loading: () =>const Loader() ,);

          }
        ),
      ),
    );
  }
}
