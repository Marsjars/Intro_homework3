//creating a saw instrument
class SawInstrument implements Instrument
{
  
  Oscil wave;
  Line  ampEnv;
  
  SawInstrument( float frequency )
  {
    // make a saw wave oscillator
    wave   = new Oscil( frequency, 0, Waves.SAW );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  void noteOn( float duration )
  {
    ampEnv.activate( duration, .1f, 0 );
    wave.patch( out );
  }
  
  void noteOff()
  {
    wave.unpatch( out );
  }
  
}