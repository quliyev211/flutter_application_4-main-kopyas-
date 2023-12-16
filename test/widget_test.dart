import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Listesi'),
      ),
      body: ListView.builder(
        itemCount: 10, // Örnek olarak 10 ürün
        itemBuilder: (context, index) {
          return ProductListItem(productName: 'Ürün $index');
        },
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final String productName;

  const ProductListItem({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(productName),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productName: productName),
          ),
        );
      },
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String productName;

  const ProductDetailScreen({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: const Center(
        child: Text('Detaylar burada gösterilecek.'),
      ),
    );
  }
}
