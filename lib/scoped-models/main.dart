import 'package:scoped_model/scoped_model.dart';

import './products.dart';
import './connected_products.dart';
import './user.dart';

class MainModel extends Model with ConnectedProducts, ProductsModel, UserModel {

}