import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutter/extension/navigator.dart';
import 'package:latihan_flutter/tugas14flutter/models/product_models.dart';
import 'package:latihan_flutter/tugas14flutter/services/api_services.dart';
import 'package:latihan_flutter/tugas14flutter/services/dio_client.dart';
import 'package:latihan_flutter/tugas14flutter/views/product_detail.dart';
import 'package:shimmer/shimmer.dart';

class DummyJsonProducts extends StatefulWidget {
  const DummyJsonProducts({super.key});

  @override
  State<DummyJsonProducts> createState() => _DummyJsonProductsState();
}

class _DummyJsonProductsState extends State<DummyJsonProducts> {
  late final ApiService _apiService;
  List<Product> _productList = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isSearching = false;
  int limit = 10;
  int _totalProducts = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;
  //var go to top
  final ScrollController _scrollController = ScrollController();
  bool _showGoTop = false;

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = _searchQuery.isEmpty
          ? await _apiService.getProducts(10)
          : await _apiService.searchProducts(_searchQuery, 10);

      setState(() {
        _productList = response.products;
        _totalProducts = response.total;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load products.")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newLimit = limit + 10;
      final response = _searchQuery.isEmpty
          ? await _apiService.getProducts(newLimit)
          : await _apiService.searchProducts(_searchQuery, newLimit);

      setState(() {
        limit = newLimit;
        _productList = response.products;
        _totalProducts = response.total;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load products.")));
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final response = await _apiService.searchProducts(query, limit);

      setState(() {
        _searchQuery = query;
        _productList = response.products;
        _totalProducts = response.total;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load products.")));
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  //getter sudah menampilkan semua product
  bool get _hasLoadedAllProducts => _productList.length >= _totalProducts;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiService = ApiService(dio);
    _loadProducts();

    //go to top
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showGoTop) {
        setState(() {
          _showGoTop = true;
        });
      } else if (_scrollController.offset <= 300 && _showGoTop) {
        setState(() {
          _showGoTop = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 1,
      ),

      floatingActionButton: _showGoTop
          ? FloatingActionButton.small(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: ListView(
                controller: _scrollController,
                children: [
                  //search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : (_searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = "";
                                          limit = 10;
                                        });
                                        _loadProducts();
                                      },
                                    )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _debounce?.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 400),
                          () {
                            setState(() {
                              _searchQuery = value;
                              limit = 10;
                            });

                            if (value.isEmpty) {
                              _loadProducts();
                            } else {
                              _searchProducts(value);
                            }
                          },
                        );
                      },
                    ),
                  ),

                  //handling data kosong
                  if (_productList.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? "No products available"
                              : "No products found for \"$_searchQuery\"",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else ...[
                    //gridview product
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                          ),
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                        bottom: 12,
                      ),
                      itemCount: _productList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final product = _productList[index];
                        return InkWell(
                          onTap: () {
                            context.push(ProductDetail(productId: product.id));
                          },
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.black.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //thumbnail
                                  SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: product.thumbnail,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),

                                  //product title
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),

                                  //price
                                  Text(
                                    "\$ ${product.price.toString()}",
                                    style: TextStyle(
                                      color: const Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),

                                  //rating
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        product.rating.toString(),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    //load more
                    if (_hasLoadedAllProducts)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            "All products loaded.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: _isLoadingMore ? null : _loadMore,
                        child: _isLoadingMore
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Load more",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}
