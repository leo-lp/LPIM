//
//  LPSessionUtil.swift
//  LPIM
//
//  Created by lipeng on 2017/6/18.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation
import NIMSDK

//double OnedayTimeIntervalValue = 24*60*60;  //一天的秒数

private let kLPRecentSessionAtMark = "kLPRecentSessionAtMark"

//+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
//                                  minSize:(CGSize)imageMinSize
//                                  maxSize:(CGSize)imageMaxSize;
//
////接收时间格式化
//+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;
//
//+ (void)sessionWithInputURL:(NSURL*)inputURL
//                  outputURL:(NSURL*)outputURL
//               blockHandler:(void (^)(AVAssetExportSession*))handler;
//
//
//+ (NSDictionary *)dictByJsonData:(NSData *)data;
//
//+ (NSDictionary *)dictByJsonString:(NSString *)jsonString;
//
//+ (BOOL)canMessageBeForwarded:(NIMMessage *)message;
//
//+ (BOOL)canMessageBeRevoked:(NIMMessage *)message;
//
//+ (NSString *)tipOnMessageRevoked:(id)message;
//
//+ (void)addRecentSessionAtMark:(NIMSession *)session;
//
//+ (void)removeRecentSessionAtMark:(NIMSession *)session;

class LPSessionUtil {
    
    class func formatAutoLoginMessage(error: NSError) -> String {
        var msg = "自动登录失败 \(error)"
        let domain = error.domain
        let code = error.code
        if domain == NIMLocalErrorDomain {
            if code == NIMLocalErrorCode.autoLoginRetryLimit.rawValue {
                msg = "自动登录错误次数超限，请检查网络后重试"
            }
        } else if domain == NIMRemoteErrorDomain {
            if code == NIMRemoteErrorCode.codeInvalidPass.rawValue {
                msg = "密码错误"
            } else if code == NIMRemoteErrorCode.codeExist.rawValue {
                msg = "当前已经其他设备登录，请使用手动模式登录"
            }
        }
        return msg
    }
    
    class func onlineState(_ userId: String, detail: Bool) -> String {
        //    NSString *state = @"";
        var state = ""
        
        //    if (![NTESSubscribeManager sharedManager])
        //    {
        //        //没有开启订阅服务
        //        return state;
        //    }
        
        
        //
        //    NSDictionary *dict = [[NTESSubscribeManager sharedManager] eventsForType:NIMSubscribeSystemEventTypeOnline];
        //    NIMSubscribeEvent *event = [dict objectForKey:userId];
        //    NIMSubscribeOnlineInfo *info = event.subscribeInfo;
        //    if ([info isKindOfClass:[NIMSubscribeOnlineInfo class]] && info.senderClientTypes.count)
        //    {
        //        NIMLoginClientType client = [self resolveShowClientType:info.senderClientTypes];
        //
        //        switch (event.value) {
        //            case NTESCustomStateValueOnlineExt:
        //            case NIMSubscribeEventOnlineValueLogin:
        //            case NIMSubscribeEventOnlineValueLogout:
        //            case NIMSubscribeEventOnlineValueDisconnected:
        //            {
        //                NSString *ext = [event ext:client];
        //                state = [self resolveOnlineState:ext client:client detail:detail];
        //            }
        //                break;
        //
        //            default:
        //            {
        //                NSString *clientName = [self resolveOnlineClientName:client];
        //                state = [NSString stringWithFormat:@"%@在线",clientName];
        //                break;
        //            }
        //        }
        //    }
        //    else
        //    {
        //        state = [userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]? @"" : @"离线";
        //    }
        
        return state
    }
    
    class func recentSessionIsAtMark(_ recent: NIMRecentSession) -> Bool {
        if let localExt = recent.localExt, let obj = localExt[kLPRecentSessionAtMark] {
            return (obj as AnyObject).boolValue
        }
        return false
    }
    
    class func showNick(_ uid: String, session: NIMSession?) -> String? {
        var nickname: String? = nil
        if let session = session, session.sessionType == .team {
            let member = NIMSDK.shared().teamManager.teamMember(uid, inTeam: session.sessionId)
            nickname = member?.nickname
        }
        
        if let nickname = nickname, nickname.characters.count > 0 {
            return nickname
        }
        
        let info = LPKKit.shared.info(byUser: uid, option: nil)
        return info?.showName
    }
}



//
//@implementation NTESSessionUtil
//
//+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
//                                  minSize:(CGSize)imageMinSize
//                                  maxSize:(CGSize)imageMaxSiz
//{
//    CGSize size;
//    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
//    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
//    NSInteger imageMaxWidth = imageMaxSiz.width, imageMaxHeight = imageMaxSiz.height;
//    if (imageWidth > imageHeight) //宽图
//    {
//        size.height = imageMinHeight;  //高度取最小高度
//        size.width = imageWidth * imageMinHeight / imageHeight;
//        if (size.width > imageMaxWidth)
//        {
//            size.width = imageMaxWidth;
//        }
//    }
//    else if(imageWidth < imageHeight)//高图
//    {
//        size.width = imageMinWidth;
//        size.height = imageHeight *imageMinWidth / imageWidth;
//        if (size.height > imageMaxHeight)
//        {
//            size.height = imageMaxHeight;
//        }
//    }
//    else//方图
//    {
//        if (imageWidth > imageMaxWidth)
//        {
//            size.width = imageMaxWidth;
//            size.height = imageMaxHeight;
//        }
//        else if(imageWidth > imageMinWidth)
//        {
//            size.width = imageWidth;
//            size.height = imageHeight;
//        }
//        else
//        {
//            size.width = imageMinWidth;
//            size.height = imageMinHeight;
//        }
//    }
//    return size;
//}
//
//
//+(BOOL)isTheSameDay:(NSTimeInterval)currentTime compareTime:(NSDateComponents*)older
//{
//    NSCalendarUnit currentComponents = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute);
//    NSDateComponents *current = [[NSCalendar currentCalendar] components:currentComponents fromDate:[NSDate dateWithTimeIntervalSinceNow:currentTime]];
//
//    return current.year == older.year && current.month == older.month && current.day == older.day;
//}
//
//+(NSString*)weekdayStr:(NSInteger)dayOfWeek
//{
//    static NSDictionary *daysOfWeekDict = nil;
//    daysOfWeekDict = @{@(1):@"星期日",
//                       @(2):@"星期一",
//                       @(3):@"星期二",
//                       @(4):@"星期三",
//                       @(5):@"星期四",
//                       @(6):@"星期五",
//                       @(7):@"星期六",};
//    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
//}
//
//
//+(NSDateComponents*)stringFromTimeInterval:(NSTimeInterval)messageTime components:(NSCalendarUnit)components
//{
//    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:components fromDate:[NSDate dateWithTimeIntervalSince1970:messageTime]];
//    return dateComponents;
//}
//
//

//
//
//+(NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail
//{
//    //今天的时间
//    NSDate * nowDate = [NSDate date];
//    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
//    NSString *result = nil;
//    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
//    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
//    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
//
//    NSInteger hour = msgDateComponents.hour;
//
//    result = [NTESSessionUtil getPeriodOfTime:hour withMinute:msgDateComponents.minute];
//    if (hour > 12)
//    {
//        hour = hour - 12;
//    }
//    if(nowDateComponents.day == msgDateComponents.day) //同一天,显示时间
//    {
//        result = [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute];
//    }
//    else if(nowDateComponents.day == (msgDateComponents.day+1))//昨天
//    {
//        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
//    }
//    else if(nowDateComponents.day == (msgDateComponents.day+2)) //前天
//    {
//        result = showDetail? [[NSString alloc] initWithFormat:@"前天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"前天";
//    }
//    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//一周内
//    {
//        NSString *weekDay = [NTESSessionUtil weekdayStr:msgDateComponents.weekday];
//        result = showDetail? [weekDay stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : weekDay;
//    }
//    else//显示日期
//    {
//        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
//        result = showDetail? [day stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
//    }
//    return result;
//}
//
//+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
//{
//    NSInteger totalMin = time *60 + minute;
//    NSString *showPeriodOfTime = @"";
//    if (totalMin > 0 && totalMin <= 5 * 60)
//    {
//        showPeriodOfTime = @"凌晨";
//    }
//    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
//    {
//        showPeriodOfTime = @"上午";
//    }
//    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
//    {
//        showPeriodOfTime = @"下午";
//    }
//    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
//    {
//        showPeriodOfTime = @"晚上";
//    }
//    return showPeriodOfTime;
//}
//
//
//+ (void)sessionWithInputURL:(NSURL*)inputURL
//                  outputURL:(NSURL*)outputURL
//               blockHandler:(void (^)(AVAssetExportSession*))handler
//{
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
//    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset
//                                                                     presetName:AVAssetExportPresetMediumQuality];
//    session.outputURL = outputURL;
//    session.outputFileType = AVFileTypeMPEG4;   // 支持安卓某些机器的视频播放
//    session.shouldOptimizeForNetworkUse = YES;
//    [session exportAsynchronouslyWithCompletionHandler:^(void)
//     {
//         handler(session);
//     }];
//}
//
//
//+ (NSDictionary *)dictByJsonData:(NSData *)data
//{
//    NSDictionary *dict = nil;
//    if ([data isKindOfClass:[NSData class]])
//    {
//        NSError *error = nil;
//        dict = [NSJSONSerialization JSONObjectWithData:data
//                                               options:0
//                                                 error:&error];
//        if (error) {
//            DDLogError(@"dictByJsonData failed %@ error %@",data,error);
//        }
//    }
//    return [dict isKindOfClass:[NSDictionary class]] ? dict : nil;
//}
//
//
//+ (NSDictionary *)dictByJsonString:(NSString *)jsonString
//{
//    if (!jsonString.length) {
//        return nil;
//    }
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    return [NTESSessionUtil dictByJsonData:data];
//}
//
//
//+ (NSString *)tipOnMessageRevoked:(id)message
//{
//    NSString *fromUid = nil;
//    NIMSession *session = nil;
//
//    if ([message isKindOfClass:[NIMMessage class]])
//    {
//        fromUid = [(NIMMessage *)message from];
//        session = [(NIMMessage *)message session];
//    }
//    else if([message isKindOfClass:[NIMRevokeMessageNotification class]])
//    {
//        fromUid = [(NIMRevokeMessageNotification *)message fromUserId];
//        session = [(NIMRevokeMessageNotification *)message session];
//    }
//    else
//    {
//        assert(0);
//    }
//
//    BOOL isFromMe = [fromUid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
//    NSString *tip = @"你";
//    if (!isFromMe) {
//        switch (session.sessionType) {
//            case NIMSessionTypeP2P:
//                tip = @"对方";
//                break;
//            case NIMSessionTypeTeam:{
//                NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
//                option.session = session;
//                NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:fromUid option:option];
//                tip = info.showName;
//            }
//                break;
//            default:
//                    break;
//        }
//    }
//    return [NSString stringWithFormat:@"%@撤回了一条消息",tip];
//}
//
//
//+ (BOOL)canMessageBeForwarded:(NIMMessage *)message
//{
//    if (!message.isReceivedMsg && message.deliveryState == NIMMessageDeliveryStateFailed) {
//        return NO;
//    }
//    id<NIMMessageObject> messageobject = message.messageObject;
//    if ([messageobject isKindOfClass:[NIMCustomObject class]]
//        && ([[(NIMCustomObject *)messageobject attachment] isKindOfClass:[NTESSnapchatAttachment class]]
//            || [[(NIMCustomObject *)messageobject attachment] isKindOfClass:[NTESWhiteboardAttachment class]])) {
//            return NO;
//        }
//    if ([messageobject isKindOfClass:[NIMNotificationObject class]]) {
//        return NO;
//    }
//    if ([messageobject isKindOfClass:[NIMTipObject class]]) {
//        return NO;
//    }
//    return YES;
//}
//
//+ (BOOL)canMessageBeRevoked:(NIMMessage *)message
//{
//    BOOL isFromMe = [message.from isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
//    BOOL isToMe   = [message.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
//    BOOL isDeliverFailed = !message.isReceivedMsg && message.deliveryState == NIMMessageDeliveryStateFailed;
//    if (!isFromMe || isToMe || isDeliverFailed) {
//        return NO;
//    }
//    id<NIMMessageObject> messageobject = message.messageObject;
//    if ([messageobject isKindOfClass:[NIMTipObject class]]
//        || [messageobject isKindOfClass:[NIMNotificationObject class]]) {
//        return NO;
//    }
//    if ([messageobject isKindOfClass:[NIMCustomObject class]]
//        && ([[(NIMCustomObject *)messageobject attachment] isKindOfClass:[NTESWhiteboardAttachment class]])) {
//            return NO;
//    }
//    return YES;
//}
//
//
//+ (void)addRecentSessionAtMark:(NIMSession *)session
//{
//    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//    if (recent)
//    {
//        NSDictionary *localExt = recent.localExt?:@{};
//        NSMutableDictionary *dict = [localExt mutableCopy];
//        [dict setObject:@(YES) forKey:kLPRecentSessionAtMark];
//        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
//    }
//
//
//}
//
//+ (void)removeRecentSessionAtMark:(NIMSession *)session
//{
//    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//    if (recent) {
//        NSMutableDictionary *localExt = [recent.localExt mutableCopy];
//        [localExt removeObjectForKey:kLPRecentSessionAtMark];
//        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recent];
//    }
//}
//
//+ (NIMLoginClientType)resolveShowClientType:(NSArray *)senderClientTypes
//{
//    NSArray *clients = @[@(NIMLoginClientTypePC),@(NIMLoginClientTypeiOS),@(NIMLoginClientTypeAOS),@(NIMLoginClientTypeWeb),@(NIMLoginClientTypeWP)]; //显示优先级
//    for (NSNumber *type in clients) {
//        NIMLoginClientType client = type.integerValue;
//        if ([senderClientTypes containsObject:@(client)]) {
//            return client;
//        }
//    }
//    return NIMLoginClientTypeUnknown;
//}
//
//+ (NSString *)resolveOnlineClientName:(NIMLoginClientType )client
//{
//    NSDictionary *formats  = @{
//                              @(NIMLoginClientTypePC) : @"电脑",
//                              @(NIMLoginClientTypeiOS): @"iOS",
//                              @(NIMLoginClientTypeAOS): @"Android",
//                              @(NIMLoginClientTypeWeb): @"Web",
//                              @(NIMLoginClientTypeWP) : @"WP"
//                             };
//
//    NSString *format = [formats objectForKey:@(client)];
//    return format? format : @"";
//}
//
//+ (NSString *)resolveOnlineState:(NSString *)ext client:(NIMLoginClientType)client detail:(BOOL)detail
//{
//    NSString *clientName = [self resolveOnlineClientName:client];
//    NSString *state = [NSString stringWithFormat:@"%@在线",clientName];
//    NSDictionary *dict = [ext nimkit_jsonDict];
//    if (dict) {
//
//        NSString *netState =  [[NTESDevice currentDevice] networkStatus:[dict jsonInteger:NTESSubscribeNetState]];
//        NTESOnlineState onlineState =  [dict jsonInteger:NTESSubscribeOnlineState];
//        switch (onlineState) {
//            case NTESOnlineStateNormal:
//            {
//                if (client == NIMLoginClientTypePC || client == NIMLoginClientTypeWeb)
//                {
//                    //桌面端不显示网络状态，只显示端
//                    return [NSString stringWithFormat:@"%@在线",clientName];
//                }
//                else
//                {
//                    //移动端在会话列表显示网络状态，在会话内（detail）优先显示端+网络状态
//                    if (detail)
//                    {
//                        return [NSString stringWithFormat:@"%@ - %@ 在线",clientName,netState];
//                    }
//                    else
//                    {
//                        return [NSString stringWithFormat:@"%@ 在线",netState];
//                    }
//                }
//            }
//            case NTESOnlineStateBusy:
//                return @"忙碌";
//            case NTESOnlineStateLeave:
//                return @"离开";
//            default:
//                break;
//        }
//    }
//    return state;
//}
//

