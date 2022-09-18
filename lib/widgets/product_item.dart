import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;
  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imgUrl,
  // );

  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/logo.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          )),
      footer: Container(
        height: 40,
        child: GridTileBar(
          backgroundColor: Colors.black54,
          // leading: Consumer<Product>(
          //   builder: (ctx, product, _) => FavoriteButton(product, authData),
          // ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              cart.addItems(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Product added to cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.removeItem(product.id),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  FavoriteButton(this.product, this.authData);

  Product product;
  Auth authData;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? CircularProgressIndicator(
              color: Theme.of(context).buttonColor,
            )
          : Icon(
              widget.product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Theme.of(context).buttonColor,
            ),
      color: Theme.of(context).buttonColor,
      onPressed: () async {
        setState(() {
          _isLoading = true;
          print(_isLoading);
        });
        await widget.product.toggleFavoriteStatus(
            widget.product.id, widget.authData.token, widget.authData.userId);
        setState(() {
          _isLoading = false;
          print(_isLoading);
        });
      },
    );
  }
}
