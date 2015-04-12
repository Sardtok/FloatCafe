static final int SODA = 1, BEER = 2, COFFEE = 3, 
VANILLA = 4, CHOCOLATE = 5, SOFT_SERVE = 6, 
CHOCOLATE_SAUCE = 7, CARAMEL_SAUCE = 8, WHIPPED_CREAM = 9, 
START_SCREEN = 0, PLAYING = 1, GAME_OVER = 2, 
ORDER_SCREEN = 1, DRINK_SCREEN = 2, ICE_CREAM_SCREEN = 3, 
TOPPING_SCREEN = 4, FAIL_SCREEN = 5, SUCCESS_SCREEN = 6, 
LEVEL_UP_SCREEN = 7, GAME_OVER_SCREEN = 8;

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
int level;
int screen = 0;
int screenTime;

PImage[] orderIcons = new PImage[10], glassLayers = new PImage[10], screens = new PImage[9];

boolean oneDown, twoDown, threeDown;

float SCALE;

void setup() {
  SCALE = min(displayWidth / 420.0, displayHeight / 240.0); 
  size(displayWidth, displayHeight);
  noSmooth();
  screens[START_SCREEN] = loadImage("data/start.png");
  screens[ORDER_SCREEN] = loadImage("data/order.png");
  screens[DRINK_SCREEN] = loadImage("data/drink.png");
  screens[ICE_CREAM_SCREEN] = loadImage("data/ice_cream.png");
  screens[TOPPING_SCREEN] = loadImage("data/topping.png");
  screens[SUCCESS_SCREEN] = loadImage("data/serve_success.png");
  screens[FAIL_SCREEN] = loadImage("data/serve_fail.png");
  screens[GAME_OVER_SCREEN] = loadImage("data/game_over.png");
  screens[LEVEL_UP_SCREEN] = loadImage("data/level_complete.png");
  
  glassLayers[0] = loadImage("data/glass.png");
  glassLayers[SODA] = loadImage("data/cola.png");
  glassLayers[COFFEE] = loadImage("data/coffee.png");
  glassLayers[BEER] = loadImage("data/beer.png");
  glassLayers[VANILLA] = loadImage("data/vanilla.png");
  glassLayers[CHOCOLATE] = loadImage("data/chocolate.png");
  glassLayers[SOFT_SERVE] = loadImage("data/softserve.png");
  glassLayers[CARAMEL_SAUCE] = loadImage("data/caramel_sauce.png");
  glassLayers[CHOCOLATE_SAUCE] = loadImage("data/chocolate_sauce.png");
  glassLayers[WHIPPED_CREAM] = loadImage("data/whip.png");
  
  orderIcons[SODA] = loadImage("data/colaIcon.png");
  orderIcons[BEER] = loadImage("data/beerIcon.png");
  orderIcons[COFFEE] = loadImage("data/coffeeIcon.png");
  orderIcons[VANILLA] = loadImage("data/colaIcon.png");
  orderIcons[CHOCOLATE] = loadImage("data/beerIcon.png");
  orderIcons[SOFT_SERVE] = loadImage("data/coffeeIcon.png");
  orderIcons[CARAMEL_SAUCE] = loadImage("data/colaIcon.png");
  orderIcons[CHOCOLATE_SAUCE] = loadImage("data/beerIcon.png");
  orderIcons[WHIPPED_CREAM] = loadImage("data/coffeeIcon.png");
}

void draw() {
  background(0);
  scale(SCALE, SCALE);
  switch(state) {
  case START_SCREEN: 
    image(screens[START_SCREEN], 0, 0); 
    break;
  case PLAYING: 
    drawScreen(); 
    break;
  case GAME_OVER: 
    drawGameOver(); 
    break;
  }
  
  fill(#ff0000);
  stroke(#ff0000);
}

void drawScreen() {
  switch(screen) {
  case ORDER_SCREEN:
  case FAIL_SCREEN:
    text(currentOrder.drink + " " + currentOrder.iceCream + " " + currentOrder.topping, 100, 25);
  case SUCCESS_SCREEN:
  case LEVEL_UP_SCREEN:
    image(screens[screen], 0, 0);
    screenTime--;
    if (screenTime == 0) {
      if (screen == SUCCESS_SCREEN) {
        screenTime =  320 / (level + 1);
        screen = ORDER_SCREEN;
      } else {
        screen = DRINK_SCREEN;
      }
    }
  default:
    drawDrink();
    image(screens[screen], 0, 0);
    break;
  }
}

void drawDrink() {
  if (state != PLAYING) return;
  
  if (step > 0 || screen == FAIL_SCREEN || screen == SUCCESS_SCREEN)
    image(glassLayers[mixing.drink], 320, 0);
  if (step > 1 || screen == FAIL_SCREEN || screen == SUCCESS_SCREEN)
    image(glassLayers[mixing.iceCream + 3], 320, 0);
  if (screen == FAIL_SCREEN || screen == SUCCESS_SCREEN)
    image(glassLayers[mixing.topping + 6], 320, 0);
  image(glassLayers[0], 320, 0);
}

void drawGameOver() {
  image(screens[GAME_OVER_SCREEN], 0, 0);
}

void reset() {
  score = 0;
  level = 0;
  state = PLAYING;
  createDrinks();
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
  screenTime = 320 / (level + 1);
  screen = ORDER_SCREEN;
  Drink d = null;
  for (int drinks = level * 2 + 3; drinks > 0; drinks--) {
    d = new Drink();
    d.drink = (int)random(3) + 1;
    d.iceCream = (int)random(3) + 1;
    d.topping = (int)random(3) + 1;
    orders.add(d);
  }
  currentOrder = d;
}

void levelUp() {
  level++;
  score = bonus() + score();
  screen = LEVEL_UP_SCREEN;
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
    levelUp();
    return;
  }

  currentOrder = orders.get(orders.size() - 1);
  screenTime = 320 / (level + 1);
  screen = SUCCESS_SCREEN;
}

void addIngredient(int ingredient) {
  if (screen < DRINK_SCREEN || screen > TOPPING_SCREEN)
    return;
  switch(step) {
  case 0: 
    mixing.drink = ingredient; 
    break;
  case 1: 
    mixing.iceCream = ingredient; 
    break;
  case 2: 
    mixing.topping = ingredient; 
    break;
  }

  step++;
  screen++;
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
      screen = FAIL_SCREEN;
      screenTime =  320 / (level + 1);

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
  case START_SCREEN: 
    reset(); 
    break;
  case PLAYING:
    state = GAME_OVER;
    if (orders.isEmpty()) {
      println("You winz! Final score: " + score());
    } else {
      println("You lose! Final score: " + score());
    }
    topScore = max(score(), topScore);
    break;
  case GAME_OVER: 
    state = START_SCREEN; 
    break;
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
  case '1': 
    one(); 
    break;
  case '2': 
    two(); 
    break;
  case '3': 
    three(); 
    break;
  }
}

void keyReleased() {
  switch(key) {
  case '1': 
    oneDown = false; 
    break;
  case '2': 
    twoDown = false; 
    break;
  case '3': 
    threeDown = false; 
    break;
  }
}

