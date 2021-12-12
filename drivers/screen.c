#include "screen.h"
#include "../kernel/low_level.h"
#include "../kernel/util.h"

void print_char(char character, int col, int row, char attribute_byte) {
    /* Pointer to start of video memory */
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
    
    /* Set style, default if attribute byte is zero */
    if (!attribute_byte) {
        attribute_byte = WHITE_ON_BLACK;
    }

    /* Get video memory offset for the screen location */
    int offset;
    /* Offset based on col and row, if non-negative */
    if (col >= 0 && row >= 0) {
        offset = get_screen_offset(col, row);
    /* Else, use cursor position */
    } else {
        offset = get_cursor();
    }

    /* Newline character sets offset to the end of current row */
    if (character == '\n') {
        int rows = offset / (2*MAX_COLS);
        offset = get_screen_offset(79, rows);
    /* Else, write character to offset position */
    } else {
        vidmem[offset] = character;
        vidmem[offset+1] = attribute_byte;
    }

    /* Move offset one character cell (two bytes) ahead */
    offset += 2;
    /* Scroll screen, if bottom of screen reached */
    offset = handle_scrolling(offset);
    /* Update cursor position to new offset */
    set_cursor(offset);
}

int get_screen_offset(int col, int row) {
    return ((row * MAX_COLS + col) * 2);
}

int get_cursor() {
    /* Write control registers to access internal registers,
     * which are the following:
     *     14: High byte of cursor offset
     *     15: Low byte of cursor offset 
     * Afterwards read data register */
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA)  << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    /* Offset is in number of characeter cells,
     * so double to convert to number of bytes */
    return offset*2;
}

void set_cursor(int offset) {
    /* Convert offset in character cells to offset in chars */
    offset /= 2;
    /* Write bytes to internal registers */
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset));
}

void print_at(char* message, int col, int row) {
    /* Set cursor if col, row specified */
    if (col >= 0 && row >= 0) {
        set_cursor(get_screen_offset(col,row));
    }
    /* Loop through chars until 0 */
    int i = 0;
    while(message[i] != 0) {
        print_char(message[i++], col, row, WHITE_ON_BLACK);
    }
}

void print(char* message) {
    print_at(message, -1, -1);
}

void clear_screen() {
    int row = 0;
    int col = 0;

    /* Loop through screen and write blank characters */
    for (row=0; row<MAX_ROWS; row++) {
        for (col=0; col<MAX_COLS; col++) {
            print_char(' ', col, row, WHITE_ON_BLACK);
        }
    }
    set_cursor(get_screen_offset(0,0));
}

int handle_scrolling(int cursor_offset) {
    /* If the cursor is within the screen, return it unmodified */
    if (cursor_offset < MAX_ROWS*MAX_COLS*2) {
        return cursor_offset;
    }

    /* Shift all rows back by one row */
    int i=0;
    for (i=0; i<MAX_ROWS; i++) {
        memory_copy((char*)get_screen_offset(0, i) + VIDEO_ADDRESS,
                    (char*)get_screen_offset(0,i-1) + VIDEO_ADDRESS,
                    MAX_COLS*2);
    }

    /* Blank the last line */
    char* last_line = (char*)get_screen_offset(0,MAX_ROWS-1) + VIDEO_ADDRESS;
    for (i=0; i<MAX_COLS*2; i++) {
        last_line[i] = 0;
    }

    /* Move offset back one row */
    cursor_offset -= 2*MAX_COLS;

    return cursor_offset;
}