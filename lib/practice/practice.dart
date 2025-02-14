abstract class Animal {
  void speak();
  void eat() {
    print('Animal is eating');
  }
}

class Dog extends Animal {
  @override
  void speak() {
    print('Woof');
  }
}

class SilentDog extends Dog {

}