#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f
// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

/* Print a char on the screen at col, row, or at cursor position */
void print_char(char character, int col, int row, char attribute_byte);

/* Calculate offset for given column and row */
int get_screen_offset(int col, int row);

/* Return cursor position */
int get_cursor();

/* Set cursor position */
void set_cursor(int offset);

/* Scrolls screen if end of screen is reached */
int handle_scrolling(int offset);

/* Prints every character after pointer to first character at coordinates col, row  */
void print_at(char* message, int col, int row);

/* Prints every character after pointer at the cursor location */
void print(char* message);

/* Writes blank characters to every position */
void clear_screen();

/* Advance the cursor and scroll the video buffer if necessary */
int handle_scrolling(int cursor_offset);