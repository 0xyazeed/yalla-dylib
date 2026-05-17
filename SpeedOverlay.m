#import <UIKit/UIKit.h>

static BOOL speedEnabled = NO;
static BOOL menuOpen = NO;
static UIButton *speedButton = nil;
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
        [speedButton setTitle:@"tم تفعيل السبيد" forState:UIControlStateNormal];
        speedButton.backgroundColor = [UIColor blackColor];
    } else {
        [speedButton setTitle:@"تفعيل السرعة" forState:UIControlStateNormal];
        speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    }
}

- (void)tgTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/LJFNQ"] options:@{} completionHandler:nil];
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

    UIButton *flyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flyButton.frame = CGRectMake(0, 0, 155, 35);
    flyButton.layer.cornerRadius = 10;
    flyButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    flyButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [flyButton setTitle:@"10th battalon" forState:UIControlStateNormal];
    [flyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flyButton addTarget:controller action:@selector(flyTapped) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubview:flyButton];

    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 165, 130)];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.alpha = 0;
    menuView.userInteractionEnabled = YES;
    [controller.view addSubview:menuView];

    speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speedButton.frame = CGRectMake(0, 0, 165, 55);
    speedButton.layer.cornerRadius = 12;
    speedButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    [speedButton setTitle:@"تفعيل السرعة" forState:UIControlStateNormal];
    [speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [speedButton addTarget:controller action:@selector(speedTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:speedButton];

    UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tgButton.frame = CGRectMake(0, 63, 165, 55);
    tgButton.layer.cornerRadius = 12;
    tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    tgButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.48 blue:0.75 alpha:0.95];
    [tgButton setTitle:@"التواصل مع المبرمج" forState:UIControlStateNormal];
    [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tgButton addTarget:controller action:@selector(tgTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:tgButton];
}

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setupOverlay();
    });
}
