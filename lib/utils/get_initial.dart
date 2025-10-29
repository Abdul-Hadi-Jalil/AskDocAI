// this file is used to get the initial letter of the name of user to show in circle avatar

String getInitial(String? name) {
  if (name == null || name.isEmpty) {
    return '?';
  } else {
    return name[0].toUpperCase();
  }
}
