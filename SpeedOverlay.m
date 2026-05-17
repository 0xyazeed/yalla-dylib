#import <UIKit/UIKit.h>

static BOOL speedEnabled = NO;
static BOOL menuOpen = NO;
static UIButton *speedButton = nil;
static UIButton *tgButton = nil;
static UIView *menuView = nil;

@interface FlyController : UIViewController
@end

@implementation FlyController

- (void)flyTapped {
    menuOpen = !menuOpen;
    [UIView animateWithDuration:0.3 animations:^{
        menuView.alpha = menuOpen ? 1.0 : 0.0;
    }];
}

- (void)speedTapped {
    speedEnabled = !speedEnabled;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                w.layer.speed = speedEnabled ? 2.0 : 1.0;
            }
        }
    }
    if (speedEnabled) {
        [speedButton setTitle:@"✅ تم تفعيل السبيد" forState:UIControlStateNormal];
        speedButton.backgroundColor = [UIColor blackColor];
    } else {
        [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
        speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    }
}

- (void)tgTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/LJFNQ"]
                                       options:@{}
                             completionHandler:nil];
}

@end

static FlyController *controller = nil;
static UIWindow *overlayWindow = nil;

static void setupOverlay() {
    overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(10, 200, 170, 180)];
    overlayWindow.windowLevel = UIWindowLevelAlert + 100;
    overlayWindow.backgroundColor = [UIColor clearColor];
    overlayWindow.userInteractionEnabled = YES;

    controller = [[FlyController alloc] init];
    controller.view.backgroundColor = [UIColor clearColor];
    overlayWindow.rootViewController = controller;
    overlayWindow.hidden = NO;

    // زر 10th battalión
    UIButton *flyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flyButton.frame = CGRectMake(0, 0, 155, 35);
    flyButton.layer.cornerRadius = 10;
    flyButton.layer.masksToBounds = YES;
    flyButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    flyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [flyButton setTitle:@"⌗ 10th battalión" forState:UIControlStateNormal];
    [flyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flyButton addTarget:controller action:@selector(flyTapped) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubvie
