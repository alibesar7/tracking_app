// import 'package:json_annotation/json_annotation.dart';
// import 'package:tracking_app/features/auth/data/models/response/metadata_model.dart';

// part 'my_order_response.g.dart';

// @JsonSerializable()
// class MyOrderResponse {
//   @JsonKey(name: "message")
//   final String? message;
//   @JsonKey(name: "metadata")
//   final Metadata? metadata;
//   @JsonKey(name: "orders")
//   final List<Orders>? orders;

//   MyOrderResponse({this.message, this.metadata, this.orders});

//   factory MyOrderResponse.fromJson(Map<String, dynamic> json) {
//     return _$MyOrderResponseFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$MyOrderResponseToJson(this);
//   }
// }

// @JsonSerializable()
// class Order {
//   @JsonKey(name: "_id")
//   final String? Id;
//   @JsonKey(name: "user")
//   final User? user;
//   @JsonKey(name: "orderItems")
//   final List<OrderItems>? orderItems;
//   @JsonKey(name: "totalPrice")
//   final int? totalPrice;
//   @JsonKey(name: "paymentType")
//   final String? paymentType;
//   @JsonKey(name: "isPaid")
//   final bool? isPaid;
//   @JsonKey(name: "isDelivered")
//   final bool? isDelivered;
//   @JsonKey(name: "state")
//   final String? state;
//   @JsonKey(name: "createdAt")
//   final String? createdAt;
//   @JsonKey(name: "updatedAt")
//   final String? updatedAt;
//   @JsonKey(name: "orderNumber")
//   final String? orderNumber;
//   @JsonKey(name: "__v")
//   final int? _V;

//   Order({
//     this.Id,
//     this.user,
//     this.orderItems,
//     this.totalPrice,
//     this.paymentType,
//     this.isPaid,
//     this.isDelivered,
//     this.state,
//     this.createdAt,
//     this.updatedAt,
//     this.orderNumber,
//     this._V,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return _$OrderFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$OrderToJson(this);
//   }
// }

// @JsonSerializable()
// class User {
//   @JsonKey(name: "_id")
//   final String? Id;
//   @JsonKey(name: "firstName")
//   final String? firstName;
//   @JsonKey(name: "lastName")
//   final String? lastName;
//   @JsonKey(name: "email")
//   final String? email;
//   @JsonKey(name: "gender")
//   final String? gender;
//   @JsonKey(name: "phone")
//   final String? phone;
//   @JsonKey(name: "photo")
//   final String? photo;
//   @JsonKey(name: "passwordChangedAt")
//   final String? passwordChangedAt;

//   User({
//     this.Id,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.gender,
//     this.phone,
//     this.photo,
//     this.passwordChangedAt,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return _$UserFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$UserToJson(this);
//   }
// }

// @JsonSerializable()
// class OrderItems {
//   @JsonKey(name: "product")
//   final Product? product;
//   @JsonKey(name: "price")
//   final int? price;
//   @JsonKey(name: "quantity")
//   final int? quantity;
//   @JsonKey(name: "_id")
//   final String? Id;

//   OrderItems({this.product, this.price, this.quantity, this.Id});

//   factory OrderItems.fromJson(Map<String, dynamic> json) {
//     return _$OrderItemsFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$OrderItemsToJson(this);
//   }
// }

// @JsonSerializable()
// class Product {
//   @JsonKey(name: "_id")
//   final String? Id;
//   @JsonKey(name: "price")
//   final int? price;

//   Product({this.Id, this.price});

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return _$ProductFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$ProductToJson(this);
//   }
// }

// @JsonSerializable()
// class Store {
//   @JsonKey(name: "name")
//   final String? name;
//   @JsonKey(name: "image")
//   final String? image;
//   @JsonKey(name: "address")
//   final String? address;
//   @JsonKey(name: "phoneNumber")
//   final String? phoneNumber;
//   @JsonKey(name: "latLong")
//   final String? latLong;

//   Store({this.name, this.image, this.address, this.phoneNumber, this.latLong});

//   factory Store.fromJson(Map<String, dynamic> json) {
//     return _$StoreFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$StoreToJson(this);
//   }
// }
