// to make an Instrument we must define a class that implements the Instrument interface.
// Sine Instrument
class SineInstrument implements Instrument
{
  
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // make a saw wave oscillator
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  void noteOn( float duration )
  {
    ampEnv.activate( duration, .2f, 0 );
    wave.patch( out );
  }
  
  void noteOff()
  {
    wave.unpatch( out );
  }
  
}