//
//  ViewController.h
//  ModelMaker
//
//  Created by SongWentong on 24/08/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSTextField *classNameTextField;
@property (weak) IBOutlet NSButton *createButton;
@property (weak) IBOutlet NSTextField *statusLabel;



@end

