class QueryMutation {
  String addUser(String mail, String password) {
    return """
      mutation{
          register(email: "$mail", password: "$password"){
          email
          token
          }
      }
    """;
  }

  String loginUser(String mail, String password){
   return """
      mutation{
          login(email: "$mail", password: "$password"){
          email
          token
          }
      }
    """;
  }
}