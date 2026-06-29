import 'package:dio/dio.dart';
import 'package:latihan_flutter/tugas14flutter/models/product_models.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://dummyjson.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/products')
  Future<ProductModels> getProducts(@Query('limit') int? limit);

  @GET('/products/{id}')
  Future<Product> getProductById(@Path('id') int id);

  @GET('/products/search')
  Future<ProductModels> searchProducts(
    @Query('q') String query,
    @Query('limit') int? limit,
  );
}
