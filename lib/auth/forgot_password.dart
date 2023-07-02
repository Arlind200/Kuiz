import 'package:Kuiz/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool enabled = true;

  void disable(){
    enabled = false;
    Future.delayed(const Duration(seconds: 60), () => enabled=true,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rivendosja e fjalekalimit'),
        backgroundColor: Colors.lime.shade600,
      ),
      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 400 : 10),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Shkruani nje email valide, dhe rivendosni fjalekalimin tuaj!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
      enabledBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      errorBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(width: 3, color: Colors.red),
      ),
      errorStyle:  TextStyle(color: Colors.black),
      prefixIcon: Icon(
        Icons.email_outlined,
        color: Colors.black,
      ),
      contentPadding:  EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: 'Rivendoseni emailin!',
      border:  OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    if (email!.isEmpty || !email.contains('@')) {
                      return 'Ju lutem, shkruani nje email valid!';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  
style: ElevatedButton.styleFrom(backgroundColor: Colors.white60,fixedSize: Size.fromHeight(55)),     
               onPressed: (){
                if (enabled) {
                  resetPassword();
                  disable();
                 
                }else{  ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Butoni nuk eshte aktiv per 1 minut!')));
                  return;
                }
               },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text(
                      'Rivendoseni fjalekalimin',
                      style: TextStyle(fontSize: 24),
                    ))
              ],
            )),
      ),
    );

   
  }
   Future resetPassword() async {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    }
  }
  
