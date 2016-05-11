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
#import "RCTView.h"
#import "UIView+React.h"

@implementation RCTTVRemoteHandler
{
  __weak RCTEventDispatcher *_eventDispatcher;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  RCTAssertParam(bridge);
  
  if ((self = [super init])) {
    _eventDispatcher = [bridge moduleForClass:[RCTEventDispatcher class]];
    
    self.tvRemoteGestureRecognizers = [NSMutableArray array];
    
    // Recognizers for Apple TV remote buttons
    
    // Play/Pause
    [self addTapGestureRecognizerWithSelector:@selector(playPausePressed:)
                                    pressType:UIPressTypePlayPause];
    
    // Menu
    [self addTapGestureRecognizerWithSelector:@selector(menuPressed:)
                                    pressType:UIPressTypeMenu];
    
    // Select
    [self addTapGestureRecognizerWithSelector:@selector(selectPressed:)
                                    pressType:UIPressTypeSelect];
    
    // Up
    [self addTapGestureRecognizerWithSelector:@selector(swipedUp:)
                                    pressType:UIPressTypeUpArrow];
    
    // Down
    [self addTapGestureRecognizerWithSelector:@selector(swipedDown:)
                                    pressType:UIPressTypeDownArrow];
    
    // Left
    [self addTapGestureRecognizerWithSelector:@selector(swipedLeft:)
                                    pressType:UIPressTypeLeftArrow];
    
    // Right
    [self addTapGestureRecognizerWithSelector:@selector(swipedRight:)
                                    pressType:UIPressTypeRightArrow];
    
    
    // Recognizers for Apple TV remote trackpad swipes
    
    // Up
    [self addSwipeGestureRecognizerWithSelector:@selector(swipedUp:)
                                      direction:UISwipeGestureRecognizerDirectionUp];
    
    // Down
    [self addSwipeGestureRecognizerWithSelector:@selector(swipedDown:)
                                      direction:UISwipeGestureRecognizerDirectionDown];
    
    // Left
    [self addSwipeGestureRecognizerWithSelector:@selector(swipedLeft:)
                                      direction:UISwipeGestureRecognizerDirectionLeft];
    
    // Right
    [self addSwipeGestureRecognizerWithSelector:@selector(swipedRight:)
                                      direction:UISwipeGestureRecognizerDirectionRight];
    
  }

  return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)init)


- (void)playPausePressed:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"playPause"];
}

- (void)menuPressed:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"menu"];
}

- (void)selectPressed:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"select"];
  
  RCTView *v = (RCTView*)r.view;
  if(v.onTVSelect) {
    v.onTVSelect(nil);
  }
  
}

- (void)longPress:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"longPress"];
}

- (void)swipedUp:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"up"];
}

- (void)swipedDown:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"down"];
}

- (void)swipedLeft:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"left"];
}

- (void)swipedRight:(UIGestureRecognizer*)r {
  [self sendAppleTVEvent:@"right"];
}

#pragma mark -

- (void)addTapGestureRecognizerWithSelector:(nonnull SEL)selector pressType:(UIPressType)pressType {
  
  UISwipeGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
  recognizer.allowedPressTypes = @[[NSNumber numberWithInteger:pressType]];
  
  
  if(pressType == UIPressTypeSelect) {
    self.selectRecognizer = recognizer;
  } else {
    NSMutableArray *gestureRecognizers = (NSMutableArray*)self.tvRemoteGestureRecognizers;
    [gestureRecognizers addObject:recognizer];
  }
}

- (void)addSwipeGestureRecognizerWithSelector:(nonnull SEL)selector direction:(UISwipeGestureRecognizerDirection)direction {
  
  UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:selector];
  recognizer.direction = direction;
  
  NSMutableArray *gestureRecognizers = (NSMutableArray*)self.tvRemoteGestureRecognizers;
  [gestureRecognizers addObject:recognizer];
}

- (void)sendAppleTVEvent:(NSString*)eventType {
  NSDictionary *event = @{
                          @"eventType": eventType
                          };
  [_eventDispatcher sendAppEventWithName:@"tvEvent" body:event];
}


@end
