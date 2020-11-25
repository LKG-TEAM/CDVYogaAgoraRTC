var exec = require('cordova/exec');

var AgoraRTC = {};
AgoraRTC.init = function (params, success, error) {
    exec(success, error, 'YogaAgora', 'init', [params]);
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
    
/*
    设置直播场景的用户角色
    role audience->观众，反之主播
*/
AgoraRTC.setClientRole = function (role, success, error) {
    exec(success, error, 'YogaAgora', 'setClientRole', [role]);
};
    
/*
    获取网络连接状态
    success function(state) {
            state == 1;// 断连
            state == 2;// 连接中
            state == 3;// 已连接
            state == 4;// 重连中
            state == 5;// 失败
            }
*/
AgoraRTC.getConnectionState = function (success, error) {
    exec(success, error, 'YogaAgora', 'getConnectionState', []);
};

/*
    开启双流模式
*/
AgoraRTC.enableDualStream = function (success, error) {
    exec(success, error, 'YogaAgora', 'enableDualStream', []);
};
    
/*
    停止播放音乐文件
*/
AgoraRTC.stopAudioMixing = function (success, error) {
    exec(success, error, 'YogaAgora', 'stopAudioMixing', []);
};
    
/*
    开始播放音乐文件
    filePath
    指定需要混音的音频文件名和文件路径名，例如: /var/mobile/Containers/Data/audio.mp4。建议填写文件后缀名。若无法确定文件后缀名，可不填。支持以下音频格式: mp3，aac，m4a，3gp，wav

    loopback
    YES: 只有本地可以听到混音或替换后的音频流
    NO: 本地和对方都可以听到混音或替换后的音频流
    
    replace
    YES: 只推送设置的本地音频文件或者线上音频文件，不传输麦克风收录的音频。
    NO: 音频文件内容将会和麦克风采集的音频流进行混音
    
    cycle
    指定音频文件循环播放的次数:
    正整数: 循环的次数
    -1：无限循环
*/
AgoraRTC.startAudioMixing = function (options, success, error) {
    exec(success, error, 'YogaAgora', 'startAudioMixing', [options]);
};
    
/*
    调节音乐文件的播放音量
    volume     音乐文件播放音量范围为 0~100。默认 100 为原始文件音量
*/
AgoraRTC.adjustAudioMixingVolume = function (volume, success, error) {
    exec(success, error, 'YogaAgora', 'adjustAudioMixingVolume', [volume]);
};
    
/*
    获取音乐文件播放进度，单位为毫秒。
    方法调用成功返回音乐文件播放进度
    < 0: 方法调用失败
*/
AgoraRTC.getAudioMixingCurrentPosition = function (success, error) {
    exec(success, error, 'YogaAgora', 'getAudioMixingCurrentPosition', []);
};
    
/*
    获取音乐文件时长
    方法调用成功返回音乐文件时长
    < 0: 方法调用失败
*/
AgoraRTC.getAudioMixingDuration = function (success, error) {
    exec(success, error, 'YogaAgora', 'getAudioMixingDuration', []);
};
    
/*
    禁用视频轨道
*/
AgoraRTC.muteVideo = function (success, error) {
    exec(success, error, 'YogaAgora', 'muteVideo', []);
};
    
/*
    启用视频轨道
*/
AgoraRTC.unmuteVideo = function (success, error) {
    exec(success, error, 'YogaAgora', 'unmuteVideo', []);
};
    
/*
    禁用音频轨道
*/
AgoraRTC.muteAudio = function (success, error) {
    exec(success, error, 'YogaAgora', 'muteAudio', []);
};

/*
    启用音频轨道
*/
AgoraRTC.unmuteAudio = function (success, error) {
    exec(success, error, 'YogaAgora', 'unmuteAudio', []);
};
    
/*
    暂停播放伴奏
*/
AgoraRTC.pauseAudioMixing = function (success, error) {
    exec(success, error, 'YogaAgora', 'pauseAudioMixing', []);
};
    
/*
    恢复播放伴奏
*/
AgoraRTC.resumeAudioMixing = function (success, error) {
    exec(success, error, 'YogaAgora', 'resumeAudioMixing', []);
};
    
/*
    获取当前音视频通话的id
*/
AgoraRTC.getId = function (success, error) {
    exec(success, error, 'YogaAgora', 'getId', []);
};
    
/*
    设置大小流
    0 High-bitrate, high-resolution video stream.
    1 Low-bitrate, low-resolution video stream.
*/
AgoraRTC.setRemoteVideoStream = function (uid, videoStreamType,success, error) {
    exec(success, error, 'YogaAgora', 'setRemoteVideoStream', [uid, videoStreamType]);
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

/*
    跳转内置safari
    url 要访问的地址
*/
AgoraRTC.safari = function (url, success, error) {
    exec(success, error, 'YogaAgora', 'safari', [url]);
};
    
/*
    内置safari dismiss
*/
AgoraRTC.dismiss = function (success, error) {
    exec(success, error, 'YogaAgora', 'dismiss', []);
};
/************************************* Util ****************************************/
    
module.exports = AgoraRTC;