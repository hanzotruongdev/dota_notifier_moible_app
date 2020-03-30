import 'package:dota_notifier/components/common.dart';
import 'package:dota_notifier/screens/signup/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota_notifier/screens/login/bloc/login-bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
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
                          SizedBox(
                            height: 10.0,
                          ),
                          MButton(text: "Login", callback: state is! LoginLoading ? _onLoginButtonPressed : null),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              "Create an account",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              //signup screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SignupScreen(),
                              ));
                            },
                          ),
                          SizedBox(height: 35,),  
                          Container(
                            child: state is LoginLoading
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
