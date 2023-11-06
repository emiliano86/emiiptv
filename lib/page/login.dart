

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'Link_page.dart';
 String? users;
final _scaffoldkey=GlobalKey<ScaffoldMessengerState>();

class Login extends StatefulWidget {



  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
 TextEditingController _email=TextEditingController();
 TextEditingController _password=TextEditingController();
 String pref="";

 MaterialApp(){
   scaffoldMessengerKey:_scaffoldkey;
 }
 final ScaffoldMessengerState? _scaffold= _scaffoldkey.currentState;
 String _macAddress = '';
  @override
  void initState(){

    super.initState();


  }

 Future<void> _showRegistrazioneDialog() async {
   return showDialog<void>(
     barrierColor: Colors.transparent,
     context: context,
     barrierDismissible: false, // user must tap button!
     builder: (BuildContext context) {
       return AlertDialog(

         elevation: 10,

         title: const Text('Signup'),

         content:Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children:  [

             TextField(
               scrollController: ScrollController(keepScrollOffset: true,),
               scrollPadding: const EdgeInsets.all(20),
               scrollPhysics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
               textInputAction: TextInputAction.next,
               autofocus: true,


               controller:_email,

               onSubmitted: (e){
                 setState(() {

                 });
               },
               decoration: InputDecoration(
                 labelText: "email",
                 filled: true,
                 fillColor: Colors.white38,
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

               ),
             ),



             const SizedBox(height: 20,),


             TextField(


               textInputAction: TextInputAction.next,
               onSubmitted: (e){
                 setState(() {


                 });
               },

               controller: _password,
               decoration: InputDecoration(
                   labelText: "password",
                   filled: true,
                   fillColor: Colors.white38,
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))

               ),
             ),



           ],
         ),

         actions: [
           Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Back",style: TextStyle(fontWeight: FontWeight.bold),)),
               ElevatedButton(onPressed: ()async{

                 final AuthResponse res = await supabase.auth.signUp(
                   email: _email.text,
                   password: _password.text,
                 );
                 final Session? session = res.session;
                 final User? user = res.user;
                 users=user?.email;
                 Pref.sharedPreferences?.setString("Token",_email.text);

                 Navigator.push(context,
                     MaterialPageRoute(builder: (context) => LoginPage(context)));
               } ,
                   child: Text("Save")),
             ],
           )
         ],

       );
     },
   );
 }






  Widget LoginPage(contex){

    return Scaffold(
        backgroundColor: Colors.transparent,

        body:Container(
          height: 600,
            alignment: Alignment.center,
            child:  Padding(
              padding: const EdgeInsets.all(20),
              child:Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.blueGrey),),
                 const SizedBox(height: 30,),
                 TextField(

                   autofocus: true,
                   controller: _email,
                   scrollController: ScrollController(keepScrollOffset: true,),
                   scrollPadding: const EdgeInsets.all(20),
                   scrollPhysics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                   textInputAction: TextInputAction.next,
                decoration: InputDecoration(

                  labelText: "email",
                  filled: true,
                  fillColor: Colors.white38,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                 ),
                 ),
                const SizedBox(height: 20,),
                TextField(

                  controller: _password,
                  onTapOutside: (event){
                   event.down;
                  },
                  scrollController: ScrollController(keepScrollOffset: true,),
                  scrollPadding: const EdgeInsets.all(20),
                  scrollPhysics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  textInputAction: TextInputAction.next,
                  obscuringCharacter: "*",
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "password",
                    filled: true,
                    fillColor: Colors.white38,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: ()=>_ForgotPassword(), child: const Text("Forgot Password?",style: TextStyle(fontWeight: FontWeight.bold),)),
                      const SizedBox(width: 10,),
                      ElevatedButton(onPressed: ()=>_showRegistrazioneDialog(), child: Text("SignUp")),
                      const SizedBox(width: 30,),
                      ElevatedButton(
                          onPressed:()async{
                            if(!_email.text.contains("@")){
                              ScaffoldMessenger.of(contex).showSnackBar(const SnackBar(content:Text("invalid email",style: TextStyle(color: Colors.white,fontSize: 30), ),));
                            }
                            else if(_email.text=="" || _password.text=="" ){
                              ScaffoldMessenger.of(contex).showSnackBar(const SnackBar(content:Text("invalid email or password!!!",style: TextStyle(color: Colors.white,fontSize: 30), ),));
                            }
                            else if(_email.text!=supabase.auth.currentUser?.email){
                              ScaffoldMessenger.of(contex).showSnackBar(const SnackBar(content:Text("invalid email and password !!!",style: TextStyle(color: Colors.white,fontSize: 30), ),));
                            }


                            final AuthResponse res = await supabase.auth.signInWithPassword(
                              email: _email.text,
                              password: _password.text,
                            );
                            final Session? session = res.session;
                            final User? user = res.user;

                            Pref.sharedPreferences?.setString("Token",_email.text);





                            Navigator.push(contex,
                                MaterialPageRoute(builder: (context) => LinkPage()));
                          },
                          child: Text("Sign In")),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(

                        child: GestureDetector(
                          onTap: ()async{

                         await supabase.auth.signInWithOAuth(Provider.google);
                            final Session? session = supabase.auth.currentSession;
                            final String? oAuthToken = session?.providerToken;
                         Pref.sharedPreferences?.setString("Token",oAuthToken!);
                            users=oAuthToken;


                            Navigator.push(contex,
                                MaterialPageRoute(builder: (context) => LinkPage()));
                          },
                          child:  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
              child:SvgPicture.asset("assets/google.svg",width: 40,height: 40),
            ),),
                        ),
                     Expanded(

                       child:  GestureDetector(
                         onTap: ()async{
                           await supabase.auth.signInWithOAuth(Provider.facebook);
                           final Session? session = supabase.auth.currentSession;
                           final String? oAuthToken = session?.providerToken;
                           Pref.sharedPreferences?.setString("Token",oAuthToken!);
                           Navigator.push(contex,
                               MaterialPageRoute(builder: (context) => LinkPage()));
                         },
                         child: ClipRRect(
                           
                           borderRadius: BorderRadius.circular(5),
                           child:SvgPicture.asset("assets/facebook.svg",width: 40,height: 40),
                         ),
                       )),
                      Expanded(

                        child:  GestureDetector(
                          onTap: ()async{
                            await supabase.auth.signInWithOAuth(Provider.apple);
                            final Session? session = supabase.auth.currentSession;
                            final String? oAuthToken = session?.providerToken;
                            Pref.sharedPreferences?.setString("Token",oAuthToken!);
                            Navigator.push(contex,
                                MaterialPageRoute(builder: (context) => LinkPage()));
                          },
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child:SvgPicture.asset("assets/apple.svg",width: 40,height: 40,color: Colors.white,),
                          ),
                        )),
                    ],
                  ),


                ],
              ),
            )
        )

    );
  }




  @override
  Widget build(BuildContext context) {
   String? token=Pref.sharedPreferences?.getString("Token");
     if(token==null){
       return LoginPage(context);
     }else{
       return LinkPage();
     }















  }

 Future<void> _ForgotPassword() async {
   return showDialog<void>(
     barrierColor: Colors.transparent,
     context: context,
     barrierDismissible: false, // user must tap button!
     builder: (BuildContext context) {
       return AlertDialog(

         elevation: 10,

         title: const Text('Change Password'),

         content:Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children:  [

             TextField(
               scrollController: ScrollController(keepScrollOffset: true,),
               scrollPadding: const EdgeInsets.all(20),
               scrollPhysics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
               textInputAction: TextInputAction.next,
               autofocus: true,


               controller:_email,

               onSubmitted: (e){
                 setState(() {

                 });
               },
               decoration: InputDecoration(
                 labelText: "email",
                 filled: true,
                 fillColor: Colors.white38,
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

               ),
             ),



             const SizedBox(height: 20,),


             TextField(


               textInputAction: TextInputAction.next,
               onSubmitted: (e){
                 setState(() {


                 });
               },

               controller: _password,
               decoration: InputDecoration(
                   labelText: "new password",
                   filled: true,
                   fillColor: Colors.white38,
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))

               ),
             ),



           ],
         ),

         actions: [
           Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Back",style: TextStyle(fontWeight: FontWeight.bold),)),
               ElevatedButton(onPressed: ()async{
                 

                 final UserResponse res = await supabase.auth.updateUser(
                   UserAttributes(
                     email:_email.text,
                     password: _password.text
                   ),
                   emailRedirectTo: _email.text,
                 );
                 final User? updatedUser = res.user;
           

               
                 Navigator.push(context,
                     MaterialPageRoute(builder: (context) => LoginPage(context)));
               } ,
                   child: Text("Save")),
             ],
           )
         ],

       );
     },
   );
 }
}
