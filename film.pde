Film[] films;
Film[] filmsSorted;
boolean isSorted;

void setup() {
  size(600, 500);
  JSONArray filmArray = loadJSONArray("films.json");
  films = new Film[filmArray.size()];
  
  for (int i = 0; i < films.length; i++) {
    JSONObject o = filmArray.getJSONObject(i);
    films[i] = new Film(o);
  }
  filmsSorted = sort(films);
  isSorted = false;
}

void draw() {
  background(0);
  
  for (int i = 0; i < films.length; i++) {
    int x = i*32 + 32;
    if (films[i].isDiagonal()) {
      if (!isSorted)
        films[i].display(x, height - 30);
      else
        filmsSorted[i].display(x, height - 30);
    }
    else {
      if (!isSorted)
        films[i].display(80, x);
      else
        filmsSorted[i].display(80, x);
    }
  }

}

void mouseReleased() {
  if (mouseButton == LEFT) {
    for (Film film : films) {
      film.setRotation(
        film.isDiagonal()
        ? 0
        : -QUARTER_PI
      );
    }
  }
  
  if (mouseButton == RIGHT) {
    isSorted =
      isSorted
      ? false
      : true;
  }
}

Film[] sort(Film[] array) {
  Film[] newArray = array.clone();
  
  for (int i = 0; i < newArray.length - 1; i++) {
    for (int j = 0; j < newArray.length - i - 1; j++) {
      if (newArray[j].getRating() < newArray[j+1].getRating()) {
        Film temp = newArray[j];
        newArray[j] = newArray[j+1];
        newArray[j+1] = temp;
      }
    }
  }
  
  return newArray;
}

class Film {
  private String title;
  private String director;
  private int year;
  private float rating;
  private float rotation;
  
  Film(JSONObject f) {
    title = f.getString("title");
    director = f.getString("director");
    year = f.getInt("year");
    rating = f.getFloat("rating");
    rotation = -QUARTER_PI;
  }

  void display(int x, int y) {
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    fill(255);
    // rect
    if (rating > 8)
      rect(-10, -15, 350, 20);
    else if (rating > 7 && rating <= 8)
      rect(-10, -15, 300, 20);
    else if (rating <= 7)
      rect(-10, -15, 250, 20);
    else
      rect(-10, -15, 200, 20);
    // rect
    
    // text
    if (rating > 8)
      fill(0, 0, 255);
    else if (rating > 7 && rating <= 8)
      fill(0, 255, 0);
    else if (rating <= 7)
      fill(255, 0, 0);
    else
      fill(255);
    String text = year + ": " + rating + ", " + title + ", " + director; 
    text(text, 0, 0);
    // text
    popMatrix();
  }
  
  public void setRotation(float rotation) {
    this.rotation = rotation;
  }
  
  public float getRotation() {
    return rotation;
  }
  
  public boolean isDiagonal() {
    return rotation == -QUARTER_PI;
  }
  
  public float getRating() {
    return rating;
  }
}
