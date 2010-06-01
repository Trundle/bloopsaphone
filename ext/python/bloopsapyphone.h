/*
 * Helper header as Cython does not support macros.
 */

#ifndef BLOOPSAPYPHONE_H
#define BLOOPSAPYPHONE_H

/* For offsetof() */
#include "structmember.h"


#define BLOOPS_OFFSET(name) \
  int bloops_##name##_offset = offsetof(bloopsaparams, name);

int bloops_params_offset = offsetof(bloopsaphone, params);
int bloops_offset_min = offsetof(bloopsaparams, volume);s
int bloops_offset_max = offsetof(bloopsaparams, repeat);
BLOOPS_OFFSET(volume)
BLOOPS_OFFSET(aspeed)
BLOOPS_OFFSET(decay)
BLOOPS_OFFSET(freq)
BLOOPS_OFFSET(lpf)
BLOOPS_OFFSET(lsweep)
BLOOPS_OFFSET(repeat)
BLOOPS_OFFSET(resonance)
BLOOPS_OFFSET(slide)
BLOOPS_OFFSET(square)
BLOOPS_OFFSET(sustain)
BLOOPS_OFFSET(sweep)
BLOOPS_OFFSET(vibe)
BLOOPS_OFFSET(vspeed)

#endif
