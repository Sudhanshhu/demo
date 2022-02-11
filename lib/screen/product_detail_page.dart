import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../const.dart';

class ProductDetailPage extends StatefulWidget {
  static const routeName = '/detailPage';

  const ProductDetailPage({Key? key}) : super(key: key);
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int shoppingCartCount = 0;
  List<String> quantList = ['1', '2', '3', '4', '5'];
  List<Product> similarItem = [];
  late Product prod;
  getsimilarItem(String cat) {
    for (var element in prodList) {
      if (element.category == cat) {
        similarItem.add(element);
      }
    }
    setState(() {
      isfirst = false;
    });
  }

  bool isfirst = true;

  @override
  Widget build(BuildContext context) {
    if (isfirst) {
      prod = ModalRoute.of(context)!.settings.arguments as Product;
      getsimilarItem(prod.category);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(prod.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: prod.imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 20),
              _buildQuant(),
              const SizedBox(height: 20),
              FittedBox(
                child: RatingBarIndicator(
                  rating: double.parse(prod.rate),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 25.0,
                  direction: Axis.horizontal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    '${prod.count} reviews',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDescription(context),
              const SizedBox(height: 20),
              _buildProducts(context),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  Widget _buildQuant() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Quantity', style: Theme.of(context).textTheme.headline6),
        SizedBox(
            width: 60,
            child: dropDownWidget(
                hintText: 2.toString(),
                items: quantList.map((String quantValue) {
                  return DropdownMenuItem<String>(
                    value: quantValue,
                    child: Text(quantValue),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    shoppingCartCount = int.parse(newValue!);
                    // print(shoppingCartCount);
                  });
                })),
      ],
    );
  }

  _buildDescription(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 3.8,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                  text: 'Sold by - ', style: TextStyle(color: Colors.black)),
              TextSpan(text: 'My Shop', style: TextStyle(color: Colors.blue))
            ])),
            const SizedBox(height: 15),
            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Text('Sold by - #${widget.product.shopName}'),
            Text(prod.description
                //"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."),
                ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  _buildProducts(BuildContext context) {
    // print('cat iss ${widget.product.category}');
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: const <Widget>[
              Expanded(
                child: Text(
                  "Similar Items",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: similarItem.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        prod = similarItem[index];
                      });
                    },
                    child: CachedNetworkImage(
                      imageUrl: similarItem[index].imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(similarItem[index].title),
                    subtitle: Text('₹${similarItem[index].price}'),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart)),
                  ),
                );
              }),
        )
        // buildTrending()
      ],
    );
  }
}
