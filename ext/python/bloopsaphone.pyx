# coding: iso-8859-15

"""
    bloopsaphone
    ~~~~~~~~~~~~

    Python bindings to why's bloopsaphone.

    :copyright: Copyright (C) 2010 by Andreas Stührk.
    :license: Modified BSD.
"""

cdef extern from "bloopsaphone.h":
    ctypedef struct bloops:
        int tempo

    ctypedef enum bloopsawaveform:
        BLOOPS_SQUARE,
        BLOOPS_SAWTOOTH,
        BLOOPS_SINE,
        BLOOPS_NOISE

    ctypedef struct bloopsaparams:
        int type

    ctypedef struct bloopsaphone:
        unsigned refcount
        bloopsaparams params

    ctypedef struct bloopsatrack:
        pass

    bloops *bloops_new()
    void bloops_destroy(bloops *)
    int bloops_is_done(bloops *)
    void bloops_play(bloops *)

    bloopsaphone *bloops_square()
    void bloops_sound_destroy(bloopsaphone *)

    bloopsatrack *bloops_track(bloops *, bloopsaphone *, char *, int)
    void bloops_track_destroy(bloopsatrack *)
    char *bloops_track_str(bloopsatrack *)

cdef extern from "bloopsapyphone.h":
    int bloops_offset_min
    int bloops_offset_max
    int bloops_params_offset
    int bloops_volume_offset
    int bloops_arp_offset
    int bloops_aspeed_offset
    int bloops_decay_offset
    int bloops_dslide_offset
    int bloops_freq_offset
    int bloops_hpf_offset
    int bloops_hsweep_offset
    int bloops_lpf_offset
    int bloops_lsweep_offset
    int bloops_phase_offset
    int bloops_psweep_offset
    int bloops_punch_offset
    int bloops_repeat_offset
    int bloops_resonance_offset
    int bloops_slide_offset
    int bloops_square_offset
    int bloops_sustain_offset
    int bloops_sweep_offset
    int bloops_vibe_offset
    int bloops_vspeed_offset

cdef extern from "Python.h":
    object PyString_FromString(char *)

cdef extern from "stdlib.h":
    void free(void *)

cdef class Phone

cdef class Bloops:
    cdef bloops *bloops

    def __cinit__(self):
        self.bloops = bloops_new()

    def is_done(self):
        return bool(bloops_is_done(self.bloops))

    def play(self):
        bloops_play(self.bloops)

    property tempo:
        def __get__(self):
            return self.bloops.tempo

        def __set__(self, value):
            self.bloops.tempo = value

    def tune(self, Phone phone, track):
        return Track(self, phone, track)

    def __dealloc__(self):
        if self.bloops:
            bloops_destroy(self.bloops)

cdef class Phone:
    cdef bloopsaphone *phone

    def __init__(self, type="square"):
        self.type = type

    def __cinit__(self):
        self.phone = bloops_square()

    property type:
        def __get__(Phone self):
            types = {
                BLOOPS_SQUARE: "square",
                BLOOPS_SAWTOOTH: "sawtooth",
                BLOOPS_SINE: "sine",
                BLOOPS_NOISE: "noise"
            }
            return types[self.phone.params.type]

        def __set__(Phone self, type):
            types = {
                "square": BLOOPS_SQUARE,
                "sawtooth": BLOOPS_SAWTOOTH,
                "sine": BLOOPS_SINE,
                "noise": BLOOPS_NOISE
            }
            if type not in types:
                raise ValueError("Unknown phone type: '%s'" % (type, ))
            self.phone.params.type = types[type]

    repeat = Accessor(bloops_repeat_offset)
    arp = Accessor(bloops_arp_offset)
    aspeed = Accessor(bloops_aspeed_offset)
    decay = Accessor(bloops_decay_offset)
    dslide = Accessor(bloops_dslide_offset)
    freq = Accessor(bloops_freq_offset)
    hpf = Accessor(bloops_hpf_offset)
    hsweep = Accessor(bloops_hsweep_offset)
    lpf = Accessor(bloops_lpf_offset)
    lsweep = Accessor(bloops_lsweep_offset)
    phase = Accessor(bloops_phase_offset)
    psweep = Accessor(bloops_psweep_offset)
    punch = Accessor(bloops_punch_offset)
    resonance = Accessor(bloops_resonance_offset)
    slide = Accessor(bloops_slide_offset)
    square = Accessor(bloops_square_offset)
    sustain = Accessor(bloops_sustain_offset)
    sweep = Accessor(bloops_sweep_offset)
    vibe = Accessor(bloops_vibe_offset)
    vspeed = Accessor(bloops_vspeed_offset)
    volume = Accessor(bloops_volume_offset)

    def __dealloc__(self):
        if self.phone:
           bloops_sound_destroy(self.phone)

cdef class Accessor:
    cdef int offset

    def __cinit__(self, offset):
        if not bloops_offset_min <= offset <= bloops_offset_max:
            raise ValueError("Invalid offset.")
        self.offset = offset

    cdef float *get_ptr(self, Phone instance):
        return <float *>((<void *>instance.phone) + bloops_params_offset +
                          self.offset)

    def __get__(self, Phone instance, owner):
        if instance is None:
            raise AttributeError()
        return self.get_ptr(instance)[0]

    def __set__(self, Phone instance, value):
        self.get_ptr(instance)[0] = value

cdef class Track:
    cdef bloopsatrack *track

    def __cinit__(self, Bloops bloops not None, Phone phone not None, track):
        self.track = bloops_track(bloops.bloops, phone.phone, track, len(track))

    def __dealloc__(self):
        if self.track:
           bloops_track_destroy(self.track)

    def __str__(self):
        cdef char *str = bloops_track_str(self.track)
        py_str = PyString_FromString(str)
        free(str)
        return py_str
