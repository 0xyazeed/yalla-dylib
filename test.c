#include <stdio.h>

extern double BoostAnimation(double duration);
extern int GetTargetFPS();

int main() {
    double result = BoostAnimation(1.0);
    printf("Result: %f\n", result);
    printf("FPS: %d\n", GetTargetFPS());
    return 0;
}
