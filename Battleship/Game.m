//
//  Game.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "Game.h"
@interface Game()
@end
@implementation Game
static Game *game = nil;

-(instancetype) initWithMode:(int)mode{
    if (self = [self init]) {
        self.player1 = [[Player alloc]init];
        self.player2 = [[Player alloc]init];
        self.setting = [[Setting alloc]initWithMode:mode];
    }
    return self;
}
+(Game *)getGame
{
    if (game == nil) {
        game = [[Game alloc]init];
    }
    return game;
}
+(void)resetWithMode:(int)mode
{
    game = [[Game alloc]initWithMode:mode];
}

-(int)whoWinTheGame {
    if (self.player1.lose) {
        return 2;
    } else if (self.player2.lose) {
        return 1;
    } else {
        return 0;
    }
}
@end
