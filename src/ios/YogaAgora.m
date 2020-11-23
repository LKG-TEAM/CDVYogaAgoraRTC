/********* YogaAgora.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "YogaAgoraShared.h"
#import "YogaAgoraUtil.h"

@interface YogaAgora : CDVPlugin {
  // Member variables go here.
}

@property (nonatomic, assign) NSInteger uiSetFlag;// 1->设置发送端的ui，2->设置接收端的ui

@end

@implementation YogaAgora

- (void)pluginInitialize
{
    [super pluginInitialize];
    [YogaAgoraShared shared].viewController = self.viewController;
    [YogaAgoraShared shared].commandDelegate = self.commandDelegate;
}

- (void)setUp:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setUp:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        if (firstArgument && [firstArgument isKindOfClass:NSDictionary.class]) {
            NSDictionary *params = (NSDictionary *)firstArgument;
            [YogaAgoraShared shared].appId = [params valueForKey:@"appId"];
            [YogaAgoraShared shared].token = [params valueForKey:@"token"];
            [YogaAgoraShared shared].channelId = [params valueForKey:@"channelId"];
            [YogaAgoraShared shared].uid = [params valueForKey:@"uid"];
            
            if ([params valueForKey:@"mainColor"]) {
                NSString *colorStr = [params valueForKey:@"mainColor"];
                if ([colorStr hasPrefix:@"#"]) {
                    [YogaAgoraShared shared].mainColor = [YogaAgoraUtil yoga_colorWithHexString:colorStr alpha:1.0];
                }
            }
            if ([params valueForKey:@"mainBgColor"]) {
                NSString *colorStr = [params valueForKey:@"mainBgColor"];
                if ([colorStr hasPrefix:@"#"]) {
                    [YogaAgoraShared shared].mainBgColor = [YogaAgoraUtil yoga_colorWithHexString:colorStr alpha:1.0];
                }
            }
            if ([params valueForKey:@"mainDisableColor"]) {
                NSString *colorStr = [params valueForKey:@"mainDisableColor"];
                if ([colorStr hasPrefix:@"#"]) {
                    [YogaAgoraShared shared].mainDisableColor = [YogaAgoraUtil yoga_colorWithHexString:colorStr alpha:1.0];
                }
            }
        }
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setUp:]");
}

- (void)agoraSetup:(CDVInvokedUrlCommand*)command isBroadcaster:(BOOL)isBroadcaster
{
    [[YogaAgoraShared shared] launchVideoViewIsBroadcaster:isBroadcaster];
    
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)showWithSheet:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][showWithSheet:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    UIAlertController *infoSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入Agora配置信息(demo内已经默认配置了uid、appId、token，以下的会覆盖默认值，方便测试)" preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *uidTF = nil;
    [infoSheet addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        uidTF = textField;
    }];
    uidTF.placeholder = @"uid(可以不设置，不设置会使用默认值1)";
    uidTF.keyboardType = UIKeyboardTypeNumberPad;
    
    __block UITextField *appIdTF = nil;
    [infoSheet addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        appIdTF = textField;
    }];
    appIdTF.placeholder = @"appId(可以不设置，不设置会使用默认值)";
    
    __block UITextField *tokenTF = nil;
    [infoSheet addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        tokenTF = textField;
    }];
    tokenTF.placeholder = @"token(可以不设置，不设置会使用默认值)";
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [infoSheet addAction:cancelAction];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (appIdTF.text && appIdTF.text.length > 0) {
            [YogaAgoraShared shared].appId = appIdTF.text;
        }
        if (tokenTF.text && tokenTF.text.length > 0) {
            [YogaAgoraShared shared].token = tokenTF.text;
        }
        if (uidTF.text && uidTF.text.length > 0) {
            [YogaAgoraShared shared].uid = uidTF.text;
        }
        [self agoraSetup:command isBroadcaster:YES];
    }];
    [infoSheet addAction:confirmAction];
    [[[YogaAgoraShared shared] topViewController] presentViewController:infoSheet animated:YES completion:nil];
    NSLog(@">>>>>>>>>>>>>>>>[end][showWithSheet:]");
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][show:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    [[YogaAgoraShared shared] launchVideoViewIsBroadcaster:YES];
    NSLog(@">>>>>>>>>>>>>>>>[end][show:]");
}

/************************************* 布局 ****************************************/
- (void)setLocalVideoViewLayout:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setLocalVideoViewLayout:]");
    self.uiSetFlag = 1;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Start setup sender's ui setting"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setLocalVideoViewLayout:]");
}

- (void)setRemoteVideoViewLayout:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setRemoteVideoViewLayout:]");
    self.uiSetFlag = 2;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Start setup receiver's ui setting"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setRemoteVideoViewLayout:]");
}

- (void)setMargin:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setMargin:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 4) {
        NSNumber * firstArgument = command.arguments[0];
        NSNumber * secondArgument = command.arguments[1];
        NSNumber * thirdArgument = command.arguments[2];
        NSNumber * fouthArgument = command.arguments[3];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.margin = UIEdgeInsetsMake([firstArgument floatValue], [secondArgument floatValue], [thirdArgument floatValue], [fouthArgument floatValue]);
        }else {
            [YogaAgoraShared shared].receiver.margin = UIEdgeInsetsMake([firstArgument floatValue], [secondArgument floatValue], [thirdArgument floatValue], [fouthArgument floatValue]);
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setMargin:]");
}

- (void)setMarginTop:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setMarginTop:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.marginTop = [firstArgument floatValue];
        }else {
            [YogaAgoraShared shared].receiver.marginTop = [firstArgument floatValue];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setMarginTop:]");
}

- (void)setMarginLeft:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setMarginLeft:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.marginLeft = [firstArgument floatValue];
        }else {
            [YogaAgoraShared shared].receiver.marginLeft = [firstArgument floatValue];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setMarginLeft:]");
}

- (void)setMarginBottom:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setMarginBottom:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.marginBottom = [firstArgument floatValue];
        }else {
            [YogaAgoraShared shared].receiver.marginBottom = [firstArgument floatValue];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setMarginBottom:]");
}

- (void)setMarginRight:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setMarginRight:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.marginRight = [firstArgument floatValue];
        }else {
            [YogaAgoraShared shared].receiver.marginRight = [firstArgument floatValue];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setMarginRight:]");
}

- (void)setWidth:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setWidth:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.width = [firstArgument floatValue];
        }else {
            [YogaAgoraShared shared].receiver.width = [firstArgument floatValue];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setWidth:]");
}

- (void)setHeight:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setHeight:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments[0];
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.height = [firstArgument floatValue];
        }else {
            [YogaAgoraShared shared].receiver.height = [firstArgument floatValue];
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setHeight:]");
}
/************************************* 布局 ****************************************/

/************************************* Agroa API ****************************************/
- (void)setVideoFrameRate:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setVideoFrameRate:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber * firstArgument = command.arguments.firstObject;
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.videoFrameRate = [firstArgument intValue];
        }
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setVideoFrameRate:]");
}

- (void)setVideoDimension:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setVideoDimension:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 2) {
        NSNumber * firstArgument = command.arguments.firstObject;
        NSNumber * lastArgument = command.arguments.lastObject;
        
        if (self.uiSetFlag == 1) {
            [YogaAgoraShared shared].sender.videoDimension = CGSizeMake([firstArgument doubleValue], [lastArgument doubleValue]);
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setVideoDimension:]");
}

- (void)muteAllRemoteVideoStreams:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][muteAllRemoteVideoStreams:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    int result = -1;
    if (command.arguments.count == 1) {
        NSNumber *firstArgument = command.arguments[0];
        result = [[YogaAgoraShared shared] muteAllRemoteVideoStreams:[firstArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",result]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][muteAllRemoteVideoStreams:]");
}

- (void)muteAllRemoteAudioStreams:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][muteAllRemoteAudioStreams:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    int result = -1;
    if (command.arguments.count == 1) {
        NSNumber *firstArgument = command.arguments[0];
        result = [[YogaAgoraShared shared] muteAllRemoteAudioStreams:[firstArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",result]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][muteAllRemoteAudioStreams:]");
}

- (void)muteRemoteVideoStream:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][muteRemoteVideoStream:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    int result = -1;
    if (command.arguments.count == 2) {
        NSNumber *firstArgument = command.arguments[0];
        NSNumber *secondArgument = command.arguments[1];
        result = [[YogaAgoraShared shared] muteRemoteVideoStream:[firstArgument integerValue] mute:[secondArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",result]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][muteRemoteVideoStream:]");
}

- (void)muteRemoteAudioStream:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][muteRemoteAudioStream:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    int result = -1;
    if (command.arguments.count == 2) {
        NSNumber *firstArgument = command.arguments[0];
        NSNumber *secondArgument = command.arguments[1];
        result = [[YogaAgoraShared shared] muteRemoteAudioStream:[firstArgument integerValue] mute:[secondArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",result]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][muteRemoteAudioStream:]");
}

- (void)muteLocalVideo:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][muteLocalVideo:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    int result = -1;
    if (command.arguments.count == 1) {
        NSNumber *firstArgument = command.arguments[0];
        result = [[YogaAgoraShared shared] muteLocalVideo:[firstArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",result]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][muteLocalVideo:]");
}

- (void)muteLocalAudio:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][muteLocalAudio:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    int result = -1;
    if (command.arguments.count == 1) {
        NSNumber *firstArgument = command.arguments[0];
        result = [[YogaAgoraShared shared] muteLocalAudio:[firstArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",result]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][muteLocalAudio:]");
}

- (void)leave:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][leave:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    [[YogaAgoraShared shared] leave];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][leave:]");
}
/************************************* Agroa API ****************************************/

/************************************* UI属性设置 ****************************************/
- (void)addRemoteUserView:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][addRemoteUserView:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count >= 1) {
        NSNumber * firstArgument = command.arguments[0];
        NSString *title = nil;
        if (command.arguments.count >= 2) {
            title = command.arguments[1];
        }
        [[YogaAgoraShared shared].receiver addReceiverView];
        [[YogaAgoraShared shared].receiver receiverViewRemakeConstraints];
        [[YogaAgoraShared shared].receiver addUid:[firstArgument integerValue] title:title];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][addRemoteUserView:]");
}

- (void)setRemoteViewScrollDirection:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setRemoteViewScrollDirection:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber *firstArgument = command.arguments[0];
        [[YogaAgoraShared shared] setCollectionViewScrollDirection:[firstArgument boolValue]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setRemoteViewScrollDirection:]");
}

- (void)setRemoteViewItemSize:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setRemoteViewItemSize:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 2) {
        NSNumber *firstArgument = command.arguments[0];
        NSNumber *secondArgument = command.arguments[1];
        [[YogaAgoraShared shared] setCollectionViewItemSize:CGSizeMake([firstArgument floatValue], [secondArgument floatValue])];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setRemoteViewItemSize:]");
}

- (void)setLocalTitle:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][setLocalTitle:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSString *firstArgument = command.arguments[0];
        [YogaAgoraShared shared].sender.title = firstArgument;
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][setLocalTitle:]");
}

- (void)removeLocalView:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][removeLocalView:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
//    [[YogaAgoraShared shared] leave];
    [[YogaAgoraShared shared].sender.senderView removeFromSuperview];
    [YogaAgoraShared shared].sender.senderView = nil;
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][removeLocalView:]");
}

- (void)removeRemoteView:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][removeRemoteView:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
//    [[YogaAgoraShared shared] leave];
    [[YogaAgoraShared shared].receiver.receiverView removeFromSuperview];
    [YogaAgoraShared shared].receiver.receiverView = nil;
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][removeRemoteView:]");
}

- (void)viewClean:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][viewClean:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSNumber *firstArgument = command.arguments[0];
        [YogaAgoraShared shared].sender.viewClean = [firstArgument boolValue];
        [YogaAgoraShared shared].receiver.viewClean = [firstArgument boolValue];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][viewClean:]");
}
/************************************* UI属性设置 ****************************************/

@end
