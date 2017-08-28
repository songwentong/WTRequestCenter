//
//  ViewController.m
//  ModelMaker
//
//  Created by SongWentong on 24/08/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

#import "ViewController.h"
@import WTKitMacOS;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSLog(@"%@",NSHomeDirectory());
    NSString *desktopPath = [NSString stringWithFormat:@"%@/Desktop",NSHomeDirectory()];
    _pathTextField.cell.stringValue = desktopPath;
    _classNameTextField.cell.stringValue = @"WTModel";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JSONData" ofType:nil];
    if (filePath) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _jsonTextView.string = string;
    }
}

- (IBAction)createButtonAction:(id)sender {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[_jsonTextView.string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        NSLog(@"JSON解析失败");
        return;
    }
    NSString *printModel = [dict WTModelStringFromClassName:_classNameTextField.cell.stringValue];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.h",_pathTextField.cell.stringValue,_classNameTextField.cell.stringValue];
    [printModel writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    printModel = [dict WTimplementationFromClassName:_classNameTextField.cell.stringValue];
    filePath = [NSString stringWithFormat:@"%@/%@.m",_pathTextField.cell.stringValue,_classNameTextField.cell.stringValue];
    [printModel writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)statusLabel:(id)sender {
}
@end
