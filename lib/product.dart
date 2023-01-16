class Product {

   int id;
   String name;
   String price;
   int quantity;

   ////// Map -> Product Object
  Product({ this.id,  this.name, this.price, this.quantity});
  static Product fromMap(Map<String , dynamic> query)
  {
    Product product = Product();
    product.id = query['id'];
    product.name = query['name'];
    product.price = query['price'];
    product.quantity = query['quantity'];
    return product;
  }

   /////// Product -> Map
   static Map<String, dynamic> toMap(Product product) {
     return <String, dynamic>{
       'id': product.id,
       'name' : product.name,
       'price' : product.price ,
       'quantity' : product.quantity
     };
   }

   /////// List of Maps -> List of object
   static List<Product> toList(List<Map<String,dynamic>> query) {
     List<Product> products = List<Product>();
     for (Map map in query) {
       products.add(fromMap(map));
     }
     return products;
   }

}