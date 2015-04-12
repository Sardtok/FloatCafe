static final int SODA = 1, BEER = 2, COFFEE = 3,
  VANILLA = 1, CHOCOLATE = 2, SOFT_SERVE = 3,
  CHOCOLATE_SAUCE = 1, CARAMEL_SAUCE = 2, WHIPPED_CREAM = 3,
  START_SCREEN = 0, PLAYING = 1, GAME_OVER = 2;
  
ArrayList<Drink> orders = new ArrayList<Drink>();

Drink mixing = new Drink();
Drink currentOrder;
int score;
int step;
int expenses;
int tips;
int income;
int state = START_SCREEN;
int topScore;
int fails;

PImage[] orderIcons, glassLayers, screens;
PImage ui, glass;

boolean oneDown, twoDown, threeDown;


void setup() {
  size(800, 600);
  noSmooth();
}

void draw() {
  
}

void reset() {
  score = 0;
  level = 0;
  state = PLAYING;
  startLevel();
      println("Order: "
      + currentOrder.drink + " "
      + currentOrder.iceCream + " "
      + currentOrder.topping + " ");
}

void createDrinks() {
  tips = 0;
  income = 0;
  expenses = 0;
  step = 0;
  fails = 0;
  for (int drinks = level * 2 + 3; drinks > 0; drinks--) {
    Drink d = new Drink();
    d.drink = (int)random(3) + 1;
    d.iceCream = (int)random(3) + 1;
    d.topping = (int)random(3) + 1;
    orders.add(d);
    currentOrder = d;
  }
}

void levelUp() {
  level++;
  score = bonus() + score();
  createDrinks();
}

int bonus() {
  return (int)(tips * (1.0 / (fails + 1) - 0.25));
}

int score() {
  return score + income + tips - expenses;
}

void next() {
  orders.remove(orders.size() - 1);
  if (orders.isEmpty()) {
    changeState();
    return;
  }
  
  currentOrder = orders.get(orders.size() - 1);
}

void addIngredient(int ingredient) {
  switch(step) {
    case 0: mixing.drink = ingredient; break;
    case 1: mixing.iceCream = ingredient; break;
    case 2: mixing.topping = ingredient; break;
  }
  
  step++;
  if (step == 3) {
    step = 0;
    expenses += 50;
    
    if (mixing.equals(currentOrder)) {
      if (currentOrder.fails == 0) {
        tips += 25;
      }
      
      income += 150;
      println("Drink correct!");
      next();
      
    } else {
      println("You suck!");
      fails++;
      currentOrder.fails++;
      
      if (fails == 3) {
        changeState();
      }
    }
    
    println("Score: " + score());
    println("Orders left: " + orders.size());
    println("Order: "
      + currentOrder.drink + " "
      + currentOrder.iceCream + " "
      + currentOrder.topping + " ");
  } 
}

void changeState() {
  switch(state) {
    case START_SCREEN: reset(); break;
    case PLAYING:
      state = GAME_OVER;
      if (orders.isEmpty()) {
        println("You winz! Final score: " + score());
      } else {
        println("You lose! Final score: " + score());
      }
      topScore = max(score(), topScore);
      break;
    case GAME_OVER: state = START_SCREEN; break;
  }
}

void one() {
  if (oneDown) return;
  
  if (state != PLAYING) {
    changeState();
    return;
  }
  
  oneDown = true;
  addIngredient(1);
}

void two() {
  if (twoDown) return;
  
  if (state != PLAYING) {
    changeState();
    return;
  }
  
  twoDown = true;
  addIngredient(2);
}

void three() {
  if (threeDown) return;
  
  if (state != PLAYING) {
    changeState();
    return;
  }
  
  threeDown = true;
  addIngredient(3);
}

void keyPressed() {
  switch(key) {
    case '1': one(); break;
    case '2': two(); break;
    case '3': three(); break;
  }
}

void keyReleased() {
  switch(key) {
    case '1': oneDown = false; break;
    case '2': twoDown = false; break;
    case '3': threeDown = false; break;
  }
}

