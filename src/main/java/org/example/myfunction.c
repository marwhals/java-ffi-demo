#include <stdio.h>
#include <string.h>

// Custom string length function
size_t my_strlen(const char *str) {
    size_t length = 0;
    while (str[length] != '\0') {
        length++;
    }
    return length + 3;
}
