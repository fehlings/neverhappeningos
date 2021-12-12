#include "low_level.h"

unsigned char port_byte_in(unsigned short port) {
    // Reads byte from specified port
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void port_byte_out(unsigned short port, unsigned char data) {
    // Writes byte to specified port
    __asm__("out %%al, %%dx" : :"a" (data), "d" (port));
}

unsigned short port_word_in(unsigned short port) {
    // Reads word from specified port
    unsigned short result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void port_word_out(unsigned short port , unsigned short data) {
    // Writes word to specified port
    __asm__("out %%ax, %%dx" : :"a" (data), "d" (port));
}