//
//  QLookView.m
//  Quicklook
//
//  Created by Stéphane Vanmeerhaeghe on 15/12/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "QLookView.h"
#import <QuickLook/QuickLook.h>

@interface QLookView ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property(nonatomic, strong ) QLPreviewController* controller;
@property(nonatomic, strong ) UIView* cview;
@property NSInteger fileCount; 
@end

@implementation QLookView

- (void)setFileUrl:(NSString *)fileUrl{
    _fileUrl =fileUrl;
     [self handleUpdate];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleHeight );
    
    self.fileCount = 0;
    self.controller = [[QLPreviewController alloc] init];
    self.controller.delegate = self;
    self.controller.dataSource=self;
    self.cview =_controller.view;
    self.cview.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleHeight );
    self.controller.automaticallyAdjustsScrollViewInsets = false;
   //[self addSubview:_cview];
  return self  ;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return _fileCount;
}


- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    if(_fileCount >0){
        return [NSURL fileURLWithPath:_fileUrl];
    }
    return nil;
}

- (void) handleUpdate{
    _fileCount = 0;
    if([_fileUrl length] > 0 &&  [NSFileManager.defaultManager fileExistsAtPath:_fileUrl]){
        _fileCount = 1;
        
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:self.controller animated:true completion:^{
            
        }];
    }
    
    
   [_controller refreshCurrentPreviewItem];
}



@end
