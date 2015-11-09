//
//  Ship.h
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Ship : NSObject
@property int remaining;
@property int startX; //position on the board
@property int startY;
@property int size;//length of the ship
@property BOOL rotated;
@property int num;
@property NSString *destroyedImage;
@property NSString *image;
@property UIImageView *i;
@property UIImageView *d;
-(instancetype) initWithSize:(int)size withNum:(int)num X:(int)x Y:(int)y image:(NSString*)image destroyedImage:(NSString*)destroyedImage;
@end
