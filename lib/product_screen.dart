import 'package:database_app/product.dart';
import 'package:database_app/product_db_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  List<Product> productsList = List<Product>();

  final dbHelper = ProductDBHelper.instance;

  @override
  void initState(){
    super.initState();
    dbHelper.getProductsList().then((value){
       setState(() {
         productsList = value;
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: productsList.length,
                    itemBuilder: (context, index) {
                      if (productsList.length > 0) {
                        return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                 ),
                               ],
                             ),
                      child: ListTile(
                      /// tile icon
                         leading: Icon(Icons.account_balance_wallet,color: Colors.black,),
                      //// product name
                      title: Text(productsList[index].name,style: TextStyle(
                      fontSize: 18, color: Colors.black
                      ),),
                      ////// product price
                      subtitle: Text('Price LKR : ${productsList[index].price}',style: TextStyle(
                           fontSize: 18,
                           color: Colors.black
                      ),),
                       /* trailing: Container(
                          width: 100,
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              /////// Edit Button
                              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                              IconButton(
                                icon: Icon(Icons.delete), onPressed: () {})

                            ],
                          ),
                        ),*/
                      ),
                      ),
                        );
                      } else {
                        return Container();
                      }
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showProductDialogBox(context);
        },
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white,),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  showProductDialogBox(BuildContext context)
  {
    Widget saveButton = FlatButton(onPressed: () async {
      if(_nameController.text.isNotEmpty && _priceController.text.isNotEmpty
       && _quantityController.text.isNotEmpty) {
        Product product = Product();
        product.name = _nameController.text;
        product.price = _priceController.text;
        product.quantity = int.parse(_quantityController.text);

        dbHelper.insertProduct(product).then((value) {
          dbHelper.getProductsList().then((value) {
            setState(() {
              productsList = value;
            });
          });
        });
        emptyTextFields();

        Navigator.pop(context);
      }
    }, child: Text('Save'));
    Widget cancelButton = FlatButton(onPressed: () {
      Navigator.pop(context);
    }, child: Text('Cancel'));
    AlertDialog productAlertDialog = AlertDialog(
      title: Text('Add new product'),
      content: Container(
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Product Name'
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Product Price'
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Product Quantity'
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton,
      ],
    );
    showDialog(context: context, builder: (BuildContext context) {
      return productAlertDialog;
    });
  }
  void emptyTextFields() {
    _nameController.text = '';
    _priceController.text = '';
    _quantityController.text = '';
  }
}