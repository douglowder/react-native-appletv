//
//  RCTTVRemoteHandler.m
//  ReactTV
//
//  Created by Douglas Lowder on 5/3/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTTVRemoteHandler.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "RCTAssert.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"
#import "RCTUIManager.h"
#import "RCTUtils.h"
#import "RCTRootView.h"
#import "UIView+React.h"

@interface RCTTVRemoteHandler()

@end

@implementation RCTTVRemoteHandler
{
  __weak RCTEventDispatcher *_eventDispatcher;
  
  
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  RCTAssertParam(bridge);
  
  if ((self = [super init])) {
    _eventDispatcher = [bridge moduleForClass:[RCTEventDispatcher class]];
    
    
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    
    // Recognizers for Apple TV remote buttons
    
    UITapGestureRecognizer *playPauseRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(playPausePressed:)];
    playPauseRecognizer.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [gestureRecognizers addObject:playPauseRecognizer];
    
    UITapGestureRecognizer *menuRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(menuPressed:)];
    menuRecognizer.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeMenu]];
    [gestureRecognizers addObject:menuRecognizer];
    
    UITapGestureRecognizer *selectRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(selectPressed:)];
    selectRecognizer.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeSelect]];
    [gestureRecognizers addObject:selectRecognizer];
    
    
    
    // Recognizers for Apple TV remote trackpad swipes
    
    UISwipeGestureRecognizer *swipeUpRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [gestureRecognizers addObject:swipeUpRecognizer];
    
    UISwipeGestureRecognizer *swipeDownRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedDown:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [gestureRecognizers addObject:swipeDownRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [gestureRecognizers addObject:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [gestureRecognizers addObject:swipeRightRecognizer];
    
    self.tvRemoteGestureRecognizers = gestureRecognizers;
  }
  
  return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)init)

- (void)sendAppleTVEvent:(NSString*)eventType {
  NSDictionary *event = @{
                          @"eventType": eventType
                          };
  [_eventDispatcher sendAppEventWithName:@"tvEvent" body:event];
}

- (void)playPausePressed:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"playPause"];
}

- (void)menuPressed:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"menu"];
}

- (void)selectPressed:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"select"];
}

- (void)swipedUp:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"swipeUp"];
}

- (void)swipedDown:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"swipeDown"];
}

- (void)swipedLeft:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"swipeLeft"];
}

- (void)swipedRight:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"swipeRight"];
}

@end
