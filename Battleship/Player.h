//
//  Player.h
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@interface Player : NSObject

@property NSMutableArray *board;//0:empty 1:miss 2:hitted >10 ship
@property NSArray *ships;//5,4,3,3,2
@property NSMutableArray *rotated;
@property int playerNumOfShip;
@property BOOL lose;
-(void)hitted:(int)num;
-(int)AIPlay;
-(void)AIDeploy;
@end
