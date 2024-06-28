import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/failure.dart';
import '../../../core/type_def.dart';
final loginRepositoryProvider=Provider((ref) => LoginRepository());
class LoginRepository{

  FutureVoid loginUser({required String email,required String password}) async {
    try{


      final SharedPreferences local=await SharedPreferences.getInstance();
        local.setString("email", email);
        return right("");

    }
    catch(e){
     return left(Failure(e.toString()));
    }
  }
  FutureVoid logoutUser() async {
    try{
      final SharedPreferences local=await SharedPreferences.getInstance();
      local.clear();
      return right("");
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

}