#import <UIKit/UIKit.h>

#define SPEED_KEY @"speedEnabled"

static BOOL speedEnabled = NO;
static BOOL menuOpen = NO;
static BOOL inRoom = NO;
static UIButton *speedButton = nil;
static UIView *menuView = nil;
static UIWindow *overlayWindow = nil;

@interface FlyController : UIViewController
- (void)applySpeed;
- (void)hideOverlay;
- (void)showOverlay;
- (void)startMonitoring;
@end

static FlyController *controller = nil;

@implementation FlyController

- (void)flyTapped {
    menuOpen = !menuOpen;
    [UIView animateWithDuration:0.3 animations:^{
        menuView.alpha = menuOpen ? 1.0 : 0.0;
    }];
}

- (void)speedTapped {
    speedEnabled = !speedEnabled;
    [[NSUserDefaults standardUserDefaults] setBool:speedEnabled forKey:SPEED_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self applySpeed];
    if (speedEnabled) {
        [speedButton setTitle:@"✅ تم تفعيل السبيد" forState:UIControlStateNormal];
        speedButton.backgroundColor = [UIColor blackColor];
    } else {
        [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
        speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    }
}

- (void)applySpeed {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                w.layer.speed = speedEnabled ? 10.0 : 1.0;
            }
        }
    }
    [UIView setAnimationsEnabled:!speedEnabled];
}

- (void)tgTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/LJFNQ"] options:@{} completionHandler:nil];
}

- (void)hideOverlay {
    if (overlayWindow.hidden) return;
    inRoom = YES;
    menuOpen = NO;
    menuView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        overlayWindow.alpha = 0.0;
    } completion:^(BOOL done) {
        overlayWindow.hidden = YES;
    }];
}

- (void)showOverlay {
    if (!overlayWindow.hidden) return;
    inRoom = NO;
    overlayWindow.hidden = NO;
    menuView.alpha = 0.0;
    menuOpen = NO;
    [UIView animateWithDuration:0.3 animations:^{
        overlayWindow.alpha = 1.0;
    }];
}

- (void)startMonitoring {
    [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // نحصل على اعلى viewController
            UIViewController *root = nil;
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                        if (w.isKeyWindow) { root = w.rootViewController; break; }
                    }
                }
            }
            UIViewController *top = root;
            while (top.presentedViewController) top = top.presentedViewController;
            if ([top isKindOfClass:[UINavigationController class]]) {
                top = ((UINavigationController *)top).topViewController;
            }

            NSString *name = NSStringFromClass([top class]);
            BOOL shouldHide = [name containsString:@"Room"] ||
                              [name containsString:@"Live"] ||
                              [name containsString:@"Chat"] ||
                              [name containsString:@"Voice"] ||
                              [name containsString:@"Call"];

            if (shouldHide && !inRoom) {
                [self hideOverlay];
            } else if (!shouldHide && inRoom) {
                [self showOverlay];
            }
        });
    }];
}

@end

static void setupOverlay() {
    speedEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:SPEED_KEY];

    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 145;
    CGFloat h = 160;
    CGFloat x = screen.size.width - w - 10;
    CGFloat y = screen.size.height - h - 200;

    overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(x, y, w, h)];
    overlayWindow.windowLevel = UIWindowLevelAlert + 100;
    overlayWindow.backgroundColor = [UIColor clearColor];
    overlayWindow.userInteractionEnabled = YES;
    controller = [[FlyController alloc] init];
    controller.view.backgroundColor = [UIColor clearColor];
    overlayWindow.rootViewController = controller;
    overlayWindow.hidden = NO;

    UIButton *flyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flyButton.frame = CGRectMake(0, 120, 140, 30);
    flyButton.layer.cornerRadius = 8;
    flyButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
    flyButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [flyButton setTitle:@"⌗ 10th battalión" forState:UIControlStateNormal];
    [flyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [flyButton addTarget:controller action:@selector(flyTapped) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubview:flyButton];

    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 140, 112)];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.alpha = 0;
    menuView.userInteractionEnabled = YES;
    [controller.view addSubview:menuView];

    speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    speedButton.frame = CGRectMake(0, 0, 140, 50);
    speedButton.layer.cornerRadius = 10;
    speedButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    if (speedEnabled) {
        speedButton.backgroundColor = [UIColor blackColor];
        [speedButton setTitle:@"✅ تم تفعيل السبيد" forState:UIControlStateNormal];
    } else {
        speedButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.85 alpha:0.95];
        [speedButton setTitle:@"⚡ تفعيل السرعة" forState:UIControlStateNormal];
    }
    [speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [speedButton addTarget:controller action:@selector(speedTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:speedButton];

    UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tgButton.frame = CGRectMake(0, 58, 140, 50);
    tgButton.layer.cornerRadius = 10;
    tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    tgButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.48 blue:0.75 alpha:0.95];
    [tgButton setTitle:@"📩 ⌗ Fly .." forState:UIControlStateNormal];
    [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tgButton addTarget:controller action:@selector(tgTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:tgButton];

    [controller applySpeed];
    [controller startMonitoring];
}

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setupOverlay();
    });
}
