//
//  Player.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "Player.h"

@interface Player()
@property SystemSoundID destroySound;
@property SystemSoundID winSound;
@end

@implementation Player
#define board_size 10
-(instancetype) init{
    if (self = [super init]) {
        _board = [[NSMutableArray alloc] initWithCapacity:board_size];
        for (int i = 0; i < board_size; i++) {
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:board_size];
            for (int j = 0; j < board_size; j++) {
                [row insertObject:@0 atIndex:j];
            }
            [_board insertObject:row atIndex:i];
        }
        _board[0][0] = @10;
        _board[0][1] = @10;
        _board[0][2] = @10;
        _board[0][3] = @10;
        _board[0][4] = @10;
        _board[1][0] = @11;
        _board[1][1] = @11;
        _board[1][2] = @11;
        _board[1][3] = @11;
        _board[2][0] = @12;
        _board[2][1] = @12;
        _board[2][2] = @12;
        _board[3][0] = @13;
        _board[3][1] = @13;
        _board[3][2] = @13;
        _board[4][0] = @14;
        _board[4][1] = @14;
        self.playerNumOfShip = 5;
        self.lose = NO;
        _ships = [[NSArray alloc]initWithObjects:[[Ship alloc]initWithSize:5 withNum:0 X:0 Y:0 image:@"ship5.png" destroyedImage:@"ship5D.png"],
                  [[Ship alloc]initWithSize:4 withNum:1 X:1 Y:0 image:@"ship4.png" destroyedImage:@"ship4D.png"],
                  [[Ship alloc]initWithSize:3 withNum:2 X:2 Y:0 image:@"ship3.png" destroyedImage:@"ship3D.png"],
                  [[Ship alloc]initWithSize:3 withNum:3 X:3 Y:0 image:@"ship3.png" destroyedImage:@"ship3D.png"],
                  [[Ship alloc]initWithSize:2 withNum:4 X:4 Y:0 image:@"ship2.png" destroyedImage:@"ship2D.png"], nil];
    }
    NSString *destroy = [[NSBundle mainBundle] pathForResource:@"destroy" ofType:@"caf"];
    NSURL *destroyURL = [NSURL fileURLWithPath:destroy];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)destroyURL, &_destroySound);
    NSString *win = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"caf"];
    NSURL *winURL = [NSURL fileURLWithPath:win];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)winURL, &_winSound);
    return self;
}
-(void)hitted:(int)num {
    Ship *ship = self.ships[num - 10];
    ship.remaining -= 1;
    if (ship.remaining == 0) {
        // Play the sound
        AudioServicesPlaySystemSound(self.destroySound);
        self.playerNumOfShip -= 1;
        if (self.playerNumOfShip == 0) {
            AudioServicesPlaySystemSound(self.winSound);
            self.lose = YES;
        }
    }
}
-(int)AIPlay{
    for (int i = 0; i < 5; i++) {
        Ship *ship = self.ships[i];
        if (ship.remaining < ship.size && ship.remaining > 0) {
            if (ship.size - ship.remaining == 1) {
                int x = 0, y = 0;
                if (ship.rotated) {
                    for (int j = 0; j < ship.size; j++) {
                        if ([self.board[ship.startX + j][ship.startY] isEqual:@2]) {
                            x = ship.startX + j;
                            y = ship.startY;
                        }
                    }
                } else {
                    for (int j = 0; j < ship.size; j++) {
                        if ([self.board[ship.startX][ship.startY + j] isEqual:@2]) {
                            x = ship.startX;
                            y = ship.startY + j;
                        }
                    }
                }
                int rx = 0, ry = 0;
                do {
                    int ran = arc4random_uniform(4);
                    switch (ran) {
                        case 0:
                            rx = x - 1;
                            ry = y;
                            break;
                            
                        case 1:
                            rx = x + 1;
                            ry = y;
                            break;
                            
                        case 2:
                            rx = x;
                            ry = y - 1;
                            break;
                            
                        case 3:
                            rx = x;
                            ry = y + 1;
                            break;
                            
                        default:
                            break;
                    }
                } while (rx < 0 || rx > 9 || ry < 0 || ry > 9);
                return rx * 10 + ry;
            } else {
                if (ship.rotated) {
                    for (int j = 0; j < ship.size; j++) {
                        if (![self.board[ship.startX + j][ship.startY] isEqual:@2]) {
                            if ((ship.startX + j + 1 <= 9 && [self.board[ship.startX + j + 1][ship.startY] isEqual:@2])
                                || (ship.startX + j - 1 >= 0 && [self.board[ship.startX + j - 1][ship.startY] isEqual:@2])) {
                                return (ship.startX + j) * 10 + ship.startY;
                            }
                        }
                    }
                } else {
                    for (int j = 0; j < ship.size; j++) {
                        if (![self.board[ship.startX][ship.startY + j] isEqual:@2]) {
                            if ((ship.startY + j + 1 <= 9 && [self.board[ship.startX][ship.startY + j + 1] isEqual:@2])
                                || (ship.startY + j - 1 >= 0 && [self.board[ship.startX][ship.startY + j - 1] isEqual:@2])) {
                                return (ship.startX) * 10 + ship.startY + j;
                            }
                        }
                    }
                }
            }
        }
    }
    int x = arc4random_uniform(10);
    int y = arc4random_uniform(10);
    return x * 10 + y;
}
-(void)AIDeploy {
    _board[0][0] = @0;
    _board[0][1] = @0;
    _board[0][2] = @0;
    _board[0][3] = @0;
    _board[0][4] = @0;
    _board[1][0] = @0;
    _board[1][1] = @0;
    _board[1][2] = @0;
    _board[1][3] = @0;
    _board[2][0] = @0;
    _board[2][1] = @0;
    _board[2][2] = @0;
    _board[3][0] = @0;
    _board[3][1] = @0;
    _board[3][2] = @0;
    _board[4][0] = @0;
    _board[4][1] = @0;
    for (int i = 0; i < 5; i++) {
        Ship *ship = self.ships[i];
        if (arc4random_uniform(2) == 1) {
            ship.rotated = YES;
        } else {
            ship.rotated = NO;
        }
        int x = 0, y = 0;
        do {
            if (ship.rotated) {
                x = arc4random_uniform(10 - ship.size);
                y = arc4random_uniform(10);
            } else {
                x = arc4random_uniform(10);
                y = arc4random_uniform(10 - ship.size);
            }
        } while ([self shipOverlap:x and:y length:ship.size rotated:ship.rotated]);
        ship.startX = x;
        ship.startY = y;
        for (int j = 0; j < ship.size; j++) {
            if (ship.rotated) {
                self.board[x + j][y] = [NSNumber numberWithInt:(10 + i)];
            } else {
                self.board[x][y + j] = [NSNumber numberWithInt:(10 + i)];
            }
        }
    }
    //    uncomment this to see The AI deployment
    //    NSLog(@"%@",self.board);
}
-(bool)shipOverlap:(int)x and:(int)y length:(int)size rotated:(BOOL)rotated {
    for (int i = 0; i < size; i++) {
        if (rotated) {
            if (!([self.board[x + i][y] isEqual:@0])) {
                return YES;
            }
        } else {
            if (!([self.board[x][y + i] isEqual:@0])) {
                return YES;
            }
        }
    }
    return NO;
}

@end

