//
//  ViewController.h
//  Media Player Hanging Demo
//
//  Created by Edwin Finch on 1/4/18.
//  Copyright © 2018 Lignite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/**
 The label for displaying whether or not music is playing/paused. As well, this label will update the now playing time of the current track if music is playing every 0.1 seconds, which should easily demonstrate the lag on iOS 11.2.
 */
@property IBOutlet UILabel *statusLabel;

/**
 The play/pause button for changing the current playback state.
 */
@property IBOutlet UIButton *playPauseButton;

@end

