// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginAdmin() async {
    final response = await http.post(
      Uri.parse('http://45.87.173.50:3000/admin-login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProductManagementPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin girişi başarısız.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Admin Password',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                loginAdmin();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();
  final TextEditingController _productSizesController = TextEditingController();
  final TextEditingController _productStarsController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  List<Map<String, dynamic>> products = [];

  Future<void> addProduct() async {
    final response = await http.post(
      Uri.parse('http://45.87.173.50:3000/add-product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': _productNameController.text,
        'image': _productImageController.text,
        'description': _productDescriptionController.text,
        'stock': _productStockController.text,
        'category': _productCategoryController.text,
        'sizes': _productSizesController.text,
        'stars': _productStarsController.text,
        'price': _productPriceController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla eklendi.')),
      );
      _productNameController.clear();
      _productImageController.clear();
      _productDescriptionController.clear();
      _productStockController.clear();
      _productCategoryController.clear();
      _productSizesController.clear();
      _productStarsController.clear();
      _productPriceController.clear();
      getProducts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün eklenirken bir hata oluştu.')),
      );
    }
  }

  Future<void> getProducts() async {
    final response = await http.get(
      Uri.parse('http://45.87.173.50:3000/get-products'),
    );

    if (response.statusCode == 200) {
      setState(() {
        products = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürünler alınırken bir hata oluştu.')),
      );
    }
  }

  Future<void> deleteProduct(String productName) async {
    final response = await http.delete(
      Uri.parse('http://45.87.173.50:3000/delete-product/$productName'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla silindi.')),
      );
      getProducts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün silinirken bir hata oluştu.')),
      );
    }
  }

  Future<void> updateProduct(String productName) async {
    // API'den mevcut ürün bilgilerini al
    final existingProduct = products.firstWhere(
      (product) => product['name'] == productName,
      orElse: () => <String, dynamic>{},
    );

    if (existingProduct.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün bilgileri bulunamadı.')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ürün Düzenleme'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Mevcut Bilgiler:'),
                Text('Name: ${existingProduct['name']}'),
                Text('Image: ${existingProduct['image']}'),
                Text('Description: ${existingProduct['description']}'),
                Text('Stock: ${existingProduct['stock']}'),
                Text('Category: ${existingProduct['category']}'),
                Text('Sizes: ${existingProduct['sizes']}'),
                Text('Stars: ${existingProduct['stars']}'),
                Text('Price: ${existingProduct['price']}'),
                const SizedBox(height: 16),
                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                  ),
                ),
                TextField(
                  controller: _productImageController,
                  decoration: const InputDecoration(
                    labelText: 'Product Image',
                  ),
                ),
                TextField(
                  controller: _productDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                  ),
                ),
                TextField(
                  controller: _productStockController,
                  decoration: const InputDecoration(
                    labelText: 'Product Stock',
                  ),
                ),
                TextField(
                  controller: _productCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Product Category',
                  ),
                ),
                TextField(
                  controller: _productSizesController,
                  decoration: const InputDecoration(
                    labelText: 'Product Sizes',
                  ),
                ),
                TextField(
                  controller: _productStarsController,
                  decoration: const InputDecoration(
                    labelText: 'Product Stars',
                  ),
                ),
                TextField(
                  controller: _productPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Product Price',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                final updatedProduct = {
                  'name': _productNameController.text,
                  'image': _productImageController.text,
                  'description': _productDescriptionController.text,
                  'stock': _productStockController.text,
                  'category': _productCategoryController.text,
                  'sizes': _productSizesController.text,
                  'stars': _productStarsController.text,
                  'price': _productPriceController.text,
                };

                if (_areFieldsValid(updatedProduct)) {
                  await _performUpdate(existingProduct['name'], updatedProduct);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen tüm alanları doldurun.'),
                    ),
                  );
                }
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  bool _areFieldsValid(Map<String, dynamic> product) {
    return true;
  }

  Future<void> _performUpdate(
      String productName, Map<String, dynamic> updatedProduct) async {
    // Ürün güncelleme işlemini gerçekleştir
    final response = await http.put(
      Uri.parse('http://45.87.173.50:3000/update-product/$productName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedProduct),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla güncellendi.')),
      );
      _productNameController.clear();
      _productImageController.clear();
      _productDescriptionController.clear();
      _productStockController.clear();
      _productCategoryController.clear();
      _productSizesController.clear();
      _productStarsController.clear();
      _productPriceController.clear();
      getProducts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün güncellenirken bir hata oluştu.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ürün Ekleme Formu
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            TextField(
              controller: _productImageController,
              decoration: const InputDecoration(
                labelText: 'Product Image',
              ),
            ),
            TextField(
              controller: _productDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Product Description',
              ),
            ),
            TextField(
              controller: _productStockController,
              decoration: const InputDecoration(
                labelText: 'Product Stock',
              ),
            ),
            TextField(
              controller: _productCategoryController,
              decoration: const InputDecoration(
                labelText: 'Product Category',
              ),
            ),
            TextField(
              controller: _productSizesController,
              decoration: const InputDecoration(
                labelText: 'Product Sizes',
              ),
            ),
            TextField(
              controller: _productStarsController,
              decoration: const InputDecoration(
                labelText: 'Product Stars',
              ),
            ),
            TextField(
              controller: _productPriceController,
              decoration: const InputDecoration(
                labelText: 'Product Price',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addProduct();
              },
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 32),
            // Ürün Listesi
            const Text(
              'Product List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Text(
                          '${product['description']}\nStock: ${product['stock']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              updateProduct(product['name']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteProduct(product['name']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
