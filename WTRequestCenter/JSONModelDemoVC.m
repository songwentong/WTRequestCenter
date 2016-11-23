//
//  JSONModelDemoVC.m
//  WTRequestCenter
//
//  Created by SongWentong on 23/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import "JSONModelDemoVC.h"
#import "NSDictionary+JSONModel.h"
@interface JSONModelDemoVC ()
@property (weak, nonatomic) IBOutlet UITextView *jsonTextView;

@end

@implementation JSONModelDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *path = [n]
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JSONData" ofType:nil]];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _jsonTextView.text = string;
}
- (IBAction)print:(id)sender {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[_jsonTextView.text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    NSLog(@"%@",[dict WTModelString]);
}
- (IBAction)writeToFile:(id)sender {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[_jsonTextView.text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *printModel = [dict WTModelString];
#if TARGET_OS_SIMULATOR
    //模拟器写到桌面
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    __block NSURL *url = nil;
    [[defaultManager contentsOfDirectoryAtURL:[NSURL URLWithString:@"/Users"] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil] enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        if ([homePath containsString:[[obj absoluteString] substringFromIndex:7]]) {
            url = [obj URLByAppendingPathComponent:@"Desktop"];
            NSLog(@"%@",url);
        }
    }];
    if (url) {
        NSLog(@"writefile to:%@",homePath);
//        NSString *filePath = [NSString stringWithFormat:@"%@/XXX.h",NSHomeDirectory()];
        [printModel writeToURL:[url URLByAppendingPathComponent:@"XXX.h"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        [printModel writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        NSString *path2 = [NSString stringWithFormat:@"%@/XXX.m",NSHomeDirectory()];
        [@"@implementation XXX\n-(id)WTJSONModelProtocolInstanceForKey:(NSString*)key{\n    return nil;\n}\n@end" writeToURL:[url URLByAppendingPathComponent:@"XXX.m"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
#else
    NSLog(@"请用模拟器运行,这样可以把文件写到桌面");
    return;
#endif
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
