import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitForm, this.isLoading);

  final bool isLoading;

  final void Function(
    String username,
    String password,
    String email,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitForm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // This helps link the validator and onsaved method with final 'onSubmit'
  final _formKey = GlobalKey<FormState>();

  String _userName;
  String _userEmail;
  String _userPassword;
  File _userImage;
  var _isLogin = true;

  void _pickedImage(File userImage) {
    _userImage = userImage;
  }

  void _onSubmit() {
    bool isValid = _formKey.currentState.validate();
    // In case the keyboard is open, it will move the focus away from it and so it will close.
    Focus.of(context).unfocus();

    if (!_isLogin && _userImage == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide profile image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitForm(
        _userName.trim(),
        _userPassword.trim(),
        _userEmail.trim(),
        _userImage,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  key: ValueKey(
                      'email'), //This uniquiley identifies each form feild.
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                if (_isLogin)
                  TextFormField(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    key: ValueKey('username'),
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter atleast 4 characters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must have 7 characters atleast.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _onSubmit,
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'I am already registered.'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
