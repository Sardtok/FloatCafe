class Drink {
  int drink, iceCream, topping;
  int fails;
  
  public boolean equals(Object o) {
    Drink d = (Drink) o;
    return drink == d.drink
      && iceCream == d.iceCream
      && topping == d.topping;
  }
}

