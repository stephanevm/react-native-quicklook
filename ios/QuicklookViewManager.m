#import <React/RCTConvert.h>
#import "QLookView.h"
#import <QuickLook/QuickLook.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>


#define OPEN_EVENT @"QLViewerDidOpen"
#define DISMISS_EVENT @"QLViewerDidDismiss"


@interface QuickLookManager: RCTEventEmitter <RCTBridgeModule, QLPreviewControllerDelegate>
@end


// https://developer.apple.com/documentation/quicklook/qlpreviewitem
@interface PreviewItem: NSObject<QLPreviewItem>

@property(readonly, nullable, nonatomic) NSURL *previewItemURL;
@property(readonly, nullable, nonatomic) NSString *previewItemTitle;

- (id)initWithPath:(NSString *)path title:(NSString *)title;

@end

@interface CustomQLViewController: QLPreviewController<QLPreviewControllerDataSource>

@property(nonatomic, strong) PreviewItem *item;
@property(nonatomic, strong) NSNumber *invocation;

@end


@implementation PreviewItem

- (id)initWithPath:(NSString *)path title:(NSString *)title {
    if(self = [super init]) {
       _previewItemURL = [NSURL fileURLWithPath:path];
       _previewItemTitle = title;
    }
    return self;
}
@end


@implementation CustomQLViewController

- (void)viewDidLoad{
   if (@available(iOS 13.0, *)) {
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(dismissWhenAppGoesToBackground) 
       name:UISceneDidEnterBackgroundNotification
        object:nil];
     } else {
       [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(dismissWhenAppGoesToBackground) 
        name:UIApplicationDidEnterBackgroundNotification
        object:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
    if([self.childViewControllers count] > 0){
        if([self.childViewControllers[0] isKindOfClass:[UINavigationController class]]){
            UINavigationController* ctrl = self.childViewControllers[0];
            ctrl.navigationBar.barTintColor = [UIColor redColor]; //bgcolor
            ctrl.navigationBar.translucent = false;
           ctrl.navigationBar.tintColor = [UIColor blueColor]; //text
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }*/
  
    
    
   
}

- (void) dismissWhenAppGoesToBackground{
   [self dismissViewControllerAnimated:true completion:nil];
}

- (instancetype)initWithItem:(PreviewItem *)item identifier:(NSNumber *)invocation {
    if(self = [super init]) {
        _item = item;
        _invocation = invocation;
        self.dataSource = self;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return UIApplication.sharedApplication.isStatusBarHidden;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.item;
}

@end


@implementation QuickLookManager 

- (void)previewControllerDidDismiss:(CustomQLViewController *)controller {
    [self sendEventWithName:DISMISS_EVENT body: @{@"id": controller.invocation}];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (UIViewController*)topMostController {
  //https://stackoverflow.com/questions/6131205/how-to-find-topmost-view-controller-on-ios
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}


RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[OPEN_EVENT, DISMISS_EVENT];
}

RCT_EXPORT_METHOD(open:(NSString *)path invocation:(nonnull NSNumber *)invocationId
    options:(NSDictionary *)options)
{
    NSString *displayName = [RCTConvert NSString:options[@"displayName"]];
    PreviewItem *item  = [[PreviewItem alloc] initWithPath:path title:displayName];

    QLPreviewController *controller = [[CustomQLViewController alloc] initWithItem:item identifier:invocationId];
    controller.delegate = self;

    typeof(self) __weak weakSelf = self;
    [[QuickLookManager topMostController] presentViewController:controller animated:YES completion:^{
        [weakSelf sendEventWithName:OPEN_EVENT body: @{@"id": invocationId}];
    }];


}


@end
