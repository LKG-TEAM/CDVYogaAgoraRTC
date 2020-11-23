var exec = require('cordova/exec');

var YogaAgoraRTC = {};
YogaAgoraRTC.setUp = function (params, success, error) {
    exec(success, error, 'YogaAgora', 'setUp', [params]);
};

YogaAgoraRTC.show = function (success, error) {
    exec(success, error, 'YogaAgora', 'show', []);
};
    
YogaAgoraRTC.showWithSheet = function (success, error) {
    exec(success, error, 'YogaAgora', 'showWithSheet', []);
};

/*
 设置本地视频采集fps(默认30)
 width
 height
*/
YogaAgoraRTC.setVideoFrameRate = function (videoFrameRate, success, error) {
    exec(success, error, 'YogaAgora', 'setVideoFrameRate', [videoFrameRate]);
};

/*
 设置本地视频采集分辨率(默认320x240)
 width
 height
*/
YogaAgoraRTC.setVideoDimension = function (width, height, success, error) {
    exec(success, error, 'YogaAgora', 'setVideoDimension', [width, height]);
};

/************************************ 设置UI视图的位置 ****************************************/
YogaAgoraRTC.setMargin = function (top, left, bottom, right, success, error) {
    exec(success, error, 'YogaAgora', 'setMargin', [top, left, bottom, right]);
};
    
YogaAgoraRTC.setMarginTop = function (top, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginTop', [top]);
};

YogaAgoraRTC.setMarginLeft = function (left, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginLeft', [left]);
};

YogaAgoraRTC.setMarginBottom = function (bottom, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginBottom', [bottom]);
};

YogaAgoraRTC.setMarginRight = function (right, success, error) {
    exec(success, error, 'YogaAgora', 'setMarginRight', [right]);
};

YogaAgoraRTC.setWidth = function (width, success, error) {
    exec(success, error, 'YogaAgora', 'setWidth', [width]);
};

YogaAgoraRTC.setHeight = function (height, success, error) {
    exec(success, error, 'YogaAgora', 'setHeight', [height]);
};
/************************************ 设置UI视图的位置 ****************************************/

/*
 设置本地视频view的布局约束
*/
YogaAgoraRTC.setLocalVideoViewLayout = function (success, error) {
    exec(success, error, 'YogaAgora', 'setLocalVideoViewLayout', []);
};

/*
 设置远程视频view的布局约束
*/
YogaAgoraRTC.setRemoteVideoViewLayout = function (success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteVideoViewLayout', []);
};

/*
 设置(添加)一个学生的远程视频view
*/
YogaAgoraRTC.addRemoteUserView = function (uid, success, error) {
    exec(success, error, 'YogaAgora', 'addRemoteUserView', [uid]);
};

/*
 禁止所有用户视频
 mute  true/false
*/
YogaAgoraRTC.muteAllRemoteVideoStreams = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteAllRemoteVideoStreams', [mute]);
};
    
/*
 禁止所有用户音频
 mute  true/false
*/
YogaAgoraRTC.muteAllRemoteAudioStreams = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteAllRemoteAudioStreams', [mute]);
};
    
/*
 禁止接收指定用户视频流
 uid
 mute  true/false
*/
YogaAgoraRTC.muteRemoteVideoStream = function (uid, mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteRemoteVideoStream', [uid, mute]);
};
    
/*
 禁止接收指定用户音频流
 uid
 mute  true/false
*/
YogaAgoraRTC.muteRemoteAudioStream = function (uid, mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteRemoteAudioStream', [uid, mute]);
};
    
/*
 禁用本地视频
 mute  true/false
*/
YogaAgoraRTC.muteLocalVideo = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteLocalVideo', [mute]);
};
    
/*
 禁止本地音频
 mute  true/false
*/
YogaAgoraRTC.muteLocalAudio = function (mute, success, error) {
    exec(success, error, 'YogaAgora', 'muteLocalAudio', [mute]);
};
    
/*
 设置远程用户collectionView的滑动方向
 isHorizontal  true/false
*/
YogaAgoraRTC.setRemoteViewScrollDirection = function (isHorizontal, success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteViewScrollDirection', [isHorizontal]);
};
    
/*
 设置远程用户collectionView的单独item的尺寸
 width  宽度
 height 高度
*/
YogaAgoraRTC.setRemoteViewItemSize = function (width, height, success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteViewItemSize', [width, height]);
};
    
module.exports = YogaAgoraRTC;