#include <stdint.h>

volatile uint32_t resultado_soma = 0;

int main (void) {
    for (uint32_t i = 0; i <= 5000; i++) {
        resultado_soma += i;
    }
    while (1);
    return 0;
}
