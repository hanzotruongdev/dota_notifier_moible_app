

      
bool validateEmail(String email) {
  if (email == ""){
    throw "Email is empty!";
  }

  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  if (!emailValid){
    throw "Email isn't correct!";
  }

  return true;
}