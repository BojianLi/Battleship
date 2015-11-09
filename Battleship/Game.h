//
//  Game.h
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Setting.h"

@interface Game : NSObject

@property Player *player1;
@property Player *player2;
@property Setting *setting;
+(Game*)getGame;
+(void)resetWithMode:(int)mode;
-(instancetype) initWithMode:(int)mode;
-(int)whoWinTheGame;//0:no one; 1:player1; 2:player2
@end

