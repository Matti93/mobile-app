class User {
  User(this.mail, this.password);

  final String mail;
  final String password;

  getPassword() => this.password;

  getMail() => this.mail;
}