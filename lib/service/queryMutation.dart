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

  //CHANGE REGISTER API
  // NEW MUTATION
  //   mutation{
  //   register(
  //     email:"matias@matias.com",
  //     password: "Matias123",
  //     firstNme: "Matias",
  //     lastNme: "Blanco"
  //   ){
  //   email
  //   token
  //   firstNme
  //   lastNme
  //   }
  // }

  String loginUser(String mail, String password) {
    return """
      query{
        login(
          email:"$mail",
  	      password:"$password"
        ){
          email
          token
        }
      }  
    """;
  }

  String relatitonsTyps(String mail, String password) {
    return """
      mutation{
        login(
          email:"$mail",
          password: "$password"
      )
      {
        token
        email
      }
    }
    """;
  }
}
