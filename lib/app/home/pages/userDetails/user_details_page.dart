import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_my_dice/alert_dialogs/show_exception_dialog.dart';
import 'package:roll_my_dice/models/appUser.dart';
import 'package:roll_my_dice/app/top_level_providers.dart';
import 'package:roll_my_dice/routing/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedantic/pedantic.dart';


class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key key, this.appUser}) : super(key: key);
  final AppUser appUser;

  static Future<void> show(BuildContext context, {AppUser appUser}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.userDetailsPage,
      arguments: appUser,
    );
  }

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _score;
  int _numberOfAttempts;
  int _maxScore;
  int _maxAttempts;
  String _phoneNumber;
  String _email;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (widget.appUser != null) {
      _name = widget.appUser.name;
      _phoneNumber = widget.appUser.phoneNumber;
      _email = widget.appUser.email;
      _score = widget.appUser.score;
      _numberOfAttempts = widget.appUser.numberOfAttempts;
      _maxScore = widget.appUser.maximumScore;
      _maxAttempts = widget.appUser.maximumAttempts;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = context.read(databaseProvider);
        final id = auth.currentUser.uid;
        final phoneNumber  = auth.currentUser.phoneNumber;
        final email  = auth.currentUser.email;
        final appUser = AppUser( id: id, name: _name, phoneNumber: phoneNumber, email: email, score: _score, numberOfAttempts: _numberOfAttempts, maximumScore: _maxScore, maximumAttempts: _maxAttempts);
        await database.setUserDetails(appUser);
        Navigator.of(context).pop();
      } catch (e) {
        unawaited(showExceptionAlertDialog(
          context: context,
          title: 'Operation failed',
          exception: e,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.appUser.name == null ? 'Add User Details' : 'Edit User Details'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildContents(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                    onPressed: () => _submit(),
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text( widget.appUser.name ==  null ? "Add User Details" : "Edit User details",
                        style: TextStyle( fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
                      ),
                    )
                ),
                SizedBox( height: 90,)
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'User name'),
        keyboardAppearance: Brightness.light,
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      SizedBox( height: 10,),
      Text("Phone Number",
        style: TextStyle( color: Colors.grey, fontSize: 12),
      ),
      Text(_phoneNumber,
        style: TextStyle( color: Colors.grey, fontSize: 18),
      ),
      SizedBox( height: 10,),
      Text("Email",
        style: TextStyle( color: Colors.grey, fontSize: 12),
      ),
      Text(_email,
        style: TextStyle( color: Colors.grey, fontSize: 18),
      ),
    ];
  }
}
