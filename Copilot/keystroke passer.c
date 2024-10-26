//simple keystroke passer
// keystroke_passer | other_console_application
#include <stdio.h>
#include <stdlib.h>

int main() {
    int ch;
    while ((ch = getchar()) != EOF) {
        putchar(ch);
    }
    return 0;
}


// intercept CTRL+ UPA RROW

#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

#define CTRL_UP_ARROW 0x8D // Virtual key code for CTRL + UP ARROW

void substituteText() {
    const char *substitute = "Substituted Text";
    printf("%s", substitute);
}

int main() {
    HANDLE hStdin = GetStdHandle(STD_INPUT_HANDLE);
    if (hStdin == INVALID_HANDLE_VALUE) {
        fprintf(stderr, "Error getting standard input handle\n");
        return 1;
    }

    DWORD mode;
    if (!GetConsoleMode(hStdin, &mode)) {
        fprintf(stderr, "Error getting console mode\n");
        return 1;
    }

    // Enable window input events
    mode |= ENABLE_WINDOW_INPUT;
    if (!SetConsoleMode(hStdin, mode)) {
        fprintf(stderr, "Error setting console mode\n");
        return 1;
    }

    INPUT_RECORD inputRecord;
    DWORD events;
    while (1) {
        if (!ReadConsoleInput(hStdin, &inputRecord, 1, &events)) {
            fprintf(stderr, "Error reading console input\n");
            return 1;
        }

        if (inputRecord.EventType == KEY_EVENT && inputRecord.Event.KeyEvent.bKeyDown) {
            KEY_EVENT_RECORD keyEvent = inputRecord.Event.KeyEvent;
            if (keyEvent.dwControlKeyState & (LEFT_CTRL_PRESSED | RIGHT_CTRL_PRESSED) &&
                keyEvent.wVirtualKeyCode == VK_UP) {
                substituteText();
            } else {
                putchar(keyEvent.uChar.AsciiChar);
            }
        }
    }

    return 0;
}


