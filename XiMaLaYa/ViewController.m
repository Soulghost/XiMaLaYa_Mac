//
//  ViewController.m
//  XiMaLaYa
//
//  Created by soulghost on 3/9/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>


@interface ViewController () <WKNavigationDelegate>

@property (weak) IBOutlet WKWebView *webView;

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];


    
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:@"play" object:nil];

}

- (void)viewWillAppear {
    [super viewWillAppear];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ximalaya.com/explore/"]];
//    [self.webView loadRequest:request];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.ximalaya.com/explore/"] encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"<head>" withString:@"<head>\n\t<script src=\"http://code.jquery.com/jquery-1.11.0.min.js\"></script>"];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.ximalaya.com/explore/"]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

- (void)play {
    [self.webView evaluateJavaScript:@"$('div.left a.playBtn')[0] == null" completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        // playing
        if ([res boolValue] == YES) {
            [self.webView evaluateJavaScript:@"var swallow = $('div.left a.pauseBtn').mousedown();" completionHandler:^(id _Nullable sender, NSError * _Nullable error) {
                
            }];
        } else {
            [self.webView evaluateJavaScript:@"var swallow = $('div.left a.playBtn').mousedown();" completionHandler:^(id _Nullable sender, NSError * _Nullable error) {
                
            }];
        }
    }];
    
}


@end
