(function() {
  
  var canvasdata = null;
  
  function takepicture() {
    var context = canvas.getContext('2d');
    if (width && height) {
      canvas.width = width;
      canvas.height = height;
      context.drawImage(video, 0, 0, width, height);
    
      var data = canvas.toDataURL('image/jpeg');
      console.log("Took");
      canvasdata = data;
    } else {
      
    }
  }
  
  var binding = new Shiny.InputBinding();
  
  $.extend(binding, {
    find: function(scope) {
      return $(scope).find('#webcaminput');   
    },
  
    initialize: function(el){
      video = document.getElementById('video');
      canvas = document.getElementById('canvas');
      startbutton = document.getElementById('startbutton');
  
      navigator.mediaDevices.getUserMedia(
        {
          video: true,
          audio: false
        }
      ).then(
        function(stream) {
        	video.srcObject = stream;
        	video.onloadedmetadata = function(e) {
      		  video.play();
  	      };
        },
        function(err) {
          alert("An error occured! " + err);
        }
      );
  
      video.addEventListener('canplay', function(ev){
        if (!streaming) {
          height = video.videoHeight / (video.videoWidth/width);
        
          // Firefox currently has a bug where the height can't be read from
          // the video, so we will make assumptions if this happens.
          if (isNaN(height)) {
            height = width / (4/3);
          }
        
          video.setAttribute('width', width);
          video.setAttribute('height', height);
          canvas.setAttribute('width', width);
          canvas.setAttribute('height', height);
          streaming = true;
        }
      }, false);
    },
    
    getValue: function(el) {  
      console.log(canvasdata);
      return canvasdata;
    },
  
    subscribe: function(el, callback) {   
      $('#startbutton').click(function(){
        takepicture();
        callback();
      });
    }
  });
  
  Shiny.inputBindings.register(binding);
  
  // The width and height of the captured photo. We will set the
  // width to the value defined here, but the height will be
  // calculated based on the aspect ratio of the input stream.

  var width = 280;    // We will scale the photo width to this
  var height = 0;     // This will be computed based on the input stream

  // |streaming| indicates whether or not we're currently streaming
  // video from the camera. Obviously, we start at false.

  var streaming = false;

  // The various HTML elements we need to configure or control. These
  // will be set by the startup() function.

  var video = null;
  var canvas = null;
  var startbutton = null;

  function startup() {
    
  }

  // Set up our event listener to run the startup process
  // once loading is complete.
  window.addEventListener('load', startup, false);
})();
