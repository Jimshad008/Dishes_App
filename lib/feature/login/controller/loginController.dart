import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/util.dart';
import '../../home/view/home_page.dart';
import '../repository/login_repository.dart';

import '../view/loginScreen.dart';
final loginControllerProvider=Provider((ref) => LoginController(loginRepository: ref.read(loginRepositoryProvider)));
class LoginController{
  final LoginRepository _loginRepository;
  LoginController({required LoginRepository loginRepository}):_loginRepository=loginRepository;
  loginUser({required String email,required String password,required BuildContext context}) async {
    var res=await _loginRepository.loginUser(email: email, password: password);
    res.fold((l) => showSnackBar(context,l.message), (r) {
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const HomePage(),), (route) => false);
      showSnackBar(context,"Login Successfully");
    } );
  }
  logoutUser({required BuildContext context}) async {
    var res=await _loginRepository.logoutUser();
    res.fold((l) => showSnackBar(context,l.message), (r) {
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginScreen(),), (route) => false);
      showSnackBar(context,"Logout Successfully");
    } );
  }

}