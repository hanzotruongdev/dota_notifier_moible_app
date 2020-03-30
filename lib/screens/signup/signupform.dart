import 'package:dota_notifier/components/common.dart';
import 'package:dota_notifier/screens/signup/bloc/signup-bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupForm extends StatefulWidget {
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onSignupButtonPressed() {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      BlocProvider.of<SignupBloc>(context).add(
        SignupButtonPressed(
          email: _usernameController.text,
          password: _passwordController.text,
          repassword: _repasswordController.text,
        ),
      );
    }

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is SignupInitial) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Your account has been created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {

          return Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 155.0,
                            child: Image.asset(
                              "assets/images/app_icon.png",
                              fit: BoxFit.contain,
                              height: 150,
                              width:  150,
                            ),
                          ),
                          SizedBox(height: 45.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Email",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                              ),
                              controller: _usernameController,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            ),
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Re-type password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            ),
                            controller: _repasswordController,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          MButton(text: "Signup", callback: state is! SignupLoading ? _onSignupButtonPressed : null),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              'Back to Login',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              //signup screen
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: 35,),  
                          Container(
                            child: state is SignupLoading
                                ? CircularProgressIndicator()
                                : null,
                          )
                        ],
                      ),
                  )
                  )
                )
              ),
            );
        },
      ),
    );
  }
}
