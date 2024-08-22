import e from"process";var t="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var r={};var o=e;
/**
 * {@link https://github.com/muaz-khan/RecordRTC|RecordRTC} is a WebRTC JavaScript library for audio/video as well as screen activity recording. It supports Chrome, Firefox, Opera, Android, and Microsoft Edge. Platforms: Linux, Mac and Windows. 
 * @summary Record audio, video or screen inside the browser.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef RecordRTC
 * @class
 * @example
 * var recorder = RecordRTC(mediaStream or [arrayOfMediaStream], {
 *     type: 'video', // audio or video or gif or canvas
 *     recorderType: MediaStreamRecorder || CanvasRecorder || StereoAudioRecorder || Etc
 * });
 * recorder.startRecording();
 * @see For further information:
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - Single media-stream object, array of media-streams, html-canvas-element, etc.
 * @param {object} config - {type:"video", recorderType: MediaStreamRecorder, disableLogs: true, numberOfAudioChannels: 1, bufferSize: 0, sampleRate: 0, desiredSampRate: 16000, video: HTMLVideoElement, etc.}
 */function RecordRTC(e,t){if(!e)throw"First parameter is required.";t=t||{type:"video"};t=new RecordRTCConfiguration(e,t);var r=this;function startRecording(o){t.disableLogs||console.log("RecordRTC version: ",r.version);!o||(t=new RecordRTCConfiguration(e,o));t.disableLogs||console.log("started recording "+t.type+" stream.");if(i){i.clearRecordedData();i.record();setState("recording");r.recordingDuration&&handleRecordingDuration();return r}initRecorder((function(){r.recordingDuration&&handleRecordingDuration()}));return r}function initRecorder(r){r&&(t.initCallback=function(){r();r=t.initCallback=null});var o=new GetRecorderType(e,t);i=new o(e,t);i.record();setState("recording");t.disableLogs||console.log("Initialized recorderType:",i.constructor.name,"for output-type:",t.type)}function stopRecording(e){e=e||function(){};if(i)if("paused"!==r.state){"recording"===r.state||t.disableLogs||console.warn('Recording state should be: "recording", however current state is: ',r.state);t.disableLogs||console.log("Stopped recording "+t.type+" stream.");if("gif"!==t.type)i.stop(_callback);else{i.stop();_callback()}setState("stopped")}else{r.resumeRecording();setTimeout((function(){stopRecording(e)}),1)}else warningLog();function _callback(o){if(i){Object.keys(i).forEach((function(e){"function"!==typeof i[e]&&(r[e]=i[e])}));var a=i.blob;if(!a){if(!o)throw"Recording failed.";i.blob=a=o}a&&!t.disableLogs&&console.log(a.type,"->",bytesToSize(a.size));if(e){var n;try{n=c.createObjectURL(a)}catch(e){}"function"===typeof e.call?e.call(r,n):e(n)}t.autoWriteToDisk&&getDataURL((function(e){var r={};r[t.type+"Blob"]=e;R.Store(r)}))}else"function"===typeof e.call?e.call(r,""):e("")}}function pauseRecording(){if(i)if("recording"===r.state){setState("paused");i.pause();t.disableLogs||console.log("Paused recording.")}else t.disableLogs||console.warn("Unable to pause the recording. Recording state: ",r.state);else warningLog()}function resumeRecording(){if(i)if("paused"===r.state){setState("recording");i.resume();t.disableLogs||console.log("Resumed recording.")}else t.disableLogs||console.warn("Unable to resume the recording. Recording state: ",r.state);else warningLog()}function readFile(e){postMessage((new FileReaderSync).readAsDataURL(e))}function getDataURL(e,r){if(!e)throw"Pass a callback function over getDataURL.";var o=r?r.blob:(i||{}).blob;if(o)if("undefined"===typeof Worker||navigator.mozGetUserMedia){var a=new FileReader;a.readAsDataURL(o);a.onload=function(t){e(t.target.result)}}else{var n=processInWebWorker(readFile);n.onmessage=function(t){e(t.data)};n.postMessage(o)}else{t.disableLogs||console.warn("Blob encoder did not finish its job yet.");setTimeout((function(){getDataURL(e,r)}),1e3)}function processInWebWorker(e){try{var t=c.createObjectURL(new Blob([e.toString(),"this.onmessage =  function (eee) {"+e.name+"(eee.data);}"],{type:"application/javascript"}));var r=new Worker(t);c.revokeObjectURL(t);return r}catch(e){}}}function handleRecordingDuration(e){e=e||0;if("paused"!==r.state){if("stopped"!==r.state)if(e>=r.recordingDuration)stopRecording(r.onRecordingStopped);else{e+=1e3;setTimeout((function(){handleRecordingDuration(e)}),1e3)}}else setTimeout((function(){handleRecordingDuration(e)}),1e3)}function setState(e){if(r){r.state=e;"function"===typeof r.onStateChanged.call?r.onStateChanged.call(r,e):r.onStateChanged(e)}}var o='It seems that recorder is destroyed or "startRecording" is not invoked for '+t.type+" recorder.";function warningLog(){true!==t.disableLogs&&console.warn(o)}var i;var a={startRecording:startRecording,
/**
     * This method stops the recording. It is strongly recommended to get "blob" or "URI" inside the callback to make sure all recorders finished their job.
     * @param {function} callback - Callback to get the recorded blob.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * recorder.stopRecording(function() {
     *     // use either "this" or "recorder" object; both are identical
     *     video.src = this.toURL();
     *     var blob = this.getBlob();
     * });
     */
stopRecording:stopRecording,pauseRecording:pauseRecording,resumeRecording:resumeRecording,initRecorder:initRecorder,setRecordingDuration:function(e,t){if("undefined"===typeof e)throw"recordingDuration is required.";if("number"!==typeof e)throw"recordingDuration must be a number.";r.recordingDuration=e;r.onRecordingStopped=t||function(){};return{onRecordingStopped:function(e){r.onRecordingStopped=e}}},clearRecordedData:function(){if(i){i.clearRecordedData();t.disableLogs||console.log("Cleared old recorded data.")}else warningLog()},
/**
     * Get the recorded blob. Use this method inside the "stopRecording" callback.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * recorder.stopRecording(function() {
     *     var blob = this.getBlob();
     *
     *     var file = new File([blob], 'filename.webm', {
     *         type: 'video/webm'
     *     });
     *
     *     var formData = new FormData();
     *     formData.append('file', file); // upload "File" object rather than a "Blob"
     *     uploadToServer(formData);
     * });
     * @returns {Blob} Returns recorded data as "Blob" object.
     */
getBlob:function(){if(i)return i.blob;warningLog()},
/**
     * Get data-URI instead of Blob.
     * @param {function} callback - Callback to get the Data-URI.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * recorder.stopRecording(function() {
     *     recorder.getDataURL(function(dataURI) {
     *         video.src = dataURI;
     *     });
     * });
     */
getDataURL:getDataURL,
/**
     * Get virtual/temporary URL. Usage of this URL is limited to current tab.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * recorder.stopRecording(function() {
     *     video.src = this.toURL();
     * });
     * @returns {String} Returns a virtual/temporary URL for the recorded "Blob".
     */
toURL:function(){if(i)return c.createObjectURL(i.blob);warningLog()},
/**
     * Get internal recording object (i.e. internal module) e.g. MutliStreamRecorder, MediaStreamRecorder, StereoAudioRecorder or WhammyRecorder etc.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * var internalRecorder = recorder.getInternalRecorder();
     * if(internalRecorder instanceof MultiStreamRecorder) {
     *     internalRecorder.addStreams([newAudioStream]);
     *     internalRecorder.resetVideoStreams([screenStream]);
     * }
     * @returns {Object} Returns internal recording object.
     */
getInternalRecorder:function(){return i},
/**
     * Invoke save-as dialog to save the recorded blob into your disk.
     * @param {string} fileName - Set your own file name.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * recorder.stopRecording(function() {
     *     this.save('file-name');
     *
     *     // or manually:
     *     invokeSaveAsDialog(this.getBlob(), 'filename.webm');
     * });
     */
save:function(e){i?invokeSaveAsDialog(i.blob,e):warningLog()},
/**
     * This method gets a blob from indexed-DB storage.
     * @param {function} callback - Callback to get the recorded blob.
     * @method
     * @memberof RecordRTC
     * @instance
     * @example
     * recorder.getFromDisk(function(dataURL) {
     *     video.src = dataURL;
     * });
     */
getFromDisk:function(e){i?RecordRTC.getFromDisk(t.type,e):warningLog()},
/**
     * This method appends an array of webp images to the recorded video-blob. It takes an "array" object.
     * @type {Array.<Array>}
     * @param {Array} arrayOfWebPImages - Array of webp images.
     * @method
     * @memberof RecordRTC
     * @instance
     * @todo This method should be deprecated.
     * @example
     * var arrayOfWebPImages = [];
     * arrayOfWebPImages.push({
     *     duration: index,
     *     image: 'data:image/webp;base64,...'
     * });
     * recorder.setAdvertisementArray(arrayOfWebPImages);
     */
setAdvertisementArray:function(e){t.advertisement=[];var r=e.length;for(var o=0;o<r;o++)t.advertisement.push({duration:o,image:e[o]})},blob:null,bufferSize:0,sampleRate:0,buffer:null,reset:function(){"recording"!==r.state||t.disableLogs||console.warn("Stop an active recorder.");i&&"function"===typeof i.clearRecordedData&&i.clearRecordedData();i=null;setState("inactive");r.blob=null},onStateChanged:function(e){t.disableLogs||console.log("Recorder state changed:",e)},state:"inactive",
/**
     * Get recorder's readonly state.
     * @method
     * @memberof RecordRTC
     * @example
     * var state = recorder.getState();
     * @returns {String} Returns recording state.
     */
getState:function(){return r.state},destroy:function(){var e=t.disableLogs;t={disableLogs:true};r.reset();setState("destroyed");a=r=null;if(v.AudioContextConstructor){v.AudioContextConstructor.close();v.AudioContextConstructor=null}t.disableLogs=e;t.disableLogs||console.log("RecordRTC is destroyed.")},version:"5.6.2"};if(!this){r=a;return a}for(var n in a)this[n]=a[n];r=this;return a}RecordRTC.version="5.6.2";r=RecordRTC;RecordRTC.getFromDisk=function(e,t){if(!t)throw"callback is mandatory.";console.log("Getting recorded "+("all"===e?"blobs":e+" blob ")+" from disk!");R.Fetch((function(r,o){"all"!==e&&o===e+"Blob"&&t&&t(r);"all"===e&&t&&t(r,o.replace("Blob",""))}))};
/**
 * This method can be used to store recorded blobs into IndexedDB storage.
 * @param {object} options - {audio: Blob, video: Blob, gif: Blob}
 * @method
 * @memberof RecordRTC
 * @example
 * RecordRTC.writeToDisk({
 *     audio: audioBlob,
 *     video: videoBlob,
 *     gif  : gifBlob
 * });
 */RecordRTC.writeToDisk=function(e){console.log("Writing recorded blob(s) to disk!");e=e||{};e.audio&&e.video&&e.gif?e.audio.getDataURL((function(t){e.video.getDataURL((function(r){e.gif.getDataURL((function(e){R.Store({audioBlob:t,videoBlob:r,gifBlob:e})}))}))})):e.audio&&e.video?e.audio.getDataURL((function(t){e.video.getDataURL((function(e){R.Store({audioBlob:t,videoBlob:e})}))})):e.audio&&e.gif?e.audio.getDataURL((function(t){e.gif.getDataURL((function(e){R.Store({audioBlob:t,gifBlob:e})}))})):e.video&&e.gif?e.video.getDataURL((function(t){e.gif.getDataURL((function(e){R.Store({videoBlob:t,gifBlob:e})}))})):e.audio?e.audio.getDataURL((function(e){R.Store({audioBlob:e})})):e.video?e.video.getDataURL((function(e){R.Store({videoBlob:e})})):e.gif&&e.gif.getDataURL((function(e){R.Store({gifBlob:e})}))};
/**
 * {@link RecordRTCConfiguration} is an inner/private helper for {@link RecordRTC}.
 * @summary It configures the 2nd parameter passed over {@link RecordRTC} and returns a valid "config" object.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef RecordRTCConfiguration
 * @class
 * @example
 * var options = RecordRTCConfiguration(mediaStream, options);
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @param {object} config - {type:"video", disableLogs: true, numberOfAudioChannels: 1, bufferSize: 0, sampleRate: 0, video: HTMLVideoElement, getNativeBlob:true, etc.}
 */function RecordRTCConfiguration(e,t){t.recorderType||t.type||(t.audio&&t.video?t.type="video":!t.audio||t.video||(t.type="audio"));t.recorderType&&!t.type&&(t.recorderType===WhammyRecorder||t.recorderType===CanvasRecorder||"undefined"!==typeof WebAssemblyRecorder&&t.recorderType===WebAssemblyRecorder?t.type="video":t.recorderType===GifRecorder?t.type="gif":t.recorderType===StereoAudioRecorder?t.type="audio":t.recorderType===MediaStreamRecorder&&(getTracks(e,"audio").length&&getTracks(e,"video").length||!getTracks(e,"audio").length&&getTracks(e,"video").length?t.type="video":getTracks(e,"audio").length&&!getTracks(e,"video").length&&(t.type="audio")));if("undefined"!==typeof MediaStreamRecorder&&"undefined"!==typeof MediaRecorder&&"requestData"in MediaRecorder.prototype){t.mimeType||(t.mimeType="video/webm");t.type||(t.type=t.mimeType.split("/")[0]);!t.bitsPerSecond}if(!t.type){t.mimeType&&(t.type=t.mimeType.split("/")[0]);t.type||(t.type="audio")}return t}
/**
 * {@link GetRecorderType} is an inner/private helper for {@link RecordRTC}.
 * @summary It returns best recorder-type available for your browser.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef GetRecorderType
 * @class
 * @example
 * var RecorderType = GetRecorderType(options);
 * var recorder = new RecorderType(options);
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @param {object} config - {type:"video", disableLogs: true, numberOfAudioChannels: 1, bufferSize: 0, sampleRate: 0, video: HTMLVideoElement, etc.}
 */function GetRecorderType(e,t){var r;(g||u||l)&&(r=StereoAudioRecorder);"undefined"!==typeof MediaRecorder&&"requestData"in MediaRecorder.prototype&&!g&&(r=MediaStreamRecorder);if("video"===t.type&&(g||l)){r=WhammyRecorder;"undefined"!==typeof WebAssemblyRecorder&&"undefined"!==typeof ReadableStream&&(r=WebAssemblyRecorder)}"gif"===t.type&&(r=GifRecorder);"canvas"===t.type&&(r=CanvasRecorder);isMediaRecorderCompatible()&&r!==CanvasRecorder&&r!==GifRecorder&&"undefined"!==typeof MediaRecorder&&"requestData"in MediaRecorder.prototype&&(getTracks(e,"video").length||getTracks(e,"audio").length)&&("audio"===t.type?"function"===typeof MediaRecorder.isTypeSupported&&MediaRecorder.isTypeSupported("audio/webm")&&(r=MediaStreamRecorder):"function"===typeof MediaRecorder.isTypeSupported&&MediaRecorder.isTypeSupported("video/webm")&&(r=MediaStreamRecorder));e instanceof Array&&e.length&&(r=MultiStreamRecorder);t.recorderType&&(r=t.recorderType);t.disableLogs||!r||!r.name||console.log("Using recorderType:",r.name||r.constructor.name);!r&&h&&(r=MediaStreamRecorder);return r}
/**
 * MRecordRTC runs on top of {@link RecordRTC} to bring multiple recordings in a single place, by providing simple API.
 * @summary MRecordRTC stands for "Multiple-RecordRTC".
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef MRecordRTC
 * @class
 * @example
 * var recorder = new MRecordRTC();
 * recorder.addStream(MediaStream);
 * recorder.mediaType = {
 *     audio: true, // or StereoAudioRecorder or MediaStreamRecorder
 *     video: true, // or WhammyRecorder or MediaStreamRecorder or WebAssemblyRecorder or CanvasRecorder
 *     gif: true    // or GifRecorder
 * };
 * // mimeType is optional and should be set only in advance cases.
 * recorder.mimeType = {
 *     audio: 'audio/wav',
 *     video: 'video/webm',
 *     gif:   'image/gif'
 * };
 * recorder.startRecording();
 * @see For further information:
 * @see {@link https://github.com/muaz-khan/RecordRTC/tree/master/MRecordRTC|MRecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @requires {@link RecordRTC}
 */function MRecordRTC(e){
/**
   * This method attaches MediaStream object to {@link MRecordRTC}.
   * @param {MediaStream} mediaStream - A MediaStream object, either fetched using getUserMedia API, or generated using captureStreamUntilEnded or WebAudio API.
   * @method
   * @memberof MRecordRTC
   * @example
   * recorder.addStream(MediaStream);
   */
this.addStream=function(t){t&&(e=t)};this.mediaType={audio:true,video:true};this.startRecording=function(){var t=this.mediaType;var r;var o=this.mimeType||{audio:null,video:null,gif:null};"function"!==typeof t.audio&&isMediaRecorderCompatible()&&!getTracks(e,"audio").length&&(t.audio=false);"function"!==typeof t.video&&isMediaRecorderCompatible()&&!getTracks(e,"video").length&&(t.video=false);"function"!==typeof t.gif&&isMediaRecorderCompatible()&&!getTracks(e,"video").length&&(t.gif=false);if(!t.audio&&!t.video&&!t.gif)throw"MediaStream must have either audio or video tracks.";if(!!t.audio){r=null;"function"===typeof t.audio&&(r=t.audio);this.audioRecorder=new RecordRTC(e,{type:"audio",bufferSize:this.bufferSize,sampleRate:this.sampleRate,numberOfAudioChannels:this.numberOfAudioChannels||2,disableLogs:this.disableLogs,recorderType:r,mimeType:o.audio,timeSlice:this.timeSlice,onTimeStamp:this.onTimeStamp});t.video||this.audioRecorder.startRecording()}if(!!t.video){r=null;"function"===typeof t.video&&(r=t.video);var i=e;if(isMediaRecorderCompatible()&&!!t.audio&&"function"===typeof t.audio){var a=getTracks(e,"video")[0];if(m){i=new p;i.addTrack(a);r&&r===WhammyRecorder&&(r=MediaStreamRecorder)}else{i=new p;i.addTrack(a)}}this.videoRecorder=new RecordRTC(i,{type:"video",video:this.video,canvas:this.canvas,frameInterval:this.frameInterval||10,disableLogs:this.disableLogs,recorderType:r,mimeType:o.video,timeSlice:this.timeSlice,onTimeStamp:this.onTimeStamp,workerPath:this.workerPath,webAssemblyPath:this.webAssemblyPath,frameRate:this.frameRate,bitrate:this.bitrate});t.audio||this.videoRecorder.startRecording()}if(!!t.audio&&!!t.video){var n=this;var d=true===isMediaRecorderCompatible();(t.audio instanceof StereoAudioRecorder&&!!t.video||true!==t.audio&&true!==t.video&&t.audio!==t.video)&&(d=false);if(true===d){n.audioRecorder=null;n.videoRecorder.startRecording()}else n.videoRecorder.initRecorder((function(){n.audioRecorder.initRecorder((function(){n.videoRecorder.startRecording();n.audioRecorder.startRecording()}))}))}if(!!t.gif){r=null;"function"===typeof t.gif&&(r=t.gif);this.gifRecorder=new RecordRTC(e,{type:"gif",frameRate:this.frameRate||200,quality:this.quality||10,disableLogs:this.disableLogs,recorderType:r,mimeType:o.gif});this.gifRecorder.startRecording()}};
/**
   * This method stops recording.
   * @param {function} callback - Callback function is invoked when all encoders finished their jobs.
   * @method
   * @memberof MRecordRTC
   * @example
   * recorder.stopRecording(function(recording){
   *     var audioBlob = recording.audio;
   *     var videoBlob = recording.video;
   *     var gifBlob   = recording.gif;
   * });
   */this.stopRecording=function(e){e=e||function(){};this.audioRecorder&&this.audioRecorder.stopRecording((function(t){e(t,"audio")}));this.videoRecorder&&this.videoRecorder.stopRecording((function(t){e(t,"video")}));this.gifRecorder&&this.gifRecorder.stopRecording((function(t){e(t,"gif")}))};this.pauseRecording=function(){this.audioRecorder&&this.audioRecorder.pauseRecording();this.videoRecorder&&this.videoRecorder.pauseRecording();this.gifRecorder&&this.gifRecorder.pauseRecording()};this.resumeRecording=function(){this.audioRecorder&&this.audioRecorder.resumeRecording();this.videoRecorder&&this.videoRecorder.resumeRecording();this.gifRecorder&&this.gifRecorder.resumeRecording()};
/**
   * This method can be used to manually get all recorded blobs.
   * @param {function} callback - All recorded blobs are passed back to the "callback" function.
   * @method
   * @memberof MRecordRTC
   * @example
   * recorder.getBlob(function(recording){
   *     var audioBlob = recording.audio;
   *     var videoBlob = recording.video;
   *     var gifBlob   = recording.gif;
   * });
   * // or
   * var audioBlob = recorder.getBlob().audio;
   * var videoBlob = recorder.getBlob().video;
   */this.getBlob=function(e){var t={};this.audioRecorder&&(t.audio=this.audioRecorder.getBlob());this.videoRecorder&&(t.video=this.videoRecorder.getBlob());this.gifRecorder&&(t.gif=this.gifRecorder.getBlob());e&&e(t);return t};this.destroy=function(){if(this.audioRecorder){this.audioRecorder.destroy();this.audioRecorder=null}if(this.videoRecorder){this.videoRecorder.destroy();this.videoRecorder=null}if(this.gifRecorder){this.gifRecorder.destroy();this.gifRecorder=null}};
/**
   * This method can be used to manually get all recorded blobs' DataURLs.
   * @param {function} callback - All recorded blobs' DataURLs are passed back to the "callback" function.
   * @method
   * @memberof MRecordRTC
   * @example
   * recorder.getDataURL(function(recording){
   *     var audioDataURL = recording.audio;
   *     var videoDataURL = recording.video;
   *     var gifDataURL   = recording.gif;
   * });
   */this.getDataURL=function(e){this.getBlob((function(t){t.audio&&t.video?getDataURL(t.audio,(function(r){getDataURL(t.video,(function(t){e({audio:r,video:t})}))})):t.audio?getDataURL(t.audio,(function(t){e({audio:t})})):t.video&&getDataURL(t.video,(function(t){e({video:t})}))}));function getDataURL(e,t){if("undefined"!==typeof Worker){var r=processInWebWorker((function readFile(e){postMessage((new FileReaderSync).readAsDataURL(e))}));r.onmessage=function(e){t(e.data)};r.postMessage(e)}else{var o=new FileReader;o.readAsDataURL(e);o.onload=function(e){t(e.target.result)}}}function processInWebWorker(e){var t=c.createObjectURL(new Blob([e.toString(),"this.onmessage =  function (eee) {"+e.name+"(eee.data);}"],{type:"application/javascript"}));var r=new Worker(t);var o;if("undefined"!==typeof c)o=c;else{if("undefined"===typeof webkitURL)throw"Neither URL nor webkitURL detected.";o=webkitURL}o.revokeObjectURL(t);return r}};this.writeToDisk=function(){RecordRTC.writeToDisk({audio:this.audioRecorder,video:this.videoRecorder,gif:this.gifRecorder})};
/**
   * This method can be used to invoke a save-as dialog for all recorded blobs.
   * @param {object} args - {audio: 'audio-name', video: 'video-name', gif: 'gif-name'}
   * @method
   * @memberof MRecordRTC
   * @example
   * recorder.save({
   *     audio: 'audio-file-name',
   *     video: 'video-file-name',
   *     gif  : 'gif-file-name'
   * });
   */this.save=function(e){e=e||{audio:true,video:true,gif:true};!!e.audio&&this.audioRecorder&&this.audioRecorder.save("string"===typeof e.audio?e.audio:"");!!e.video&&this.videoRecorder&&this.videoRecorder.save("string"===typeof e.video?e.video:"");!!e.gif&&this.gifRecorder&&this.gifRecorder.save("string"===typeof e.gif?e.gif:"")}}
/**
 * This method can be used to get all recorded blobs from IndexedDB storage.
 * @param {string} type - 'all' or 'audio' or 'video' or 'gif'
 * @param {function} callback - Callback function to get all stored blobs.
 * @method
 * @memberof MRecordRTC
 * @example
 * MRecordRTC.getFromDisk('all', function(dataURL, type){
 *     if(type === 'audio') { }
 *     if(type === 'video') { }
 *     if(type === 'gif')   { }
 * });
 */MRecordRTC.getFromDisk=RecordRTC.getFromDisk;
/**
 * This method can be used to store recorded blobs into IndexedDB storage.
 * @param {object} options - {audio: Blob, video: Blob, gif: Blob}
 * @method
 * @memberof MRecordRTC
 * @example
 * MRecordRTC.writeToDisk({
 *     audio: audioBlob,
 *     video: videoBlob,
 *     gif  : gifBlob
 * });
 */MRecordRTC.writeToDisk=RecordRTC.writeToDisk;"undefined"!==typeof RecordRTC&&(RecordRTC.MRecordRTC=MRecordRTC);var i="Fake/5.0 (FakeOS) AppleWebKit/123 (KHTML, like Gecko) Fake/12.3.4567.89 Fake/123.45";(function(e){if(e&&"undefined"===typeof window&&"undefined"!==typeof t){t.navigator={userAgent:i,getUserMedia:function(){}};t.console||(t.console={});"undefined"!==typeof t.console.log&&"undefined"!==typeof t.console.error||(t.console.error=t.console.log=t.console.log||function(){console.log(arguments)});if("undefined"===typeof document){e.document={documentElement:{appendChild:function(){return""}}};document.createElement=document.captureStream=document.mozCaptureStream=function(){var e={getContext:function(){return e},play:function(){},pause:function(){},drawImage:function(){},toDataURL:function(){return""},style:{}};return e};e.HTMLVideoElement=function(){}}"undefined"===typeof location&&(e.location={protocol:"file:",href:"",hash:""});"undefined"===typeof screen&&(e.screen={width:0,height:0});"undefined"===typeof c&&(e.URL={createObjectURL:function(){return""},revokeObjectURL:function(){return""}});e.window=t}})("undefined"!==typeof t?t:null);var a=window.requestAnimationFrame;if("undefined"===typeof a)if("undefined"!==typeof webkitRequestAnimationFrame)a=webkitRequestAnimationFrame;else if("undefined"!==typeof mozRequestAnimationFrame)a=mozRequestAnimationFrame;else if("undefined"!==typeof msRequestAnimationFrame)a=msRequestAnimationFrame;else if("undefined"===typeof a){var n=0;a=function(e,t){var r=(new Date).getTime();var o=Math.max(0,16-(r-n));var i=setTimeout((function(){e(r+o)}),o);n=r+o;return i}}var d=window.cancelAnimationFrame;"undefined"===typeof d&&("undefined"!==typeof webkitCancelAnimationFrame?d=webkitCancelAnimationFrame:"undefined"!==typeof mozCancelAnimationFrame?d=mozCancelAnimationFrame:"undefined"!==typeof msCancelAnimationFrame?d=msCancelAnimationFrame:"undefined"===typeof d&&(d=function(e){clearTimeout(e)}));var s=window.AudioContext;if("undefined"===typeof s){"undefined"!==typeof webkitAudioContext&&(s=webkitAudioContext);"undefined"!==typeof mozAudioContext&&(s=mozAudioContext)}var c=window.URL;"undefined"===typeof c&&"undefined"!==typeof webkitURL&&(c=webkitURL);if("undefined"!==typeof navigator&&"undefined"===typeof navigator.getUserMedia){"undefined"!==typeof navigator.webkitGetUserMedia&&(navigator.getUserMedia=navigator.webkitGetUserMedia);"undefined"!==typeof navigator.mozGetUserMedia&&(navigator.getUserMedia=navigator.mozGetUserMedia)}var u=-1!==navigator.userAgent.indexOf("Edge")&&(!!navigator.msSaveBlob||!!navigator.msSaveOrOpenBlob);var l=!!window.opera||-1!==navigator.userAgent.indexOf("OPR/");var m=navigator.userAgent.toLowerCase().indexOf("firefox")>-1&&"netscape"in window&&/ rv:/.test(navigator.userAgent);var g=!l&&!u&&!!navigator.webkitGetUserMedia||isElectron()||-1!==navigator.userAgent.toLowerCase().indexOf("chrome/");var h=/^((?!chrome|android).)*safari/i.test(navigator.userAgent);if(h&&!g&&-1!==navigator.userAgent.indexOf("CriOS")){h=false;g=true}var p=window.MediaStream;"undefined"===typeof p&&"undefined"!==typeof webkitMediaStream&&(p=webkitMediaStream);"undefined"!==typeof p&&"undefined"===typeof p.prototype.stop&&(p.prototype.stop=function(){this.getTracks().forEach((function(e){e.stop()}))});
/**
 * Return human-readable file size.
 * @param {number} bytes - Pass bytes and get formatted string.
 * @returns {string} - formatted string
 * @example
 * bytesToSize(1024*1024*5) === '5 GB'
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 */function bytesToSize(e){var t=1e3;var r=["Bytes","KB","MB","GB","TB"];if(0===e)return"0 Bytes";var o=parseInt(Math.floor(Math.log(e)/Math.log(t)),10);return(e/Math.pow(t,o)).toPrecision(3)+" "+r[o]}
/**
 * @param {Blob} file - File or Blob object. This parameter is required.
 * @param {string} fileName - Optional file name e.g. "Recorded-Video.webm"
 * @example
 * invokeSaveAsDialog(blob or file, [optional] fileName);
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 */function invokeSaveAsDialog(e,t){if(!e)throw"Blob object is required.";if(!e.type)try{e.type="video/webm"}catch(e){}var r=(e.type||"video/webm").split("/")[1];-1!==r.indexOf(";")&&(r=r.split(";")[0]);if(t&&-1!==t.indexOf(".")){var o=t.split(".");t=o[0];r=o[1]}var i=(t||Math.round(9999999999*Math.random())+888888888)+"."+r;if("undefined"!==typeof navigator.msSaveOrOpenBlob)return navigator.msSaveOrOpenBlob(e,i);if("undefined"!==typeof navigator.msSaveBlob)return navigator.msSaveBlob(e,i);var a=document.createElement("a");a.href=c.createObjectURL(e);a.download=i;a.style="display:none;opacity:0;color:transparent;";(document.body||document.documentElement).appendChild(a);if("function"===typeof a.click)a.click();else{a.target="_blank";a.dispatchEvent(new MouseEvent("click",{view:window,bubbles:true,cancelable:true}))}c.revokeObjectURL(a.href)}function isElectron(){return"undefined"!==typeof window&&"object"===typeof window.process&&"renderer"===window.process.type||(!("undefined"===typeof o||"object"!==typeof o.versions||!o.versions.electron)||"object"===typeof navigator&&"string"===typeof navigator.userAgent&&navigator.userAgent.indexOf("Electron")>=0)}function getTracks(e,t){return e&&e.getTracks?e.getTracks().filter((function(e){return e.kind===(t||"audio")})):[]}function setSrcObject(e,t){"srcObject"in t?t.srcObject=e:"mozSrcObject"in t?t.mozSrcObject=e:t.srcObject=e}
/**
 * @param {Blob} file - File or Blob object.
 * @param {function} callback - Callback function.
 * @example
 * getSeekableBlob(blob or file, callback);
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 */function getSeekableBlob(e,t){if("undefined"===typeof EBML)throw new Error("Please link: https://www.webrtc-experiment.com/EBML.js");var r=new EBML.Reader;var o=new EBML.Decoder;var i=EBML.tools;var a=new FileReader;a.onload=function(e){var a=o.decode(this.result);a.forEach((function(e){r.read(e)}));r.stop();var n=i.makeMetadataSeekable(r.metadatas,r.duration,r.cues);var d=this.result.slice(r.metadataSize);var s=new Blob([n,d],{type:"video/webm"});t(s)};a.readAsArrayBuffer(e)}if("undefined"!==typeof RecordRTC){RecordRTC.invokeSaveAsDialog=invokeSaveAsDialog;RecordRTC.getTracks=getTracks;RecordRTC.getSeekableBlob=getSeekableBlob;RecordRTC.bytesToSize=bytesToSize;RecordRTC.isElectron=isElectron}
/**
 * Storage is a standalone object used by {@link RecordRTC} to store reusable objects e.g. "new AudioContext".
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @example
 * Storage.AudioContext === webkitAudioContext
 * @property {webkitAudioContext} AudioContext - Keeps a reference to AudioContext object.
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 */var v={};"undefined"!==typeof s?v.AudioContext=s:"undefined"!==typeof webkitAudioContext&&(v.AudioContext=webkitAudioContext);"undefined"!==typeof RecordRTC&&(RecordRTC.Storage=v);function isMediaRecorderCompatible(){if(m||h||u)return true;navigator.appVersion;var e=navigator.userAgent;var t=""+parseFloat(navigator.appVersion);var r=parseInt(navigator.appVersion,10);var o,i;if(g||l){o=e.indexOf("Chrome");t=e.substring(o+7)}-1!==(i=t.indexOf(";"))&&(t=t.substring(0,i));-1!==(i=t.indexOf(" "))&&(t=t.substring(0,i));r=parseInt(""+t,10);if(isNaN(r)){t=""+parseFloat(navigator.appVersion);r=parseInt(navigator.appVersion,10)}return r>=49}
/**
 * MediaStreamRecorder is an abstraction layer for {@link https://w3c.github.io/mediacapture-record/MediaRecorder.html|MediaRecorder API}. It is used by {@link RecordRTC} to record MediaStream(s) in both Chrome and Firefox.
 * @summary Runs top over {@link https://w3c.github.io/mediacapture-record/MediaRecorder.html|MediaRecorder API}.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://github.com/muaz-khan|Muaz Khan}
 * @typedef MediaStreamRecorder
 * @class
 * @example
 * var config = {
 *     mimeType: 'video/webm', // vp8, vp9, h264, mkv, opus/vorbis
 *     audioBitsPerSecond : 256 * 8 * 1024,
 *     videoBitsPerSecond : 256 * 8 * 1024,
 *     bitsPerSecond: 256 * 8 * 1024,  // if this is provided, skip above two
 *     checkForInactiveTracks: true,
 *     timeSlice: 1000, // concatenate intervals based blobs
 *     ondataavailable: function() {} // get intervals based blobs
 * }
 * var recorder = new MediaStreamRecorder(mediaStream, config);
 * recorder.record();
 * recorder.stop(function(blob) {
 *     video.src = URL.createObjectURL(blob);
 *
 *     // or
 *     var blob = recorder.blob;
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @param {object} config - {disableLogs:true, initCallback: function, mimeType: "video/webm", timeSlice: 1000}
 * @throws Will throw an error if first argument "MediaStream" is missing. Also throws error if "MediaRecorder API" are not supported by the browser.
 */function MediaStreamRecorder(e,t){var r=this;if("undefined"===typeof e)throw'First argument "MediaStream" is required.';if("undefined"===typeof MediaRecorder)throw"Your browser does not support the Media Recorder API. Please try other modules e.g. WhammyRecorder or StereoAudioRecorder.";t=t||{mimeType:"video/webm"};if("audio"===t.type){if(getTracks(e,"video").length&&getTracks(e,"audio").length){var o;if(!navigator.mozGetUserMedia)o=new p(getTracks(e,"audio"));else{o=new p;o.addTrack(getTracks(e,"audio")[0])}e=o}t.mimeType&&-1!==t.mimeType.toString().toLowerCase().indexOf("audio")||(t.mimeType=g?"audio/webm":"audio/ogg");t.mimeType&&"audio/ogg"!==t.mimeType.toString().toLowerCase()&&!!navigator.mozGetUserMedia&&(t.mimeType="audio/ogg")}var i=[];
/**
   * This method returns array of blobs. Use only with "timeSlice". Its useful to preview recording anytime, without using the "stop" method.
   * @method
   * @memberof MediaStreamRecorder
   * @example
   * var arrayOfBlobs = recorder.getArrayOfBlobs();
   * @returns {Array} Returns array of recorded blobs.
   */this.getArrayOfBlobs=function(){return i};this.record=function(){r.blob=null;r.clearRecordedData();r.timestamps=[];n=[];i=[];var o=t;t.disableLogs||console.log("Passing following config over MediaRecorder API.",o);a&&(a=null);g&&!isMediaRecorderCompatible()&&(o="video/vp8");if("function"===typeof MediaRecorder.isTypeSupported&&o.mimeType&&!MediaRecorder.isTypeSupported(o.mimeType)){t.disableLogs||console.warn("MediaRecorder API seems unable to record mimeType:",o.mimeType);o.mimeType="audio"===t.type?"audio/webm":"video/webm"}try{a=new MediaRecorder(e,o);t.mimeType=o.mimeType}catch(t){a=new MediaRecorder(e)}o.mimeType&&!MediaRecorder.isTypeSupported&&"canRecordMimeType"in a&&false===a.canRecordMimeType(o.mimeType)&&(t.disableLogs||console.warn("MediaRecorder API seems unable to record mimeType:",o.mimeType));a.ondataavailable=function(e){e.data&&n.push("ondataavailable: "+bytesToSize(e.data.size));if("number"!==typeof t.timeSlice)if(!e.data||!e.data.size||e.data.size<100||r.blob){if(r.recordingCallback){r.recordingCallback(new Blob([],{type:getMimeType(o)}));r.recordingCallback=null}}else{r.blob=t.getNativeBlob?e.data:new Blob([e.data],{type:getMimeType(o)});if(r.recordingCallback){r.recordingCallback(r.blob);r.recordingCallback=null}}else if(e.data&&e.data.size){i.push(e.data);updateTimeStamp();if("function"===typeof t.ondataavailable){var a=t.getNativeBlob?e.data:new Blob([e.data],{type:getMimeType(o)});t.ondataavailable(a)}}};a.onstart=function(){n.push("started")};a.onpause=function(){n.push("paused")};a.onresume=function(){n.push("resumed")};a.onstop=function(){n.push("stopped")};a.onerror=function(e){if(e){e.name||(e.name="UnknownError");n.push("error: "+e);t.disableLogs||(-1!==e.name.toString().toLowerCase().indexOf("invalidstate")?console.error("The MediaRecorder is not in a state in which the proposed operation is allowed to be executed.",e):-1!==e.name.toString().toLowerCase().indexOf("notsupported")?console.error("MIME type (",o.mimeType,") is not supported.",e):-1!==e.name.toString().toLowerCase().indexOf("security")?console.error("MediaRecorder security error",e):"OutOfMemory"===e.name?console.error("The UA has exhaused the available memory. User agents SHOULD provide as much additional information as possible in the message attribute.",e):"IllegalStreamModification"===e.name?console.error("A modification to the stream has occurred that makes it impossible to continue recording. An example would be the addition of a Track while recording is occurring. User agents SHOULD provide as much additional information as possible in the message attribute.",e):"OtherRecordingError"===e.name?console.error("Used for an fatal error other than those listed above. User agents SHOULD provide as much additional information as possible in the message attribute.",e):"GenericError"===e.name?console.error("The UA cannot provide the codec or recording option that has been requested.",e):console.error("MediaRecorder Error",e));(function(e){if(r.manuallyStopped||!a||"inactive"!==a.state)setTimeout(e,1e3);else{delete t.timeslice;a.start(6e5)}})();"inactive"!==a.state&&"stopped"!==a.state&&a.stop()}};if("number"===typeof t.timeSlice){updateTimeStamp();a.start(t.timeSlice)}else a.start(36e5);t.initCallback&&t.initCallback()};this.timestamps=[];function updateTimeStamp(){r.timestamps.push((new Date).getTime());"function"===typeof t.onTimeStamp&&t.onTimeStamp(r.timestamps[r.timestamps.length-1],r.timestamps)}function getMimeType(e){return a&&a.mimeType?a.mimeType:e.mimeType||"video/webm"}
/**
   * This method stops recording MediaStream.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof MediaStreamRecorder
   * @example
   * recorder.stop(function(blob) {
   *     video.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){e=e||function(){};r.manuallyStopped=true;if(a){this.recordingCallback=e;"recording"===a.state&&a.stop();"number"===typeof t.timeSlice&&setTimeout((function(){r.blob=new Blob(i,{type:getMimeType(t)});r.recordingCallback(r.blob)}),100)}};this.pause=function(){a&&"recording"===a.state&&a.pause()};this.resume=function(){a&&"paused"===a.state&&a.resume()};this.clearRecordedData=function(){a&&"recording"===a.state&&r.stop(clearRecordedDataCB);clearRecordedDataCB()};function clearRecordedDataCB(){i=[];a=null;r.timestamps=[]}var a;
/**
   * Access to native MediaRecorder API
   * @method
   * @memberof MediaStreamRecorder
   * @instance
   * @example
   * var internal = recorder.getInternalRecorder();
   * internal.ondataavailable = function() {}; // override
   * internal.stream, internal.onpause, internal.onstop, etc.
   * @returns {Object} Returns internal recording object.
   */this.getInternalRecorder=function(){return a};function isMediaStreamActive(){if("active"in e){if(!e.active)return false}else if("ended"in e&&e.ended)return false;return true}this.blob=null;
/**
   * Get MediaRecorder readonly state.
   * @method
   * @memberof MediaStreamRecorder
   * @example
   * var state = recorder.getState();
   * @returns {String} Returns recording state.
   */this.getState=function(){return a&&a.state||"inactive"};var n=[];
/**
   * Get MediaRecorder all recording states.
   * @method
   * @memberof MediaStreamRecorder
   * @example
   * var state = recorder.getAllStates();
   * @returns {Array} Returns all recording states
   */this.getAllStates=function(){return n};"undefined"===typeof t.checkForInactiveTracks&&(t.checkForInactiveTracks=false);r=this;(function looper(){if(a&&false!==t.checkForInactiveTracks)if(false!==isMediaStreamActive())setTimeout(looper,1e3);else{t.disableLogs||console.log("MediaStream seems stopped.");r.stop()}})();this.name="MediaStreamRecorder";this.toString=function(){return this.name}}"undefined"!==typeof RecordRTC&&(RecordRTC.MediaStreamRecorder=MediaStreamRecorder);
/**
 * StereoAudioRecorder is a standalone class used by {@link RecordRTC} to bring "stereo" audio-recording in chrome.
 * @summary JavaScript standalone object for stereo audio recording.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef StereoAudioRecorder
 * @class
 * @example
 * var recorder = new StereoAudioRecorder(MediaStream, {
 *     sampleRate: 44100,
 *     bufferSize: 4096
 * });
 * recorder.record();
 * recorder.stop(function(blob) {
 *     video.src = URL.createObjectURL(blob);
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @param {object} config - {sampleRate: 44100, bufferSize: 4096, numberOfAudioChannels: 1, etc.}
 */function StereoAudioRecorder(e,t){if(!getTracks(e,"audio").length)throw"Your stream has no audio tracks.";t=t||{};var r=this;var o=[];var i=[];var a=false;var n=0;var d;var s=2;var u=t.desiredSampRate;true===t.leftChannel&&(s=1);1===t.numberOfAudioChannels&&(s=1);(!s||s<1)&&(s=2);t.disableLogs||console.log("StereoAudioRecorder is set to record number of channels: "+s);"undefined"===typeof t.checkForInactiveTracks&&(t.checkForInactiveTracks=true);function isMediaStreamActive(){if(false===t.checkForInactiveTracks)return true;if("active"in e){if(!e.active)return false}else if("ended"in e&&e.ended)return false;return true}this.record=function(){if(false===isMediaStreamActive())throw"Please make sure MediaStream is active.";resetVariables();b=v=false;a=true;"undefined"!==typeof t.timeSlice&&looper()};function mergeLeftRightBuffers(e,t){function mergeAudioBuffers(e,t){var r=e.numberOfAudioChannels;var o=e.leftBuffers.slice(0);var i=e.rightBuffers.slice(0);var a=e.sampleRate;var n=e.internalInterleavedLength;var d=e.desiredSampRate;if(2===r){o=mergeBuffers(o,n);i=mergeBuffers(i,n);if(d){o=interpolateArray(o,d,a);i=interpolateArray(i,d,a)}}if(1===r){o=mergeBuffers(o,n);d&&(o=interpolateArray(o,d,a))}d&&(a=d);function interpolateArray(e,t,r){var o=Math.round(e.length*(t/r));var i=[];var a=Number((e.length-1)/(o-1));i[0]=e[0];for(var n=1;n<o-1;n++){var d=n*a;var s=Number(Math.floor(d)).toFixed();var c=Number(Math.ceil(d)).toFixed();var u=d-s;i[n]=linearInterpolate(e[s],e[c],u)}i[o-1]=e[e.length-1];return i}function linearInterpolate(e,t,r){return e+(t-e)*r}function mergeBuffers(e,t){var r=new Float64Array(t);var o=0;var i=e.length;for(var a=0;a<i;a++){var n=e[a];r.set(n,o);o+=n.length}return r}function interleave(e,t){var r=e.length+t.length;var o=new Float64Array(r);var i=0;for(var a=0;a<r;){o[a++]=e[i];o[a++]=t[i];i++}return o}function writeUTFBytes(e,t,r){var o=r.length;for(var i=0;i<o;i++)e.setUint8(t+i,r.charCodeAt(i))}var s;2===r&&(s=interleave(o,i));1===r&&(s=o);var c=s.length;var u=44+2*c;var l=new ArrayBuffer(u);var m=new DataView(l);writeUTFBytes(m,0,"RIFF");m.setUint32(4,36+2*c,true);writeUTFBytes(m,8,"WAVE");writeUTFBytes(m,12,"fmt ");m.setUint32(16,16,true);m.setUint16(20,1,true);m.setUint16(22,r,true);m.setUint32(24,a,true);m.setUint32(28,a*r*2,true);m.setUint16(32,2*r,true);m.setUint16(34,16,true);writeUTFBytes(m,36,"data");m.setUint32(40,2*c,true);var g=c;var h=44;var p=1;for(var v=0;v<g;v++){m.setInt16(h,s[v]*(32767*p),true);h+=2}if(t)return t({buffer:l,view:m});postMessage({buffer:l,view:m})}if(e.noWorker)mergeAudioBuffers(e,(function(e){t(e.buffer,e.view)}));else{var r=processInWebWorker(mergeAudioBuffers);r.onmessage=function(e){t(e.data.buffer,e.data.view);c.revokeObjectURL(r.workerURL);r.terminate()};r.postMessage(e)}}function processInWebWorker(e){var t=c.createObjectURL(new Blob([e.toString(),";this.onmessage =  function (eee) {"+e.name+"(eee.data);}"],{type:"application/javascript"}));var r=new Worker(t);r.workerURL=t;return r}
/**
   * This method stops recording MediaStream.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof StereoAudioRecorder
   * @example
   * recorder.stop(function(blob) {
   *     video.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){e=e||function(){};a=false;mergeLeftRightBuffers({desiredSampRate:u,sampleRate:p,numberOfAudioChannels:s,internalInterleavedLength:n,leftBuffers:o,rightBuffers:1===s?[]:i,noWorker:t.noWorker},(function(t,o){r.blob=new Blob([o],{type:"audio/wav"});r.buffer=new ArrayBuffer(o.buffer.byteLength);r.view=o;r.sampleRate=u||p;r.bufferSize=h;r.length=n;b=false;e&&e(r.blob)}))};"undefined"===typeof RecordRTC.Storage&&(RecordRTC.Storage={AudioContextConstructor:null,AudioContext:window.AudioContext||window.webkitAudioContext});RecordRTC.Storage.AudioContextConstructor&&"closed"!==RecordRTC.Storage.AudioContextConstructor.state||(RecordRTC.Storage.AudioContextConstructor=new RecordRTC.Storage.AudioContext);var l=RecordRTC.Storage.AudioContextConstructor;var m=l.createMediaStreamSource(e);var g=[0,256,512,1024,2048,4096,8192,16384];var h="undefined"===typeof t.bufferSize?4096:t.bufferSize;-1===g.indexOf(h)&&(t.disableLogs||console.log("Legal values for buffer-size are "+JSON.stringify(g,null,"\t")));if(l.createJavaScriptNode)d=l.createJavaScriptNode(h,s,s);else{if(!l.createScriptProcessor)throw"WebAudio API has no support on this browser.";d=l.createScriptProcessor(h,s,s)}m.connect(d);t.bufferSize||(h=d.bufferSize);var p="undefined"!==typeof t.sampleRate?t.sampleRate:l.sampleRate||44100;(p<22050||p>96e3)&&(t.disableLogs||console.log("sample-rate must be under range 22050 and 96000."));t.disableLogs||t.desiredSampRate&&console.log("Desired sample-rate: "+t.desiredSampRate);var v=false;this.pause=function(){v=true};this.resume=function(){if(false===isMediaStreamActive())throw"Please make sure MediaStream is active.";if(a)v=false;else{t.disableLogs||console.log("Seems recording has been restarted.");this.record()}};this.clearRecordedData=function(){t.checkForInactiveTracks=false;a&&this.stop(clearRecordedDataCB);clearRecordedDataCB()};function resetVariables(){o=[];i=[];n=0;b=false;a=false;v=false;l=null;r.leftchannel=o;r.rightchannel=i;r.numberOfAudioChannels=s;r.desiredSampRate=u;r.sampleRate=p;r.recordingLength=n;R={left:[],right:[],recordingLength:0}}function clearRecordedDataCB(){if(d){d.onaudioprocess=null;d.disconnect();d=null}if(m){m.disconnect();m=null}resetVariables()}this.name="StereoAudioRecorder";this.toString=function(){return this.name};var b=false;function onAudioProcessDataAvailable(e){if(!v){if(false===isMediaStreamActive()){t.disableLogs||console.log("MediaStream seems stopped.");d.disconnect();a=false}if(a){if(!b){b=true;t.onAudioProcessStarted&&t.onAudioProcessStarted();t.initCallback&&t.initCallback()}var c=e.inputBuffer.getChannelData(0);var u=new Float32Array(c);o.push(u);if(2===s){var l=e.inputBuffer.getChannelData(1);var g=new Float32Array(l);i.push(g)}n+=h;r.recordingLength=n;if("undefined"!==typeof t.timeSlice){R.recordingLength+=h;R.left.push(u);2===s&&R.right.push(g)}}else if(m){m.disconnect();m=null}}}d.onaudioprocess=onAudioProcessDataAvailable;l.createMediaStreamDestination?d.connect(l.createMediaStreamDestination()):d.connect(l.destination);this.leftchannel=o;this.rightchannel=i;this.numberOfAudioChannels=s;this.desiredSampRate=u;this.sampleRate=p;r.recordingLength=n;var R={left:[],right:[],recordingLength:0};function looper(){if(a&&"function"===typeof t.ondataavailable&&"undefined"!==typeof t.timeSlice)if(R.left.length){mergeLeftRightBuffers({desiredSampRate:u,sampleRate:p,numberOfAudioChannels:s,internalInterleavedLength:R.recordingLength,leftBuffers:R.left,rightBuffers:1===s?[]:R.right},(function(e,r){var o=new Blob([r],{type:"audio/wav"});t.ondataavailable(o);setTimeout(looper,t.timeSlice)}));R={left:[],right:[],recordingLength:0}}else setTimeout(looper,t.timeSlice)}}"undefined"!==typeof RecordRTC&&(RecordRTC.StereoAudioRecorder=StereoAudioRecorder);
/**
 * CanvasRecorder is a standalone class used by {@link RecordRTC} to bring HTML5-Canvas recording into video WebM. It uses HTML2Canvas library and runs top over {@link Whammy}.
 * @summary HTML2Canvas recording into video WebM.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef CanvasRecorder
 * @class
 * @example
 * var recorder = new CanvasRecorder(htmlElement, { disableLogs: true, useWhammyRecorder: true });
 * recorder.record();
 * recorder.stop(function(blob) {
 *     video.src = URL.createObjectURL(blob);
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {HTMLElement} htmlElement - querySelector/getElementById/getElementsByTagName[0]/etc.
 * @param {object} config - {disableLogs:true, initCallback: function}
 */function CanvasRecorder(e,t){if("undefined"===typeof html2canvas)throw"Please link: https://www.webrtc-experiment.com/screenshot.js";t=t||{};t.frameInterval||(t.frameInterval=10);var r=false;["captureStream","mozCaptureStream","webkitCaptureStream"].forEach((function(e){e in document.createElement("canvas")&&(r=true)}));var o=(!!window.webkitRTCPeerConnection||!!window.webkitGetUserMedia)&&!!window.chrome;var i=50;var a=navigator.userAgent.match(/Chrom(e|ium)\/([0-9]+)\./);o&&a&&a[2]&&(i=parseInt(a[2],10));o&&i<52&&(r=false);t.useWhammyRecorder&&(r=false);var n,d;if(r){t.disableLogs||console.log("Your browser supports both MediRecorder API and canvas.captureStream!");if(e instanceof HTMLCanvasElement)n=e;else{if(!(e instanceof CanvasRenderingContext2D))throw"Please pass either HTMLCanvasElement or CanvasRenderingContext2D.";n=e.canvas}}else!navigator.mozGetUserMedia||t.disableLogs||console.error("Canvas recording is NOT supported in Firefox.");var s;this.record=function(){s=true;if(r&&!t.useWhammyRecorder){var e;"captureStream"in n?e=n.captureStream(25):"mozCaptureStream"in n?e=n.mozCaptureStream(25):"webkitCaptureStream"in n&&(e=n.webkitCaptureStream(25));try{var o=new p;o.addTrack(getTracks(e,"video")[0]);e=o}catch(e){}if(!e)throw"captureStream API are NOT available.";d=new MediaStreamRecorder(e,{mimeType:t.mimeType||"video/webm"});d.record()}else{l.frames=[];u=(new Date).getTime();drawCanvasFrame()}t.initCallback&&t.initCallback()};this.getWebPImages=function(r){if("canvas"===e.nodeName.toLowerCase()){var o=l.frames.length;l.frames.forEach((function(e,r){var i=o-r;t.disableLogs||console.log(i+"/"+o+" frames remaining");t.onEncodingCallback&&t.onEncodingCallback(i,o);var a=e.image.toDataURL("image/webp",1);l.frames[r].image=a}));t.disableLogs||console.log("Generating WebM");r()}else r()};
/**
   * This method stops recording Canvas.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof CanvasRecorder
   * @example
   * recorder.stop(function(blob) {
   *     video.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){s=false;var o=this;r&&d?d.stop(e):this.getWebPImages((function(){l.compile((function(r){t.disableLogs||console.log("Recording finished!");o.blob=r;o.blob.forEach&&(o.blob=new Blob([],{type:"video/webm"}));e&&e(o.blob);l.frames=[]}))}))};var c=false;this.pause=function(){c=true;d instanceof MediaStreamRecorder&&d.pause()};this.resume=function(){c=false;d instanceof MediaStreamRecorder?d.resume():s||this.record()};this.clearRecordedData=function(){s&&this.stop(clearRecordedDataCB);clearRecordedDataCB()};function clearRecordedDataCB(){l.frames=[];s=false;c=false}this.name="CanvasRecorder";this.toString=function(){return this.name};function cloneCanvas(){var t=document.createElement("canvas");var r=t.getContext("2d");t.width=e.width;t.height=e.height;r.drawImage(e,0,0);return t}function drawCanvasFrame(){if(c){u=(new Date).getTime();return setTimeout(drawCanvasFrame,500)}if("canvas"!==e.nodeName.toLowerCase())html2canvas(e,{grabMouse:"undefined"===typeof t.showMousePointer||t.showMousePointer,onrendered:function(e){var r=(new Date).getTime()-u;if(!r)return setTimeout(drawCanvasFrame,t.frameInterval);u=(new Date).getTime();l.frames.push({image:e.toDataURL("image/webp",1),duration:r});s&&setTimeout(drawCanvasFrame,t.frameInterval)}});else{var r=(new Date).getTime()-u;u=(new Date).getTime();l.frames.push({image:cloneCanvas(),duration:r});s&&setTimeout(drawCanvasFrame,t.frameInterval)}}var u=(new Date).getTime();var l=new b.Video(100)}"undefined"!==typeof RecordRTC&&(RecordRTC.CanvasRecorder=CanvasRecorder);
/**
 * WhammyRecorder is a standalone class used by {@link RecordRTC} to bring video recording in Chrome. It runs top over {@link Whammy}.
 * @summary Video recording feature in Chrome.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef WhammyRecorder
 * @class
 * @example
 * var recorder = new WhammyRecorder(mediaStream);
 * recorder.record();
 * recorder.stop(function(blob) {
 *     video.src = URL.createObjectURL(blob);
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @param {object} config - {disableLogs: true, initCallback: function, video: HTMLVideoElement, etc.}
 */function WhammyRecorder(e,t){t=t||{};t.frameInterval||(t.frameInterval=10);t.disableLogs||console.log("Using frames-interval:",t.frameInterval);this.record=function(){t.width||(t.width=320);t.height||(t.height=240);t.video||(t.video={width:t.width,height:t.height});t.canvas||(t.canvas={width:t.width,height:t.height});i.width=t.canvas.width||320;i.height=t.canvas.height||240;a=i.getContext("2d");if(t.video&&t.video instanceof HTMLVideoElement){n=t.video.cloneNode();t.initCallback&&t.initCallback()}else{n=document.createElement("video");setSrcObject(e,n);n.onloadedmetadata=function(){t.initCallback&&t.initCallback()};n.width=t.video.width;n.height=t.video.height}n.muted=true;n.play();d=(new Date).getTime();s=new b.Video;if(!t.disableLogs){console.log("canvas resolutions",i.width,"*",i.height);console.log("video width/height",n.width||i.width,"*",n.height||i.height)}drawFrames(t.frameInterval)};
/**
   * Draw and push frames to Whammy
   * @param {integer} frameInterval - set minimum interval (in milliseconds) between each time we push a frame to Whammy
   */function drawFrames(e){e="undefined"!==typeof e?e:10;var t=(new Date).getTime()-d;if(!t)return setTimeout(drawFrames,e,e);if(o){d=(new Date).getTime();return setTimeout(drawFrames,100)}d=(new Date).getTime();n.paused&&n.play();a.drawImage(n,0,0,i.width,i.height);s.frames.push({duration:t,image:i.toDataURL("image/webp")});r||setTimeout(drawFrames,e,e)}function asyncLoop(e){var t=-1,r=e.length;(function loop(){t++;t!==r?setTimeout((function(){e.functionToLoop(loop,t)}),1):e.callback()})()}
/**
   * remove black frames from the beginning to the specified frame
   * @param {Array} _frames - array of frames to be checked
   * @param {number} _framesToCheck - number of frame until check will be executed (-1 - will drop all frames until frame not matched will be found)
   * @param {number} _pixTolerance - 0 - very strict (only black pixel color) ; 1 - all
   * @param {number} _frameTolerance - 0 - very strict (only black frame color) ; 1 - all
   * @returns {Array} - array of frames
   */function dropBlackFrames(e,t,r,o,a){var n=document.createElement("canvas");n.width=i.width;n.height=i.height;var d=n.getContext("2d");var s=[];var c=-1===t;var u=t&&t>0&&t<=e.length?t:e.length;var l={r:0,g:0,b:0};var m=Math.sqrt(Math.pow(255,2)+Math.pow(255,2)+Math.pow(255,2));var g=r&&r>=0&&r<=1?r:0;var h=o&&o>=0&&o<=1?o:0;var p=false;asyncLoop({length:u,functionToLoop:function(t,r){var o,a,n;var finishImage=function(){if(!p&&n-o<=n*h);else{c&&(p=true);s.push(e[r])}t()};if(p)finishImage();else{var u=new Image;u.onload=function(){d.drawImage(u,0,0,i.width,i.height);var e=d.getImageData(0,0,i.width,i.height);o=0;a=e.data.length;n=e.data.length/4;for(var t=0;t<a;t+=4){var r={r:e.data[t],g:e.data[t+1],b:e.data[t+2]};var s=Math.sqrt(Math.pow(r.r-l.r,2)+Math.pow(r.g-l.g,2)+Math.pow(r.b-l.b,2));s<=m*g&&o++}finishImage()};u.src=e[r].image}},callback:function(){s=s.concat(e.slice(u));s.length<=0&&s.push(e[e.length-1]);a(s)}})}var r=false;
/**
   * This method stops recording video.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof WhammyRecorder
   * @example
   * recorder.stop(function(blob) {
   *     video.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){e=e||function(){};r=true;var o=this;setTimeout((function(){dropBlackFrames(s.frames,-1,null,null,(function(r){s.frames=r;t.advertisement&&t.advertisement.length&&(s.frames=t.advertisement.concat(s.frames));s.compile((function(t){o.blob=t;o.blob.forEach&&(o.blob=new Blob([],{type:"video/webm"}));e&&e(o.blob)}))}))}),10)};var o=false;this.pause=function(){o=true};this.resume=function(){o=false;r&&this.record()};this.clearRecordedData=function(){r||this.stop(clearRecordedDataCB);clearRecordedDataCB()};function clearRecordedDataCB(){s.frames=[];r=true;o=false}this.name="WhammyRecorder";this.toString=function(){return this.name};var i=document.createElement("canvas");var a=i.getContext("2d");var n;var d;var s}"undefined"!==typeof RecordRTC&&(RecordRTC.WhammyRecorder=WhammyRecorder);
/**
 * Whammy is a standalone class used by {@link RecordRTC} to bring video recording in Chrome. It is written by {@link https://github.com/antimatter15|antimatter15}
 * @summary A real time javascript webm encoder based on a canvas hack.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef Whammy
 * @class
 * @example
 * var recorder = new Whammy().Video(15);
 * recorder.add(context || canvas || dataURL);
 * var output = recorder.compile();
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 */var b=function(){function WhammyVideo(e){this.frames=[];this.duration=e||1;this.quality=.8}
/**
   * Pass Canvas or Context or image/webp(string) to {@link Whammy} encoder.
   * @method
   * @memberof Whammy
   * @example
   * recorder = new Whammy().Video(0.8, 100);
   * recorder.add(canvas || context || 'image/webp');
   * @param {string} frame - Canvas || Context || image/webp
   * @param {number} duration - Stick a duration (in milliseconds)
   */WhammyVideo.prototype.add=function(e,t){"canvas"in e&&(e=e.canvas);"toDataURL"in e&&(e=e.toDataURL("image/webp",this.quality));if(!/^data:image\/webp;base64,/gi.test(e))throw"Input must be formatted properly as a base64 encoded DataURI of type image/webp";this.frames.push({image:e,duration:t||this.duration})};function processInWebWorker(e){var t=c.createObjectURL(new Blob([e.toString(),"this.onmessage =  function (eee) {"+e.name+"(eee.data);}"],{type:"application/javascript"}));var r=new Worker(t);c.revokeObjectURL(t);return r}function whammyInWebWorker(e){function ArrayToWebM(e){var t=checkFrames(e);if(!t)return[];var r=3e4;var o=[{id:440786851,data:[{data:1,id:17030},{data:1,id:17143},{data:4,id:17138},{data:8,id:17139},{data:"webm",id:17026},{data:2,id:17031},{data:2,id:17029}]},{id:408125543,data:[{id:357149030,data:[{data:1e6,id:2807729},{data:"whammy",id:19840},{data:"whammy",id:22337},{data:doubleToString(t.duration),id:17545}]},{id:374648427,data:[{id:174,data:[{data:1,id:215},{data:1,id:29637},{data:0,id:156},{data:"und",id:2274716},{data:"V_VP8",id:134},{data:"VP8",id:2459272},{data:1,id:131},{id:224,data:[{data:t.width,id:176},{data:t.height,id:186}]}]}]}]}];var i=0;var a=0;while(i<e.length){var n=[];var d=0;do{n.push(e[i]);d+=e[i].duration;i++}while(i<e.length&&d<r);var s=0;var c={id:524531317,data:getClusterData(a,s,n)};o[1].data.push(c);a+=d}return generateEBML(o)}function getClusterData(e,t,r){return[{data:e,id:231}].concat(r.map((function(e){var r=makeSimpleBlock({discardable:0,frame:e.data.slice(4),invisible:0,keyframe:1,lacing:0,trackNum:1,timecode:Math.round(t)});t+=e.duration;return{data:r,id:163}})))}function checkFrames(e){if(e[0]){var t=e[0].width,r=e[0].height,o=e[0].duration;for(var i=1;i<e.length;i++)o+=e[i].duration;return{duration:o,width:t,height:r}}postMessage({error:"Something went wrong. Maybe WebP format is not supported in the current browser."})}function numToBuffer(e){var t=[];while(e>0){t.push(255&e);e>>=8}return new Uint8Array(t.reverse())}function strToBuffer(e){return new Uint8Array(e.split("").map((function(e){return e.charCodeAt(0)})))}function bitsToBuffer(e){var t=[];var r=e.length%8?new Array(9-e.length%8).join("0"):"";e=r+e;for(var o=0;o<e.length;o+=8)t.push(parseInt(e.substr(o,8),2));return new Uint8Array(t)}function generateEBML(e){var t=[];for(var r=0;r<e.length;r++){var o=e[r].data;"object"===typeof o&&(o=generateEBML(o));"number"===typeof o&&(o=bitsToBuffer(o.toString(2)));"string"===typeof o&&(o=strToBuffer(o));var i=o.size||o.byteLength||o.length;var a=Math.ceil(Math.ceil(Math.log(i)/Math.log(2))/8);var n=i.toString(2);var d=new Array(7*a+7+1-n.length).join("0")+n;var s=new Array(a).join("0")+"1"+d;t.push(numToBuffer(e[r].id));t.push(bitsToBuffer(s));t.push(o)}return new Blob(t,{type:"video/webm"})}function makeSimpleBlock(e){var t=0;e.keyframe&&(t|=128);e.invisible&&(t|=8);e.lacing&&(t|=e.lacing<<1);e.discardable&&(t|=1);if(e.trackNum>127)throw"TrackNumber > 127 not supported";var r=[128|e.trackNum,e.timecode>>8,255&e.timecode,t].map((function(e){return String.fromCharCode(e)})).join("")+e.frame;return r}function parseWebP(e){var t=e.RIFF[0].WEBP[0];var r=t.indexOf("*");for(var o=0,i=[];o<4;o++)i[o]=t.charCodeAt(r+3+o);var a,n,d;d=i[1]<<8|i[0];a=16383&d;d=i[3]<<8|i[2];n=16383&d;return{width:a,height:n,data:t,riff:e}}function getStrLength(e,t){return parseInt(e.substr(t+4,4).split("").map((function(e){var t=e.charCodeAt(0).toString(2);return new Array(8-t.length+1).join("0")+t})).join(""),2)}function parseRIFF(e){var t=0;var r={};while(t<e.length){var o=e.substr(t,4);var i=getStrLength(e,t);var a=e.substr(t+4+4,i);t+=8+i;r[o]=r[o]||[];"RIFF"===o||"LIST"===o?r[o].push(parseRIFF(a)):r[o].push(a)}return r}function doubleToString(e){return[].slice.call(new Uint8Array(new Float64Array([e]).buffer),0).map((function(e){return String.fromCharCode(e)})).reverse().join("")}var t=new ArrayToWebM(e.map((function(e){var t=parseWebP(parseRIFF(atob(e.image.slice(23))));t.duration=e.duration;return t})));postMessage(t)}
/**
   * Encodes frames in WebM container. It uses WebWorkinvoke to invoke 'ArrayToWebM' method.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof Whammy
   * @example
   * recorder = new Whammy().Video(0.8, 100);
   * recorder.compile(function(blob) {
   *    // blob.size - blob.type
   * });
   */WhammyVideo.prototype.compile=function(e){var t=processInWebWorker(whammyInWebWorker);t.onmessage=function(t){t.data.error?console.error(t.data.error):e(t.data)};t.postMessage(this.frames)};return{
/**
     * A more abstract-ish API.
     * @method
     * @memberof Whammy
     * @example
     * recorder = new Whammy().Video(0.8, 100);
     * @param {?number} speed - 0.8
     * @param {?number} quality - 100
     */
Video:WhammyVideo}}();"undefined"!==typeof RecordRTC&&(RecordRTC.Whammy=b);
/**
 * DiskStorage is a standalone object used by {@link RecordRTC} to store recorded blobs in IndexedDB storage.
 * @summary Writing blobs into IndexedDB.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @example
 * DiskStorage.Store({
 *     audioBlob: yourAudioBlob,
 *     videoBlob: yourVideoBlob,
 *     gifBlob  : yourGifBlob
 * });
 * DiskStorage.Fetch(function(dataURL, type) {
 *     if(type === 'audioBlob') { }
 *     if(type === 'videoBlob') { }
 *     if(type === 'gifBlob')   { }
 * });
 * // DiskStorage.dataStoreName = 'recordRTC';
 * // DiskStorage.onError = function(error) { };
 * @property {function} init - This method must be called once to initialize IndexedDB ObjectStore. Though, it is auto-used internally.
 * @property {function} Fetch - This method fetches stored blobs from IndexedDB.
 * @property {function} Store - This method stores blobs in IndexedDB.
 * @property {function} onError - This function is invoked for any known/unknown error.
 * @property {string} dataStoreName - Name of the ObjectStore created in IndexedDB storage.
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 */var R={init:function(){var e=this;if("undefined"!==typeof indexedDB&&"undefined"!==typeof indexedDB.open){var t=1;var r,o=this.dbName||location.href.replace(/\/|:|#|%|\.|\[|\]/g,"");var i=indexedDB.open(o,t);i.onerror=e.onError;i.onsuccess=function(){r=i.result;r.onerror=e.onError;if(r.setVersion)if(r.version!==t){var o=r.setVersion(t);o.onsuccess=function(){createObjectStore(r);putInDB()}}else putInDB();else putInDB()};i.onupgradeneeded=function(e){createObjectStore(e.target.result)}}else console.error("IndexedDB API are not available in this browser.");function createObjectStore(t){t.createObjectStore(e.dataStoreName)}function putInDB(){var t=r.transaction([e.dataStoreName],"readwrite");e.videoBlob&&t.objectStore(e.dataStoreName).put(e.videoBlob,"videoBlob");e.gifBlob&&t.objectStore(e.dataStoreName).put(e.gifBlob,"gifBlob");e.audioBlob&&t.objectStore(e.dataStoreName).put(e.audioBlob,"audioBlob");function getFromStore(r){t.objectStore(e.dataStoreName).get(r).onsuccess=function(t){e.callback&&e.callback(t.target.result,r)}}getFromStore("audioBlob");getFromStore("videoBlob");getFromStore("gifBlob")}},Fetch:function(e){this.callback=e;this.init();return this},Store:function(e){this.audioBlob=e.audioBlob;this.videoBlob=e.videoBlob;this.gifBlob=e.gifBlob;this.init();return this},onError:function(e){console.error(JSON.stringify(e,null,"\t"))},dataStoreName:"recordRTC",dbName:null};"undefined"!==typeof RecordRTC&&(RecordRTC.DiskStorage=R);
/**
 * GifRecorder is standalone calss used by {@link RecordRTC} to record video or canvas into animated gif.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef GifRecorder
 * @class
 * @example
 * var recorder = new GifRecorder(mediaStream || canvas || context, { onGifPreview: function, onGifRecordingStarted: function, width: 1280, height: 720, frameRate: 200, quality: 10 });
 * recorder.record();
 * recorder.stop(function(blob) {
 *     img.src = URL.createObjectURL(blob);
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object or HTMLCanvasElement or CanvasRenderingContext2D.
 * @param {object} config - {disableLogs:true, initCallback: function, width: 320, height: 240, frameRate: 200, quality: 10}
 */function GifRecorder(e,t){if("undefined"===typeof GIFEncoder){var r=document.createElement("script");r.src="https://www.webrtc-experiment.com/gif-recorder.js";(document.body||document.documentElement).appendChild(r)}t=t||{};var o=e instanceof CanvasRenderingContext2D||e instanceof HTMLCanvasElement;this.record=function(){if("undefined"!==typeof GIFEncoder)if(c){if(!o){t.width||(t.width=u.offsetWidth||320);t.height||(t.height=u.offsetHeight||240);t.video||(t.video={width:t.width,height:t.height});t.canvas||(t.canvas={width:t.width,height:t.height});n.width=t.canvas.width||320;n.height=t.canvas.height||240;u.width=t.video.width||320;u.height=t.video.height||240}g=new GIFEncoder;g.setRepeat(0);g.setDelay(t.frameRate||200);g.setQuality(t.quality||10);g.start();"function"===typeof t.onGifRecordingStarted&&t.onGifRecordingStarted();Date.now();l=a(drawVideoFrame);t.initCallback&&t.initCallback()}else setTimeout(h.record,1e3);else setTimeout(h.record,1e3);function drawVideoFrame(e){if(true!==h.clearedRecordedData){if(i)return setTimeout((function(){drawVideoFrame(e)}),100);l=a(drawVideoFrame);void 0===typeof m&&(m=e);if(!(e-m<90)){!o&&u.paused&&u.play();o||s.drawImage(u,0,0,n.width,n.height);t.onGifPreview&&t.onGifPreview(n.toDataURL("image/png"));g.addFrame(s);m=e}}}};
/**
   * This method stops recording MediaStream.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof GifRecorder
   * @example
   * recorder.stop(function(blob) {
   *     img.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){e=e||function(){};l&&d(l);Date.now();this.blob=new Blob([new Uint8Array(g.stream().bin)],{type:"image/gif"});e(this.blob);g.stream().bin=[]};var i=false;this.pause=function(){i=true};this.resume=function(){i=false};this.clearRecordedData=function(){h.clearedRecordedData=true;clearRecordedDataCB()};function clearRecordedDataCB(){g&&(g.stream().bin=[])}this.name="GifRecorder";this.toString=function(){return this.name};var n=document.createElement("canvas");var s=n.getContext("2d");if(o)if(e instanceof CanvasRenderingContext2D){s=e;n=s.canvas}else if(e instanceof HTMLCanvasElement){s=e.getContext("2d");n=e}var c=true;if(!o){var u=document.createElement("video");u.muted=true;u.autoplay=true;u.playsInline=true;c=false;u.onloadedmetadata=function(){c=true};setSrcObject(e,u);u.play()}var l=null;var m;var g;var h=this}"undefined"!==typeof RecordRTC&&(RecordRTC.GifRecorder=GifRecorder);function MultiStreamsMixer(e,r){var o="Fake/5.0 (FakeOS) AppleWebKit/123 (KHTML, like Gecko) Fake/12.3.4567.89 Fake/123.45";(function(e){if("undefined"===typeof RecordRTC&&e&&"undefined"===typeof window&&"undefined"!==typeof t){t.navigator={userAgent:o,getUserMedia:function(){}};t.console||(t.console={});"undefined"!==typeof t.console.log&&"undefined"!==typeof t.console.error||(t.console.error=t.console.log=t.console.log||function(){console.log(arguments)});if("undefined"===typeof document){e.document={documentElement:{appendChild:function(){return""}}};document.createElement=document.captureStream=document.mozCaptureStream=function(){var e={getContext:function(){return e},play:function(){},pause:function(){},drawImage:function(){},toDataURL:function(){return""},style:{}};return e};e.HTMLVideoElement=function(){}}"undefined"===typeof location&&(e.location={protocol:"file:",href:"",hash:""});"undefined"===typeof screen&&(e.screen={width:0,height:0});"undefined"===typeof u&&(e.URL={createObjectURL:function(){return""},revokeObjectURL:function(){return""}});e.window=t}})("undefined"!==typeof t?t:null);r=r||"multi-streams-mixer";var i=[];var a=false;var n=document.createElement("canvas");var d=n.getContext("2d");n.style.opacity=0;n.style.position="absolute";n.style.zIndex=-1;n.style.top="-1000em";n.style.left="-1000em";n.className=r;(document.body||document.documentElement).appendChild(n);this.disableLogs=false;this.frameInterval=10;this.width=360;this.height=240;this.useGainNode=true;var s=this;var c=window.AudioContext;if("undefined"===typeof c){"undefined"!==typeof webkitAudioContext&&(c=webkitAudioContext);"undefined"!==typeof mozAudioContext&&(c=mozAudioContext)}var u=window.URL;"undefined"===typeof u&&"undefined"!==typeof webkitURL&&(u=webkitURL);if("undefined"!==typeof navigator&&"undefined"===typeof navigator.getUserMedia){"undefined"!==typeof navigator.webkitGetUserMedia&&(navigator.getUserMedia=navigator.webkitGetUserMedia);"undefined"!==typeof navigator.mozGetUserMedia&&(navigator.getUserMedia=navigator.mozGetUserMedia)}var l=window.MediaStream;"undefined"===typeof l&&"undefined"!==typeof webkitMediaStream&&(l=webkitMediaStream);"undefined"!==typeof l&&"undefined"===typeof l.prototype.stop&&(l.prototype.stop=function(){this.getTracks().forEach((function(e){e.stop()}))});var m={};"undefined"!==typeof c?m.AudioContext=c:"undefined"!==typeof webkitAudioContext&&(m.AudioContext=webkitAudioContext);function setSrcObject(e,t){"srcObject"in t?t.srcObject=e:"mozSrcObject"in t?t.mozSrcObject=e:t.srcObject=e}this.startDrawingFrames=function(){drawVideosToCanvas()};function drawVideosToCanvas(){if(!a){var e=i.length;var t=false;var r=[];i.forEach((function(e){e.stream||(e.stream={});e.stream.fullcanvas?t=e:r.push(e)}));if(t){n.width=t.stream.width;n.height=t.stream.height}else if(r.length){n.width=e>1?2*r[0].width:r[0].width;var o=1;3!==e&&4!==e||(o=2);5!==e&&6!==e||(o=3);7!==e&&8!==e||(o=4);9!==e&&10!==e||(o=5);n.height=r[0].height*o}else{n.width=s.width||360;n.height=s.height||240}t&&t instanceof HTMLVideoElement&&drawImage(t);r.forEach((function(e,t){drawImage(e,t)}));setTimeout(drawVideosToCanvas,s.frameInterval)}}function drawImage(e,t){if(!a){var r=0;var o=0;var i=e.width;var n=e.height;1===t&&(r=e.width);2===t&&(o=e.height);if(3===t){r=e.width;o=e.height}4===t&&(o=2*e.height);if(5===t){r=e.width;o=2*e.height}6===t&&(o=3*e.height);if(7===t){r=e.width;o=3*e.height}"undefined"!==typeof e.stream.left&&(r=e.stream.left);"undefined"!==typeof e.stream.top&&(o=e.stream.top);"undefined"!==typeof e.stream.width&&(i=e.stream.width);"undefined"!==typeof e.stream.height&&(n=e.stream.height);d.drawImage(e,r,o,i,n);"function"===typeof e.stream.onRender&&e.stream.onRender(d,r,o,i,n,t)}}function getMixedStream(){a=false;var t=getMixedVideoStream();var r=getMixedAudioStream();r&&r.getTracks().filter((function(e){return"audio"===e.kind})).forEach((function(e){t.addTrack(e)}));e.forEach((function(e){e.fullcanvas&&true}));return t}function getMixedVideoStream(){resetVideoStreams();var e;"captureStream"in n?e=n.captureStream():"mozCaptureStream"in n?e=n.mozCaptureStream():s.disableLogs||console.error("Upgrade to latest Chrome or otherwise enable this flag: chrome://flags/#enable-experimental-web-platform-features");var t=new l;e.getTracks().filter((function(e){return"video"===e.kind})).forEach((function(e){t.addTrack(e)}));n.stream=t;return t}function getMixedAudioStream(){m.AudioContextConstructor||(m.AudioContextConstructor=new m.AudioContext);s.audioContext=m.AudioContextConstructor;s.audioSources=[];if(true===s.useGainNode){s.gainNode=s.audioContext.createGain();s.gainNode.connect(s.audioContext.destination);s.gainNode.gain.value=0}var t=0;e.forEach((function(e){if(e.getTracks().filter((function(e){return"audio"===e.kind})).length){t++;var r=s.audioContext.createMediaStreamSource(e);true===s.useGainNode&&r.connect(s.gainNode);s.audioSources.push(r)}}));if(t){s.audioDestination=s.audioContext.createMediaStreamDestination();s.audioSources.forEach((function(e){e.connect(s.audioDestination)}));return s.audioDestination.stream}}function getVideo(e){var t=document.createElement("video");setSrcObject(e,t);t.className=r;t.muted=true;t.volume=0;t.width=e.width||s.width||360;t.height=e.height||s.height||240;t.play();return t}this.appendStreams=function(t){if(!t)throw"First parameter is required.";t instanceof Array||(t=[t]);t.forEach((function(t){var r=new l;if(t.getTracks().filter((function(e){return"video"===e.kind})).length){var o=getVideo(t);o.stream=t;i.push(o);r.addTrack(t.getTracks().filter((function(e){return"video"===e.kind}))[0])}if(t.getTracks().filter((function(e){return"audio"===e.kind})).length){var a=s.audioContext.createMediaStreamSource(t);s.audioDestination=s.audioContext.createMediaStreamDestination();a.connect(s.audioDestination);r.addTrack(s.audioDestination.stream.getTracks().filter((function(e){return"audio"===e.kind}))[0])}e.push(r)}))};this.releaseStreams=function(){i=[];a=true;if(s.gainNode){s.gainNode.disconnect();s.gainNode=null}if(s.audioSources.length){s.audioSources.forEach((function(e){e.disconnect()}));s.audioSources=[]}if(s.audioDestination){s.audioDestination.disconnect();s.audioDestination=null}s.audioContext&&s.audioContext.close();s.audioContext=null;d.clearRect(0,0,n.width,n.height);if(n.stream){n.stream.stop();n.stream=null}};this.resetVideoStreams=function(e){!e||e instanceof Array||(e=[e]);resetVideoStreams(e)};function resetVideoStreams(t){i=[];t=t||e;t.forEach((function(e){if(e.getTracks().filter((function(e){return"video"===e.kind})).length){var t=getVideo(e);t.stream=e;i.push(t)}}))}this.name="MultiStreamsMixer";this.toString=function(){return this.name};this.getMixedStream=getMixedStream}"undefined"===typeof RecordRTC&&(r=MultiStreamsMixer);
/**
 * MultiStreamRecorder can record multiple videos in single container.
 * @summary Multi-videos recorder.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef MultiStreamRecorder
 * @class
 * @example
 * var options = {
 *     mimeType: 'video/webm'
 * }
 * var recorder = new MultiStreamRecorder(ArrayOfMediaStreams, options);
 * recorder.record();
 * recorder.stop(function(blob) {
 *     video.src = URL.createObjectURL(blob);
 *
 *     // or
 *     var blob = recorder.blob;
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStreams} mediaStreams - Array of MediaStreams.
 * @param {object} config - {disableLogs:true, frameInterval: 1, mimeType: "video/webm"}
 */function MultiStreamRecorder(e,t){e=e||[];var r=this;var o;var i;t=t||{elementClass:"multi-streams-mixer",mimeType:"video/webm",video:{width:360,height:240}};t.frameInterval||(t.frameInterval=10);t.video||(t.video={});t.video.width||(t.video.width=360);t.video.height||(t.video.height=240);this.record=function(){o=new MultiStreamsMixer(e,t.elementClass||"multi-streams-mixer");if(getAllVideoTracks().length){o.frameInterval=t.frameInterval||10;o.width=t.video.width||360;o.height=t.video.height||240;o.startDrawingFrames()}t.previewStream&&"function"===typeof t.previewStream&&t.previewStream(o.getMixedStream());i=new MediaStreamRecorder(o.getMixedStream(),t);i.record()};function getAllVideoTracks(){var t=[];e.forEach((function(e){getTracks(e,"video").forEach((function(e){t.push(e)}))}));return t}
/**
   * This method stops recording MediaStream.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof MultiStreamRecorder
   * @example
   * recorder.stop(function(blob) {
   *     video.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){i&&i.stop((function(t){r.blob=t;e(t);r.clearRecordedData()}))};this.pause=function(){i&&i.pause()};this.resume=function(){i&&i.resume()};this.clearRecordedData=function(){if(i){i.clearRecordedData();i=null}if(o){o.releaseStreams();o=null}};
/**
   * Add extra media-streams to existing recordings.
   * @method
   * @memberof MultiStreamRecorder
   * @param {MediaStreams} mediaStreams - Array of MediaStreams
   * @example
   * recorder.addStreams([newAudioStream, newVideoStream]);
   */this.addStreams=function(r){if(!r)throw"First parameter is required.";r instanceof Array||(r=[r]);e.concat(r);if(i&&o){o.appendStreams(r);t.previewStream&&"function"===typeof t.previewStream&&t.previewStream(o.getMixedStream())}};
/**
   * Reset videos during live recording. Replace old videos e.g. replace cameras with full-screen.
   * @method
   * @memberof MultiStreamRecorder
   * @param {MediaStreams} mediaStreams - Array of MediaStreams
   * @example
   * recorder.resetVideoStreams([newVideo1, newVideo2]);
   */this.resetVideoStreams=function(e){if(o){!e||e instanceof Array||(e=[e]);o.resetVideoStreams(e)}};this.getMixer=function(){return o};this.name="MultiStreamRecorder";this.toString=function(){return this.name}}"undefined"!==typeof RecordRTC&&(RecordRTC.MultiStreamRecorder=MultiStreamRecorder);
/**
 * RecordRTCPromisesHandler adds promises support in {@link RecordRTC}. Try a {@link https://github.com/muaz-khan/RecordRTC/blob/master/simple-demos/RecordRTCPromisesHandler.html|demo here}
 * @summary Promises for {@link RecordRTC}
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef RecordRTCPromisesHandler
 * @class
 * @example
 * var recorder = new RecordRTCPromisesHandler(mediaStream, options);
 * recorder.startRecording()
 *         .then(successCB)
 *         .catch(errorCB);
 * // Note: You can access all RecordRTC API using "recorder.recordRTC" e.g. 
 * recorder.recordRTC.onStateChanged = function(state) {};
 * recorder.recordRTC.setRecordingDuration(5000);
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - Single media-stream object, array of media-streams, html-canvas-element, etc.
 * @param {object} config - {type:"video", recorderType: MediaStreamRecorder, disableLogs: true, numberOfAudioChannels: 1, bufferSize: 0, sampleRate: 0, video: HTMLVideoElement, etc.}
 * @throws Will throw an error if "new" keyword is not used to initiate "RecordRTCPromisesHandler". Also throws error if first argument "MediaStream" is missing.
 * @requires {@link RecordRTC}
 */function RecordRTCPromisesHandler(e,t){if(!this)throw'Use "new RecordRTCPromisesHandler()"';if("undefined"===typeof e)throw'First argument "MediaStream" is required.';var r=this;r.recordRTC=new RecordRTC(e,t);this.startRecording=function(){return new Promise((function(e,t){try{r.recordRTC.startRecording();e()}catch(e){t(e)}}))};this.stopRecording=function(){return new Promise((function(e,t){try{r.recordRTC.stopRecording((function(o){r.blob=r.recordRTC.getBlob();r.blob&&r.blob.size?e(o):t("Empty blob.",r.blob)}))}catch(e){t(e)}}))};this.pauseRecording=function(){return new Promise((function(e,t){try{r.recordRTC.pauseRecording();e()}catch(e){t(e)}}))};this.resumeRecording=function(){return new Promise((function(e,t){try{r.recordRTC.resumeRecording();e()}catch(e){t(e)}}))};this.getDataURL=function(e){return new Promise((function(e,t){try{r.recordRTC.getDataURL((function(t){e(t)}))}catch(e){t(e)}}))};this.getBlob=function(){return new Promise((function(e,t){try{e(r.recordRTC.getBlob())}catch(e){t(e)}}))};
/**
   * This method returns the internal recording object.
   * @method
   * @memberof RecordRTCPromisesHandler
   * @example
   * let internalRecorder = await recorder.getInternalRecorder();
   * if(internalRecorder instanceof MultiStreamRecorder) {
   *     internalRecorder.addStreams([newAudioStream]);
   *     internalRecorder.resetVideoStreams([screenStream]);
   * }
   * @returns {Object} 
   */this.getInternalRecorder=function(){return new Promise((function(e,t){try{e(r.recordRTC.getInternalRecorder())}catch(e){t(e)}}))};this.reset=function(){return new Promise((function(e,t){try{e(r.recordRTC.reset())}catch(e){t(e)}}))};this.destroy=function(){return new Promise((function(e,t){try{e(r.recordRTC.destroy())}catch(e){t(e)}}))};
/**
   * Get recorder's readonly state.
   * @method
   * @memberof RecordRTCPromisesHandler
   * @example
   * let state = await recorder.getState();
   * // or
   * recorder.getState().then(state => { console.log(state); })
   * @returns {String} Returns recording state.
   */this.getState=function(){return new Promise((function(e,t){try{e(r.recordRTC.getState())}catch(e){t(e)}}))};this.blob=null;this.version="5.6.2"}"undefined"!==typeof RecordRTC&&(RecordRTC.RecordRTCPromisesHandler=RecordRTCPromisesHandler);
/**
 * WebAssemblyRecorder lets you create webm videos in JavaScript via WebAssembly. The library consumes raw RGBA32 buffers (4 bytes per pixel) and turns them into a webm video with the given framerate and quality. This makes it compatible out-of-the-box with ImageData from a CANVAS. With realtime mode you can also use webm-wasm for streaming webm videos.
 * @summary Video recording feature in Chrome, Firefox and maybe Edge.
 * @license {@link https://github.com/muaz-khan/RecordRTC/blob/master/LICENSE|MIT}
 * @author {@link https://MuazKhan.com|Muaz Khan}
 * @typedef WebAssemblyRecorder
 * @class
 * @example
 * var recorder = new WebAssemblyRecorder(mediaStream);
 * recorder.record();
 * recorder.stop(function(blob) {
 *     video.src = URL.createObjectURL(blob);
 * });
 * @see {@link https://github.com/muaz-khan/RecordRTC|RecordRTC Source Code}
 * @param {MediaStream} mediaStream - MediaStream object fetched using getUserMedia API or generated using captureStreamUntilEnded or WebAudio API.
 * @param {object} config - {webAssemblyPath:'webm-wasm.wasm',workerPath: 'webm-worker.js', frameRate: 30, width: 1920, height: 1080, bitrate: 1024, realtime: true}
 */function WebAssemblyRecorder(e,t){"undefined"!==typeof ReadableStream&&"undefined"!==typeof WritableStream||console.error("Following polyfill is strongly recommended: https://unpkg.com/@mattiasbuelens/web-streams-polyfill/dist/polyfill.min.js");t=t||{};t.width=t.width||640;t.height=t.height||480;t.frameRate=t.frameRate||30;t.bitrate=t.bitrate||1200;t.realtime=t.realtime||true;var r;function cameraStream(){return new ReadableStream({start:function(o){var i=document.createElement("canvas");var a=document.createElement("video");var n=true;a.srcObject=e;a.muted=true;a.height=t.height;a.width=t.width;a.volume=0;a.onplaying=function(){i.width=t.width;i.height=t.height;var e=i.getContext("2d");var d=1e3/t.frameRate;var s=setInterval((function f(){if(r){clearInterval(s);o.close()}if(n){n=false;t.onVideoProcessStarted&&t.onVideoProcessStarted()}e.drawImage(a,0,0);if("closed"!==o._controlledReadableStream.state)try{o.enqueue(e.getImageData(0,0,t.width,t.height))}catch(e){}}),d)};a.play()}})}var o;function startRecording(e,n){if(t.workerPath||n){if(!t.workerPath&&n instanceof ArrayBuffer){var d=new Blob([n],{type:"text/javascript"});t.workerPath=c.createObjectURL(d)}t.workerPath||console.error("workerPath parameter is missing.");o=new Worker(t.workerPath);o.postMessage(t.webAssemblyPath||"https://unpkg.com/webm-wasm@latest/dist/webm-wasm.wasm");o.addEventListener("message",(function(e){if("READY"===e.data){o.postMessage({width:t.width,height:t.height,bitrate:t.bitrate||1200,timebaseDen:t.frameRate||30,realtime:t.realtime});cameraStream().pipeTo(new WritableStream({write:function(e){r?console.error("Got image, but recorder is finished!"):o.postMessage(e.data.buffer,[e.data.buffer])}}))}else!e.data||i||a.push(e.data)}))}else{r=false;fetch("https://unpkg.com/webm-wasm@latest/dist/webm-worker.js").then((function(t){t.arrayBuffer().then((function(t){startRecording(e,t)}))}))}}this.record=function(){a=[];i=false;this.blob=null;startRecording(e);"function"===typeof t.initCallback&&t.initCallback()};var i;this.pause=function(){i=true};this.resume=function(){i=false};function terminate(e){if(o){o.addEventListener("message",(function(t){if(null===t.data){o.terminate();o=null;e&&e()}}));o.postMessage(null)}else e&&e()}var a=[];
/**
   * This method stops recording video.
   * @param {function} callback - Callback function, that is used to pass recorded blob back to the callee.
   * @method
   * @memberof WebAssemblyRecorder
   * @example
   * recorder.stop(function(blob) {
   *     video.src = URL.createObjectURL(blob);
   * });
   */this.stop=function(e){r=true;var t=this;terminate((function(){t.blob=new Blob(a,{type:"video/webm"});e(t.blob)}))};this.name="WebAssemblyRecorder";this.toString=function(){return this.name};this.clearRecordedData=function(){a=[];i=false;this.blob=null};this.blob=null}"undefined"!==typeof RecordRTC&&(RecordRTC.WebAssemblyRecorder=WebAssemblyRecorder);var w=r;export default w;

