var exec = require('cordova/exec');

var AgoraRTC_IOS = {};
    
/************************************* Agroa 事件回调 ****************************************/
/*
    事件监听
*/
AgoraRTC_IOS.on = function (callbackName, success, error) {
    exec(success, error, 'YogaAgora', 'on', [callbackName]);
};
/************************************* Agroa 事件回调 ****************************************/
    
/************************************* Util ****************************************/
/*
    调用原生日志方法
    log 日志
*/
AgoraRTC_IOS.NSLog = function (log, success, error) {
    exec(success, error, 'YogaAgora', 'NSLog', [log]);
};

/*
    跳转内置safari
    url 要访问的地址
*/
AgoraRTC_IOS.safari = function (url, success, error) {
    exec(success, error, 'YogaAgora', 'safari', [url]);
};
    
/*
    内置safari dismiss
*/
AgoraRTC_IOS.dismiss = function (success, error) {
    exec(success, error, 'YogaAgora', 'dismiss', []);
};
    
/*
    内置safari share
*/
AgoraRTC_IOS.share = function (url, success, error) {
    exec(success, error, 'YogaAgora', 'share', [url]);
};
/************************************* Util ****************************************/
    
module.exports = AgoraRTC_IOS;