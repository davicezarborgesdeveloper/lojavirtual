import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual/models/cep_aberto_address.dart';

const token = '2d4d83796dfe8c93d64d080bb6a38934';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromZipCode(String zipCode) async {
    final cleanZipCode = zipCode.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanZipCode";

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);
      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);
      return address;
    } catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
