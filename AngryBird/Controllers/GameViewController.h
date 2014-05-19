//
//  GameViewController.h
//  AngryBird
//
//  Created by Kiran Gangadharan on 19/05/14.
//  Copyright (c) 2014 kiran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bird;
@property (weak, nonatomic) IBOutlet UIImageView *TopWall;
@property (weak, nonatomic) IBOutlet UIImageView *BottomWall;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
