#import <React/RCTViewManager.h>
#import "QLookView.h"

@interface QuicklookViewManager : RCTViewManager
@end

@implementation QuicklookViewManager

RCT_EXPORT_MODULE(QuicklookView)

- (QLookView *)view
{
  QLookView* v= [[QLookView alloc] init];
    
  return v;
}

RCT_CUSTOM_VIEW_PROPERTY(fileUrl, NSString, QLookView)
{
  [view setFileUrl:json];
}



@end
