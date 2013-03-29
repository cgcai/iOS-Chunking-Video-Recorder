iOS-Chunking-Video-Recorder
===========================

A class that can chunk a video stream into multiple files.

##Limitations##
1. Video preview layer does not rotate to interface orientation.
2. ~230ms of dropped frames between chunks. TODO: resolve by using software encoding instead of `AVCaptureMovieFileOutput`.