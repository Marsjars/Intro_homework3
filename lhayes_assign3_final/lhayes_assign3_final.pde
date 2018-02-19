import ddf.minim.*;         //import audio library
import ddf.minim.ugens.*;   //import synth library 
import java.util.Map;       //find HashMap library
Minim minim;
AudioOutput out;
PImage keyboard;

//creating data types to track keys pressed.
ArrayList<String> notesPressed;
ArrayList<String> allowedNotes;
//creating a dictionary of musical frequencies
FloatDict noteFrequencies;
//storing instrument object with key
HashMap<String, Object> instruments;
//keeping track of other piano data
ArrayList<String> whiteNoteXPositions;
ArrayList<String> blackNoteXPositions;
int currentOctave;
String currentInstrument;

void setup()
{
  size(1192, 600, P3D);
  minim = new Minim(this);
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut(); 
  // load keyboard image
  keyboard = loadImage("digitalkeyboardlayout.png");
  
  notesPressed = new ArrayList();
  allowedNotes = new ArrayList();
  whiteNoteXPositions = new ArrayList();
  blackNoteXPositions = new ArrayList();
  noteFrequencies = new FloatDict();
  instruments = new HashMap<String, Object>();
  currentOctave = 4;
  currentInstrument = "Sine";
  
  allowedNotes.add("a");
  allowedNotes.add("w");
  allowedNotes.add("s");
  allowedNotes.add("e");
  allowedNotes.add("d");
  allowedNotes.add("f");
  allowedNotes.add("t");
  allowedNotes.add("g");
  allowedNotes.add("y");
  allowedNotes.add("h");
  allowedNotes.add("u");
  allowedNotes.add("j");
  allowedNotes.add("k");
  
  noteFrequencies.set("a", 32.70); //C1
  noteFrequencies.set("w", 34.65); //C1#
  noteFrequencies.set("s", 36.71); //D1
  noteFrequencies.set("e", 38.89); //E1b
  noteFrequencies.set("d", 41.20); //E1
  noteFrequencies.set("f", 43.65); //F1
  noteFrequencies.set("t", 46.25); //F1#
  noteFrequencies.set("g", 49.00); //G1
  noteFrequencies.set("y", 51.91); //G1#
  noteFrequencies.set("h", 55.00); //A1
  noteFrequencies.set("u", 58.27); //A1b
  noteFrequencies.set("j", 61.74); //B1
  noteFrequencies.set("k", 65.41); //C2 (Octave)
  
  whiteNoteXPositions.add("a");
  whiteNoteXPositions.add("s");
  whiteNoteXPositions.add("d");
  whiteNoteXPositions.add("f");
  whiteNoteXPositions.add("g");
  whiteNoteXPositions.add("h");
  whiteNoteXPositions.add("j");
  whiteNoteXPositions.add("k");
  
  blackNoteXPositions.add("w");
  blackNoteXPositions.add("e");
  blackNoteXPositions.add("blank");
  blackNoteXPositions.add("t");
  blackNoteXPositions.add("y");
  blackNoteXPositions.add("u");


}

void draw()
{
  background(146,205,207);
  image(keyboard, 0, 300);
  stroke(68,88,120);
  strokeWeight(1);
  
  // draw the waveform of the output
  for(int i = 200; i < out.bufferSize() - 24; i++)
  {
    line( i, 150  - out.mix.get(i)*75,  i - 1, 150  - out.mix.get(i+1)*75 );
  }
  // waveform circles
  fill(68,88,120);
  ellipse(175,150,75,75);
  ellipse(1025,150,75,75);
  
  //playing the synth by calling the playNotes function
  if(notesPressed.size() > 0){
    playNotes();
  }
  
  //Drawing the areas to change octaves
  fill(49, 53, 61, 150);
  rect(1100, 545, 50, 50);
  rect(1050, 545, 50, 50);
  fill(252);
  textSize(32);
  text("-", 1063, 585);
  text("+", 1115, 585); 
  fill(252);
  textSize(12);
  
  //Drawing the areas to change instruments

  /* Sine Instrument */
  if(currentInstrument.equals("Sine")){
    fill(49, 53, 61, 255);
  }else{
    fill(49, 53, 61, 150);
  } 
  rect(950, 545, 50, 50);
  
  //drawing the icons
  noFill();
  stroke(255);
  bezier(960,565,970,550,975, 600,985 ,570);
  
  /* Saw Instrument */
  stroke(68,88,120);
  if(currentInstrument.equals("Saw")){
    fill(49, 53, 61, 255);
  }else{
    fill(49, 53, 61, 150);
  } 
  
  //drawing the saw button
  rect(1000, 545, 50, 50);
  stroke(255);
  line(1035,580,1035,560);
  line(1015,580,1015,560);
  curve(1045,580,1035,580,1015,560,1010,550); //its a very straight line, but it counts!
  
  fill(68, 88, 120);
  //drawing circles where notes are being played
  for(int i = 0; i < notesPressed.size(); i++){
    if(whiteNoteXPositions.contains(notesPressed.get(i))){
      ellipse(12 + (whiteNoteXPositions.indexOf(notesPressed.get(i)) * 24) + ((currentOctave - 1) * 170), 420, 10, 10);
    }else{
      ellipse(24 + (blackNoteXPositions.indexOf(notesPressed.get(i)) * 24) + ((currentOctave - 1) * 170), 370, 10, 10);
    }
  }

//drawing text for the keyboard legend based of drawing circle position
textSize(16);
fill(0);
  for(int i = 0; i < whiteNoteXPositions.size(); i++){
    text(whiteNoteXPositions.get(i) + "", 12 + ((i) * 24) + ((currentOctave - 1) * 170), 430);
  }

fill(255);
  for(int i = 0; i < blackNoteXPositions.size(); i++){
    if(!blackNoteXPositions.get(i).equals("blank")){
      text(blackNoteXPositions.get(i), 22 + ((i) * 24) + ((currentOctave - 1) * 170), 350);
    }
  }    

}

void keyPressed()
{
  //adds the key pressed  
  if(!notesPressed.contains(key + "") && allowedNotes.contains(key + "") && !instruments.containsKey(key + "") ){
      notesPressed.add(key + "");
    }
    print("Currently Pressed notes: " + notesPressed + "\n");  
}

void keyReleased() 
{
    if(notesPressed.contains(key + "") && allowedNotes.contains(key + "") && instruments.containsKey(key + "") ){
      //Removing the key from the list of keys being held down
      notesPressed.remove(key + "");
      //Turning the instrument off to stop the note from playing
      if(currentInstrument.equals("Sine")){
        ((SineInstrument) instruments.get(key + "") ).noteOff();
      }else if(currentInstrument.equals("Saw")){
        ((SawInstrument) instruments.get(key + "") ).noteOff();
      }
      //remove the instrument from the list of instruments currently playing
      instruments.remove(key + "");
    }
    print("Currently Pressed notes: " + notesPressed + "\n");  
}

void mouseClicked(){
  
  //handling changing the octave through mouse clicks
  if(currentOctave >= 0 && currentOctave <= 7){
    if(mouseX >= 1100 && mouseX < 1160 && mouseY >= 545 && mouseY <= 595 && currentOctave < 7){
      currentOctave += 1;
    }else if(mouseX >= 1050 && mouseX < 1100 && mouseY >= 545 && mouseY <= 595 && currentOctave > 1){
      currentOctave -= 1;
    }
  }
  
  
  //handling changing the instrument through mouse clicks
    if(mouseX >= 1000 && mouseX < 1050 && mouseY >= 550 && mouseY <= 600){
      notesPressed.clear();
      instruments.clear();
      currentInstrument = "Saw";
    }else if(mouseX >= 950 && mouseX < 1000 && mouseY >= 545 && mouseY <= 595){
      notesPressed.clear();
      instruments.clear();
      currentInstrument = "Sine";
    }
     
}


void playNotes(){
  //Looping through every key that has been pressed
  for(int i = 0; i < notesPressed.size(); i++){
    //If the key pressed does not currently have an instrument created for it (Basically checking has the pressed key been handled already?), then this code will execute
    if(!instruments.containsKey(notesPressed.get(i))){
      
      if(currentInstrument.equals("Sine")){
        //Storing the instruments/note that has been played so we can stop it later
        instruments.put(notesPressed.get(i) + "", new SineInstrument( noteFrequencies.get(notesPressed.get(i) + "" ) * pow(2, currentOctave - 1)));
        //Pulling the instrument we stored from the List of instruments, based off of the key pressed
        out.playNote( 0.0, 8, (SineInstrument) instruments.get(notesPressed.get(i) + ""));
      }
      
      else if(currentInstrument.equals("Saw")){
        //Storing the instruments/note that has been played so we can stop it later
        instruments.put(notesPressed.get(i) + "", new SawInstrument( noteFrequencies.get(notesPressed.get(i) + "" ) * pow(2, currentOctave - 1)));
        //Pulling the instrument we stored from the List of instruments, based off of the key pressed
        out.playNote( 0.0, 8, (SawInstrument) instruments.get(notesPressed.get(i) + ""));
      }
      
      print("Frequency of note played: " + noteFrequencies.get(notesPressed.get(i) + "" ) * pow(2, currentOctave - 1) + "\n\n");
    }
  }
}