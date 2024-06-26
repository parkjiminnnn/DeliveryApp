import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ItemListNotifier extends ChangeNotifier {
  List<String> _addresses = [
    '인하대,인하공전,정석항공고 인천광역시 미추홀구 인하로 100 수준원점',
    '인천광역시 미추홀구 인하로105번길 43 302호'
  ];

  List<String> get addresses => _addresses;

 String _selectedAddress = '';
  
  String get selectedAddress => _selectedAddress;
  
  void setSelectedAddress(String address) {
    _selectedAddress = address;
    notifyListeners();
  }

  String _addressType = '';
  String get addressType => _addressType;

  String _homeAddress = '우리 집은 목동';
  String get homeAddress => _homeAddress;

  String _workAddress = '우리 학교는 인하공전';
  String get otherAddresses => otherAddresses;

  // String _selectedAddress = '';
  // //String get selectedAddress => _selectedAddress;

  // String selectedAddress = '';

  

  int selectedIndex = -2;
  //변경된 주소 homePage에 반영
  // void updateSelectedAddress(String address) {
  //   selectedAddress = address;
  //   notifyListeners();
  // }

  Future<void> fetchProducts() async {
    //_products = await _productService.fetchProducts();
    notifyListeners();
  }

  void setSelctedAddress(String selectedAddress) {
    _selectedAddress = selectedAddress;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners(); // 변경 사항을 듣고 있는 위젯들에게 알림
  }

  void removeAddress(int index) {
    _addresses.removeAt(index);
    notifyListeners();
  }

  void setHomeAddress(String newAddress) {
    _homeAddress = newAddress;
    notifyListeners();
  }

  void removeHomeAddress() {
    _homeAddress = '';
    notifyListeners();
  }

  void setWorkAddress(String newAddress) {
    _workAddress = newAddress;
    notifyListeners();
  }

  void removeWorkAddress() {
    _workAddress = '';
    notifyListeners();
  }

  void addAddress(String newAddress) {
    addresses.add(newAddress);
    setSelectedIndex(addresses.length - 1);
    notifyListeners();
  }

  void initAddressType() {
    _addressType = '';
    notifyListeners();
  }

  void setAddressType(String addressType) {
    _addressType = addressType;
    notifyListeners();
  }

  // void addItem(Item item) {
  //   _itemList.add(item);
  //   notifyListeners();
  // }

  // void removeItem(Item item) {
  //   _itemList.remove(item);
  //   notifyListeners();
  // }

  // void clearItems() {
  //   _itemList.clear();
  //   notifyListeners();
  // }
}