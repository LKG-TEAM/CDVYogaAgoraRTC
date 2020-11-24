var exec = require('cordova/exec');

var AgoraRTC = {};
AgoraRTC.setUp = function (params, success, error) {
    exec(success, error, 'YogaAgora', 'setUp', [params]);
    return AgoraRTC;
};

AgoraRTC.join = function (success, error) {
    exec(success, error, 'YogaAgora', 'join', []);
};
    
AgoraRTC.joinWithSheet = function (success, error) {
    exec(success, error, 'YogaAgora', 'joinWithSheet', []);
};

/************************************* 布局 ****************************************/
/*
 设置本地视频view的布局约束
*/
AgoraRTC.setLocalVideoViewLayout = function (success, error) {
    exec(success, error, 'YogaAgora', 'setLocalVideoViewLayout', []);
};

/*
 设置远程视频view的布局约束
*/
AgoraRTC.setRemoteVideoViewLayout = function (success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteVideoViewLayout', []);
};
    
AgoraRTC.setMargin = function (top, left, bottom, right, success, error) {
    exec(success, error, 'YogaAgora', 'setMargin', [top, left, bottom, right]);
};
    
AgoraRTC.setMarginTop = function (top, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginTop', [top]);
};

AgoraRTC.setMarginLeft = function (left, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginLeft', [left]);
};

AgoraRTC.setMarginBottom = function (bottom, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginBottom', [bottom]);
};

AgoraRTC.setMarginRight = function (right, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginRight', [right]);
};

AgoraRTC.setWidth = function (width, success, error) {
    exec(success, error, 'YogaAgora', 'setWidth', [width]);
};

AgoraRTC.setHeight = function (height, success, error) {
    exec(success, error, 'YogaAgora', 'setHeight', [height]);
};
/************************************* 布局 ****************************************/

/************************************* Agroa API ****************************************/
/*
 设置本地视频采集fps(默认30)
 width
 height
*/
AgoraRTC.setVideoFrameRate = function (videoFrameRate, success, error) {
    exec(success, error, 'YogaAgora', 'setVideoFrameRate', [videoFrameRate]);
};

/*
 设置本地视频采集分辨率(默认320x240)
 width
 height
*/
AgoraRTC.setVideoDimension = function (width, height, success, error) {
    exec(success, error, 'YogaAgora', 'setVideoDimension', [width, height]);
};

/*
 禁止所有用户视频
 mute  true/false
*/
AgoraRTC.muteAllRemoteVideoStreams = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteAllRemoteVideoStreams', [mute]);
};
    
/*
 禁止所有用户音频
 mute  true/false
*/
AgoraRTC.muteAllRemoteAudioStreams = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteAllRemoteAudioStreams', [mute]);
};
    
/*
 禁止接收指定用户视频流
 uid
 mute  true/false
*/
AgoraRTC.muteRemoteVideoStream = function (uid, mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteRemoteVideoStream', [uid, mute]);
};
    
/*
 禁止接收指定用户音频流
 uid
 mute  true/false
*/
AgoraRTC.muteRemoteAudioStream = function (uid, mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteRemoteAudioStream', [uid, mute]);
};
    
/*
 禁用本地视频
 mute  true/false
*/
AgoraRTC.muteLocalVideo = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteLocalVideo', [mute]);
};
    
/*
 禁止本地音频
 mute  true/false
*/
AgoraRTC.muteLocalAudio = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteLocalAudio', [mute]);
};
    
/*
 离开直播
*/
AgoraRTC.leave = function (success, error) {
    exec(success, error, 'YogaAgora', 'leave', []);
};
/************************************* Agroa API ****************************************/
    
/************************************* Agroa 事件回调 ****************************************/
/*
 事件监听
*/
AgoraRTC.on = function (callbackName, success, error) {
    exec(success, error, 'YogaAgora', 'on', [callbackName]);
};
/************************************* Agroa 事件回调 ****************************************/
    
/************************************* UI属性设置 ****************************************/
/*
 设置(添加)一个学生的远程视频view
*/
AgoraRTC.addRemoteUserView = function (uid, title, success, error) {
    exec(success, error, 'YogaAgora', 'addRemoteUserView', [uid, title]);
};
    
/*
 设置远程用户collectionView的滑动方向
 isHorizontal  true/false
*/
AgoraRTC.setRemoteViewScrollDirection = function (isHorizontal, success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteViewScrollDirection', [isHorizontal]);
};
    
/*
 设置远程用户collectionView的单独item的尺寸
 width  宽度
 height 高度
*/
AgoraRTC.setRemoteViewItemSize = function (width, height, success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteViewItemSize', [width, height]);
};
    
/*
 设置本地视频标题
 title  标题
*/
AgoraRTC.setLocalTitle = function (title, success, error) {
    exec(success, error, 'YogaAgora', 'setLocalTitle', [title]);
};
    
/*
 移除本地视频视图
*/
AgoraRTC.removeLocalView = function (success, error) {
    exec(success, error, 'YogaAgora', 'removeLocalView', []);
};
    
/*
 移除远程视频视图
*/
AgoraRTC.removeRemoteView = function (success, error) {
    exec(success, error, 'YogaAgora', 'removeRemoteView', []);
};
    
/*
 整洁模式，视图上只存在标题一个ui控件，默认false
 clean true->纯净模式，false->正常模式
*/
AgoraRTC.viewClean = function (clean, success, error) {
    exec(success, error, 'YogaAgora', 'viewClean', [clean]);
};
/************************************* UI属性设置 ****************************************/
    
/************************************* Util ****************************************/
/*
 调用原生日志方法
 log 日志
*/
AgoraRTC.NSLog = function (log, success, error) {
    exec(success, error, 'YogaAgora', 'NSLog', [log]);
};
/************************************* Util ****************************************/
    
module.exports = AgoraRTC;