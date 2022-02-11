import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:demo_project/const.dart';
import 'package:demo_project/model/model.dart';
import 'package:demo_project/screen/product_detail_page.dart';
import 'package:demo_project/screen/setting_page.dart';
import 'package:demo_project/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      routes: {
        ProductDetailPage.routeName: (context) => const ProductDetailPage(),
        SettingPage.routeName: (context) => const SettingPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  _fetchData() async {
    prodList = [];
    final response = await http.get(Uri.https('fakestoreapi.com', 'products'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = jsonDecode(response.body);
      products = [];
      for (int i = 0; i < jsonData.length; i++) {
        Product prods = Product(
          id: jsonData[i]['id'].toString(),
          title: jsonData[i]['title'],
          price: jsonData[i]['price'].toDouble(),
          imageUrl: jsonData[i]['image'],
          description: jsonData[i]['description'],
          category: jsonData[i]['category'],
          count: jsonData[i]['rating']['count'].toString(),
          rate: jsonData[i]['rating']['rate'].toString(),
        );
        products.add(prods);
      }
      prodList = products;
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          ElevatedButton.icon(
            label: const Text('Flag'),
            icon: const Icon(Icons.flag),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const ShowCountry(),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return products.isEmpty
                ? const Center(child: Text('No Data'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridTile(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailPage.routeName,
                              arguments: products[index],
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: products[index].imageUrl,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        // Image.network(products[index].imageUrl),
                        footer: GridTileBar(
                          backgroundColor: Colors.black45,
                          title: Text(products[index].title),
                          subtitle: Text('₹${products[index].price}'),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.shopping_cart)),
                        ),
                      );
                    },
                  );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}

class ShowCountry extends StatefulWidget {
  const ShowCountry({Key? key}) : super(key: key);

  @override
  _ShowCountryState createState() => _ShowCountryState();
}

class _ShowCountryState extends State<ShowCountry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: CountryCodePicker(
              onChanged: print,
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'IT',
              favorite: const ['+39', 'FR'],
              showCountryOnly: true,
              // optional. Shows only country name and flag
              // showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              // showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
          const Text('Click on flag to search your country'),
        ],
      ),
    );
  }
}
