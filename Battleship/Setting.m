//
//  Setting.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "Setting.h"

@implementation Setting
-(instancetype) initWithMode:(int)mode{
    self = [self init];
    self.mode = mode;
    self.playTurn = 0;
    return self;
}
@end
