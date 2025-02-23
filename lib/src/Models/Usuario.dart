typedef Usuario = (String email, String senha);

Map<String, dynamic> toJson(Usuario login) {
  return {'email': login.$1, 'senha': login.$2};
}
