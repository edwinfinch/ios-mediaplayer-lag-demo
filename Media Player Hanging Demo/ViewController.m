//
//  ViewController.m
//  Media Player Hanging Demo
//
//  Created by Edwin Finch on 1/4/18.
//  Copyright © 2018 Lignite. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"

@interface ViewController ()

/**
 The system music player.
 */
@property MPMusicPlayerController *musicPlayer;

/**
 The timer for viewing lag spikes.
 */
@property NSTimer *lagTestTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
	
	if([MPMediaQuery songsQuery].items.count == 0){
		self.statusLabel.text = @"You have no tracks in your library.\n\nIf you just accepted the music permission, please re-launch the app.\n\n(Sorry, I am not gonna spend time building a permission checking solution for a demo app)";
		
		self.playPauseButton.hidden = YES;
	}
	else{
		self.statusLabel.text = [NSString stringWithFormat:@"%lu tracks in your library", [MPMediaQuery songsQuery].items.count];
		
		NSNotificationCenter *notificationCentre = [NSNotificationCenter defaultCenter];
		
		//Centre is the correct spelling ;)
		[notificationCentre
		 addObserver:self
		 selector:@selector(systemMusicPlayerStateChanged:)
		 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
		 object:self.musicPlayer];
		
		MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];
		[mediaLibrary beginGeneratingLibraryChangeNotifications];
		
		[self.musicPlayer beginGeneratingPlaybackNotifications];
	}
}

- (void)updateLagTestLabelText {
	self.statusLabel.text = [NSString stringWithFormat:@"Playing.\n\n%fs", self.musicPlayer.currentPlaybackTime];
}

- (void)systemMusicPlayerStateChanged:(id)sender {
	BOOL playing = (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying);
	
	if([self.lagTestTimer isValid]){
		[self.lagTestTimer invalidate];
	}
	
	if(playing){
		//Create a timer on the main thread which constantly updates the now playing time. Since nothing else is going on within the app, we can know whether or not the system is hung by viewing the text of statusLabel on screen.
		self.lagTestTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
															 target:self
														   selector:@selector(updateLagTestLabelText)
														   userInfo:nil
															repeats:YES];
	}
	else{
		self.statusLabel.text = [NSString stringWithFormat:@"Paused."];
	}
	
	[self.playPauseButton setTitle:playing ? @"Pause" : @"Play all tracks" forState:UIControlStateNormal];
}

- (IBAction)playPauseButtonTapped:(id)sender {
	//Removing the setQueueWithQuery: line reduces lag, but not by much, in my tests.
	[self.musicPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
	
	if(self.musicPlayer.playbackState != MPMusicPlaybackStatePlaying){
		//Playing music seems to be where the trouble is. In my tests, pausing music does not cause any signifigant lag.
		[self.musicPlayer play];
	}
	else{
		[self.musicPlayer pause];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
