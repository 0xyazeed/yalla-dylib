#include <stdio.h>
#include <objc/runtime.h>

// تسريع الانميشن
double BoostAnimation(double duration) {
    return duration * 0.5;
}

// تفعيل/إيقاف السرعة
static int speedEnabled = 1;

void SetSpeedEnabled(int enabled) {
    speedEnabled = enabled;
}

int IsSpeedEnabled() {
    return speedEnabled;
}

// تسريع كل شي بالتطبيق
double GetSpeedMultiplier() {
    if (speedEnabled) {
        return 2.0; // ضعف السرعة
    }
    return 1.0; // سرعة عادية
}
