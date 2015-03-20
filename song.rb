# A Singer that can sing a song using a voice
class Singer
  attr_accessor :voice

  def initialize(voice)
    self.voice = voice
  end

  def sing(song)
    song.tones.each do |t|
      voice.play(t)
    end
  end
end

# A Voice playing tones
# the voices modifier can alter the tones frequencies
class Voice
  attr_accessor :modifier

  def initialize(mod)
    @modifier = mod
  end

  def play(tone)
    puts tone
    if tone.silence
      sleep(tone.duration.to_f / 10000.0)
    else
      system( "./generator #{(tone.freq * modifier).to_i} #{tone.duration}" )
    end
  end

end


# A Tone (frequency and durationb) or Silence (duration)
class Tone

  attr_accessor :freq, :duration, :silence

  BEEP_LINE = /:beep frequency=(\d.+)\slength=(\d.+)ms/
  SILENCE_LINE = /:delay (\d.+)ms/

  def self.pause(duration)
    t = Tone.new
    t.silence = true
    t.duration = duration
    t
  end

  def self.beep(freq, duration)
    t = Tone.new
    t.freq = freq
    t.duration = duration
    t
  end

  def self.parse(line)
    if BEEP_LINE.match(line)
      beep($1.to_i, $2.to_i)
    elsif SILENCE_LINE.match(line)
      pause($1.to_i)
    end
  end

  def to_s
    if silence
      "silence for #{@duration}"
    else
      "tone #{@freq} for #{@duration}"
    end
  end
end

# A Song that can read its tones from a text file
class Song
  attr_reader :tones
  def initialize(file_name)
    @tones = []
    File.open(file_name, "r").each_line do |line|
      if line.length > 0
        t = Tone.parse(line)
        @tones << t unless t.nil?
      end
    end
  end
end

# Build a Singer using a Voice and let it perfom
# the super mario song (kind of ...)
normal = Voice.new(1.0)
singer = Singer.new(normal)
super_mario = Song.new("super_mario.song")
singer.sing(super_mario)

