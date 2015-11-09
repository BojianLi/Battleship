//
//  Setting.h
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject
@property int mode;//0,1player; 1,2players
@property int playTurn;//0: player1, 1:player2
-(instancetype) initWithMode:(int)mode;
@end