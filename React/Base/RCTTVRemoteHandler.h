//
//  RCTTVRemoteHandler.h
//  ReactTV
//
//  Created by Douglas Lowder on 5/3/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCTFrameUpdate.h"

@class RCTBridge;

@interface RCTTVRemoteHandler : NSObject

@property(nonatomic, nonnull, readwrite, strong) NSArray *tvRemoteGestureRecognizers;
@property(nonatomic, nonnull, readwrite, strong) UITapGestureRecognizer *selectRecognizer;

- (instancetype _Nullable)initWithBridge:(RCTBridge * _Nullable)bridge NS_DESIGNATED_INITIALIZER;
- (void)cancel;

+ (instancetype _Nullable)instance;

@end
