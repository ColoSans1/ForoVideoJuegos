import controlP5.*;
import ddf.minim.*;

ControlP5 cp5;
Minim minim;

AudioPlayer musica1;
AudioPlayer musica2;
AudioPlayer musicaActual;
AudioPlayer clickSound;
AudioPlayer winSound;

String pantalla = "inici";
int tempsPantalla;

PImage fondoInici;
PImage fondoMenu;
PImage fondoMenu2;
PImage fondoJoc;
PImage imgX;
PImage imgO;

DropdownList ddlFondo;
DropdownList ddlMusica;

int fondoSeleccionat = 1;
int musicaSeleccionada = 1;

int[][] tauler = new int[3][3];
int jugador = 1;
boolean jocActiu = true;
String missatge = "Torn del jugador 1";

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  imageMode(CORNER);

  cp5 = new ControlP5(this);
  minim = new Minim(this);

  carregarRecursos();
  crearBotons();

  tempsPantalla = millis();
  aplicarMusica();
}

void draw() {
  background(0);

  if (pantalla.equals("inici")) {
    pantallaInici();
  } else if (pantalla.equals("menu")) {
    pantallaMenu();
  } else if (pantalla.equals("config")) {
    pantallaConfig();
  } else if (pantalla.equals("joc")) {
    pantallaJoc();
  } else if (pantalla.equals("exit")) {
    pantallaExit();
  }
}

void carregarRecursos() {
  fondoInici = loadImage("fondoInicio.png");
  fondoMenu = loadImage("fondoMenu.png");
  fondoMenu2 = loadImage("fondoMenu2.png");
  fondoJoc = loadImage("fondoJuego.png");

  imgX = loadImage("x.png");
  imgO = loadImage("o.png");

  musica1 = minim.loadFile("musica.mp3");
  musica2 = minim.loadFile("musica2.mp3");
  clickSound = minim.loadFile("click.wav");
  winSound = minim.loadFile("win.wav");
}

void crearBotons() {
  cp5.addButton("RUN").setPosition(350, 250).setSize(100, 40);
  cp5.addButton("CONFIG").setPosition(350, 310).setSize(100, 40);
  cp5.addButton("EXIT").setPosition(350, 370).setSize(100, 40);

  cp5.addButton("VOLVER").setPosition(20, 20).setSize(100, 30).hide();
  cp5.addButton("RESET").setPosition(650, 20).setSize(100, 30).hide();

  ddlFondo = cp5.addDropdownList("FONS")
    .setPosition(300, 200)
    .setSize(200, 100)
    .setBarHeight(24)
    .setItemHeight(24);

  ddlFondo.addItem("Fondo 1", 1);
  ddlFondo.addItem("Fondo 2", 2);
  ddlFondo.setValue(1);

  ddlMusica = cp5.addDropdownList("MUSICA")
    .setPosition(300, 320)
    .setSize(200, 100)
    .setBarHeight(24)
    .setItemHeight(24);

  ddlMusica.addItem("Musica 1", 1);
  ddlMusica.addItem("Musica 2", 2);
  ddlMusica.setValue(1);

  ddlFondo.hide();
  ddlMusica.hide();
}

void pantallaInici() {
  amagarControls();

  if (fondoInici != null) {
    image(fondoInici, 0, 0, width, height);
  }

  fill(255);
  textSize(34);
  text("Bon Nadal!", width/2, height/2 - 25);
  textSize(24);
  text("Empresa XYZ", width/2, height/2 + 25);

  if (millis() - tempsPantalla > 5000) {
    pantalla = "menu";
  }
}

void pantallaMenu() {
  amagarControls();

  if (fondoSeleccionat == 1 && fondoMenu != null) {
    image(fondoMenu, 0, 0, width, height);
  } else if (fondoMenu2 != null) {
    image(fondoMenu2, 0, 0, width, height);
  }

  cp5.getController("RUN").show();
  cp5.getController("CONFIG").show();
  cp5.getController("EXIT").show();
}

void pantallaConfig() {
  amagarControls();

  if (fondoSeleccionat == 1 && fondoMenu != null) {
    image(fondoMenu, 0, 0, width, height);
  } else if (fondoMenu2 != null) {
    image(fondoMenu2, 0, 0, width, height);
  } else {
    background(200);
  }

  fill(0);
  textSize(28);
  text("CONFIGURACIÓ", width/2, 90);
  textSize(18);
  text("Escull fons i música (aplicació en temps real)", width/2, 130);

  ddlFondo.show();
  ddlMusica.show();
  cp5.getController("VOLVER").show();
}

void pantallaJoc() {
  amagarControls();

  if (fondoJoc != null) {
    image(fondoJoc, 0, 0, width, height);
  }

  dibuixarTauler();

  fill(0);
  textSize(20);
  text(missatge, width/2, 80);

  cp5.getController("VOLVER").show();
  cp5.getController("RESET").show();
}

void pantallaExit() {
  amagarControls();

  background(0);
  fill(255);
  textSize(30);
  text("Feliç Any Nou!", width/2, height/2);

  if (millis() - tempsPantalla > 5000) {
    exit();
  }
}

void dibuixarTauler() {
  int mida = 120;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int x = 220 + i*mida;
      int y = 200 + j*mida;

      fill(255, 220);
      stroke(0);
      rect(x, y, mida, mida);

      if (tauler[i][j] == 1 && imgX != null) {
        image(imgX, x, y, mida, mida);
      } else if (tauler[i][j] == 2 && imgO != null) {
        image(imgO, x, y, mida, mida);
      }
    }
  }
}

void mousePressed() {
  if (pantalla.equals("joc") && jocActiu) {
    int mida = 120;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int x = 220 + i*mida;
        int y = 200 + j*mida;

        if (mouseX > x && mouseX < x + mida && mouseY > y && mouseY < y + mida && tauler[i][j] == 0) {
          tauler[i][j] = jugador;

          if (clickSound != null) {
            clickSound.rewind();
            clickSound.play();
          }

          if (!comprobarGuanyador()) {
            jugador = (jugador == 1) ? 2 : 1;
            missatge = "Torn del jugador " + jugador;
          }
          return;
        }
      }
    }
  }
}

boolean comprobarGuanyador() {
  for (int i = 0; i < 3; i++) {
    if (tauler[i][0] == tauler[i][1] && tauler[i][1] == tauler[i][2] && tauler[i][0] != 0) {
      declararGuanyador(tauler[i][0]);
      return true;
    }

    if (tauler[0][i] == tauler[1][i] && tauler[1][i] == tauler[2][i] && tauler[0][i] != 0) {
      declararGuanyador(tauler[0][i]);
      return true;
    }
  }

  if (tauler[0][0] == tauler[1][1] && tauler[1][1] == tauler[2][2] && tauler[0][0] != 0) {
    declararGuanyador(tauler[0][0]);
    return true;
  }

  if (tauler[2][0] == tauler[1][1] && tauler[1][1] == tauler[0][2] && tauler[2][0] != 0) {
    declararGuanyador(tauler[2][0]);
    return true;
  }

  if (taulerPle()) {
    missatge = "Empat!";
    jocActiu = false;
    return true;
  }

  return false;
}

boolean taulerPle() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tauler[i][j] == 0) {
        return false;
      }
    }
  }
  return true;
}

void declararGuanyador(int j) {
  if (winSound != null) {
    winSound.rewind();
    winSound.play();
  }

  missatge = "Guanya el jugador " + j;
  jocActiu = false;
}

void amagarControls() {
  cp5.getController("RUN").hide();
  cp5.getController("CONFIG").hide();
  cp5.getController("EXIT").hide();
  cp5.getController("VOLVER").hide();
  cp5.getController("RESET").hide();
  ddlFondo.hide();
  ddlMusica.hide();
}

void aplicarMusica() {
  if (musicaActual != null) {
    musicaActual.pause();
    musicaActual.rewind();
  }

  musicaActual = (musicaSeleccionada == 1) ? musica1 : musica2;

  if (musicaActual != null) {
    musicaActual.loop();
  }
}

public void RUN() {
  pantalla = "joc";
}

public void CONFIG() {
  pantalla = "config";
}

public void EXIT() {
  pantalla = "exit";
  tempsPantalla = millis();
}

public void VOLVER() {
  pantalla = "menu";
}

public void RESET() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      tauler[i][j] = 0;
    }
  }

  jugador = 1;
  jocActiu = true;
  missatge = "Torn del jugador 1";
}

public void FONS(int value) {
  fondoSeleccionat = value;
}

public void MUSICA(int value) {
  musicaSeleccionada = value;
  aplicarMusica();
}
