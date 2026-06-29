import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas14flutter/models/product_models.dart';
import 'package:latihan_flutter/tugas14flutter/services/api_services.dart';
import 'package:latihan_flutter/tugas14flutter/services/dio_client.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetail extends StatefulWidget {
  final int productId;

  const ProductDetail({super.key, required this.productId});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late final ApiService _apiService;
  late Future<Product> _productFuture;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiService = ApiService(dio);
    _productFuture = _apiService.getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Failed to load product"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }
          final product = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        //gambar (slider)
                        PageView.builder(
                          itemCount: product.images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: product.images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(color: Colors.white),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.broken_image);
                              },
                            );
                          },
                        ),

                        //indicator image
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${_currentImageIndex + 1}/${product.images.length}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(
                        product.title,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      //price
                      Text(
                        "\$ ${product.price}",
                        style: TextStyle(
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      //rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //category, brand, stock, avail
                      Row(
                        children: [
                          Text(
                            "Category: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.category),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Brand: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.brand ?? "-"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Stock: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.stock.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Availability: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(product.availabilityStatus),
                        ],
                      ),
                      SizedBox(height: 20),

                      //description
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(product.description, textAlign: TextAlign.justify),
                      SizedBox(height: 20),

                      //additional information
                      Text(
                        "Additional Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text("Weight: ${product.weight}"),
                      Text("Width: ${product.dimensions.width}"),
                      Text("Height: ${product.dimensions.height}"),
                      Text("Depth: ${product.dimensions.depth}"),
                      Text(
                        "Minimum Order Quantity: ${product.minimumOrderQuantity}",
                      ),
                      SizedBox(height: 20),

                      //shipping information
                      Text(
                        "Shipping Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(product.shippingInformation),
                      SizedBox(height: 20),

                      //warranty information
                      Text(
                        "Warranty Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(product.warrantyInformation),
                      SizedBox(height: 20),

                      //return policy
                      Text(
                        "Return Policy",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(product.returnPolicy),
                      SizedBox(height: 20),

                      //reviews
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: List.generate(product.reviews.length, (
                            index,
                          ) {
                            final review = product.reviews[index];
                            return Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(0),
                                  shadowColor: Colors.black.withValues(
                                    alpha: 0.3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //reviewerName
                                        Text(
                                          review.reviewerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        //date
                                        Text(
                                          review.date.toString().split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        //rating
                                        Row(
                                          //icon star dilooping sebanyak int rating
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              Icons.star,
                                              size: 16,
                                              color: index < review.rating
                                                  ? Colors.amber
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        //comment
                                        Text(review.comment),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
