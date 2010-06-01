import bloopsa
import time

# the song object
b = bloopsa.Bloops()
b.tempo = 320

# an instrument
saw = bloopsa.Phone("sawtooth")

# assign a track to the song
b.tune(saw, "c5 c6 b4 b5 d5 d6 e5 e6")

# make it go
b.play()
while not b.is_done():
    time.sleep(1)

# a percussion
beat = bloopsa.Phone("noise")
beat.repeat = 0.6
beat2 = bloopsa.Phone("noise")
beat2.repeat = 0.2
beat3 = bloopsa.Phone("square")
beat3.sustain = 0.25
beat3.decay = 0.2
beat3.slide = 0.2
beat3.square = 0.3
beat3.vibe = 0.25
beat3.vspeed = 0.25

# assign a track to the song
bloopsa.Track(b, beat, "4 4 4 b4 4 d5 4 e5")
bloopsa.Track(b, beat2, "c2 4 c2 4 c2 4 c2 4")
bloopsa.Track(b, beat3, "4 4 4 4 4 c2 c5 4")

# make it go
b.play()
while not b.is_done():
    time.sleep(0.002)
