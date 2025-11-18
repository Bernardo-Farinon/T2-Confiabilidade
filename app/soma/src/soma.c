int main() {
    volatile int a = 0;
    volatile int b = 1;
    volatile int c = 0;

    // 10.000 somas
    for (int i = 0; i < 10000; i++) {
        c = a + b;
        a = b + c;
        b = a + c;
    }

    while (1);
    return 0;
}
