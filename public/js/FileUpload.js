var xhr = new XMLHttpRequest();
var file = null;

app.ports.isUploadSupported.subscribe(function () {
  var uploadable = (xhr && ("upload" in xhr));
  app.ports.uploadIsSupported.send(uploadable);
});

app.ports.fileSelected.subscribe(function (id) {
  var $fileInput = document.getElementById(id);
  if ($fileInput === null) {
    app.ports.fileSelectedData.send(null);
  }

  file = $fileInput.files[0];
    var portData = {
      filename: file.name,
      filetype: file.type,
      size: file.size
    };
  app.ports.fileSelectedData.send(portData);
});

app.ports.fileUpload.subscribe(function (id) {
  var formData = new FormData();
  var action = '/upload';
  var $fileInput = document.getElementById(id);
  var file = $fileInput.files[0];

  function sendXHRequest(formData, uri) {
    var xhr = new XMLHttpRequest();

    xhr.upload.addEventListener('loadstart', onloadstartHandler, false);
    xhr.upload.addEventListener('progress', onprogressHandler, false);
    xhr.upload.addEventListener('load', onloadHandler, false);
    xhr.addEventListener('readystatechange', onreadystatechangeHandler, false);

    xhr.open('POST', uri, true);
    xhr.send(formData);
  }

  // Handle the start of the transmission
  function onloadstartHandler(evt) {
    var div = document.getElementById('upload-status');
    div.innerHTML = 'Upload started.';
  }

  // Handle the end of the transmission
  function onloadHandler(evt) {
    var div = document.getElementById('upload-status');
    div.innerHTML += '<' + 'br>File uploaded. Waiting for response.';
  }

  // Handle the progress
  function onprogressHandler(evt) {
    var div = document.getElementById('progress');
    var percent = evt.loaded/evt.total*100;
    div.innerHTML = 'Progress: ' + percent + '%';
  }

  // Handle the response from the server
  function onreadystatechangeHandler(evt) {
    var status, text, readyState;

    try {
      readyState = evt.target.readyState;
      text = evt.target.responseText;
      status = evt.target.status;
    }
    catch(e) {
      return;
    }

    if (readyState == 4 && status == '200' && evt.target.responseText) {
      var token = evt.target.responseText
      app.ports.fileUploadResult.send(token);
    }
  }

  formData.append(id, file);
  sendXHRequest(formData, action);
});
