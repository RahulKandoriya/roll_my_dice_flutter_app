import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_my_dice/alert_dialogs/show_exception_dialog.dart';
import 'package:roll_my_dice/app/sign_in/google_login_button.dart';
import './sign_in_view_model.dart';
import './loading.dart';
import 'package:roll_my_dice/app/top_level_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roll_my_dice/constants/strings.dart';

final signInModelProvider = ChangeNotifierProvider<SignInViewModel>((ref) => SignInViewModel(auth: ref.watch(firebaseAuthProvider)),
);

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final signInModel = watch(signInModelProvider);
    return ProviderListener<SignInViewModel>(
        provider: signInModelProvider,
        onChange: (context, model) async {
          if (model.modelError != null) {
            await showExceptionAlertDialog(
              context: context,
              title: Strings.signInFailed,
              exception: model.modelError,
            );
          }
        },
        child: SignIn( viewModel: signInModel,)
    );
  }
}

class SignIn extends StatefulWidget {

  SignIn(
      {Key key, this.viewModel})
      : super(key: key);
  final SignInViewModel viewModel;


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  SignInViewModel get viewModel => widget.viewModel;

  TextEditingController number = TextEditingController();
  TextEditingController otp = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: viewModel.isLoading ? Loading() : viewModel.isOtpSent ? _verifyOtpPage(context) : _singInPage(context),
      ),
    );
  }

  Widget _singInPage(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox( height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter to Roll My Dice",
              style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
        SizedBox( height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter your 10 digit mobile number",
              style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
        SizedBox( height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox( width: 30,),
            Image.asset(
              "assets/images/india_flag.png",
              height: 20,
              width: 30,
              fit: BoxFit.cover,
            ),
            SizedBox( width: 20,),
            Text("+91",
              style: TextStyle( fontWeight: FontWeight.normal, fontSize: 16),
            ),
            SizedBox( width: 10,),
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: number,
                  validator: (value) => value.length == 10 ? null : 'Number can\'t be less than 10 digits',
                ),
              ),
            ),
            SizedBox( width: 30,),
          ],
        ),
        SizedBox( height: 50,),
        RaisedButton(
            onPressed: (){

              if(_validateAndSaveForm()){
                viewModel.verifyPhoneNumber(context, "+91" + number.text);
              }
            },
            color: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Request OTP",
                style: TextStyle( fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
              ),
            )
        ),
        SizedBox( height: 50,),
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            viewModel.signInWithGoogle();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Tap to Enter',
                    style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox( height: 30,),
        RichText(
            text: TextSpan(children: [
              TextSpan(text: "I have read and agree to "),
              TextSpan(text: "Terms and Conditions ", style: TextStyle(color: Colors.blue.shade900, decoration: TextDecoration.underline,)),
              TextSpan(text: "and "),
              TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.blue.shade900, decoration: TextDecoration.underline,)),
            ], style: TextStyle(fontSize: 12, color: Colors.black))),
      ],
    );
  }

  Widget _verifyOtpPage(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox( height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Sign in to RollMyDice",
              style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
        SizedBox( height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter the 6 digit OTP",
              style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
        SizedBox( height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox( width: 40,),
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  controller: otp,
                  validator: (value) => value.length == 6 ? null : 'OTP can\'t be less than 6 digits',
                ),
              ),
            ),
            SizedBox( width: 40,),
          ],
        ),
        SizedBox( height: 50,),
        RaisedButton(
            onPressed: (){
              if(_validateAndSaveForm()){
                viewModel.verifyOtp(otp.text);
              }
            },
            color: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Verify OTP",
                style: TextStyle( fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
              ),
            )
        ),
      ],
    );
  }

}