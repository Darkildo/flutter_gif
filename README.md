# gif

## Overview

We should know that in order to achieve Gif in flutter, we can use Image, but we have no way to manipulate Gif, for example: change its speed, control it has been playing in a frame,
 in which frame range loop. These problems can be solved by this widget, it also help you contain gif cache, avoid load frame every time.

## Example

 Load a gif asynchronously and display a text placeholder during loading.<br>
 When the gif is loaded reset the controller and run the gif to the end.

 ```dart

final asset = AssetImage("images/animate.gif");


// add Future to store prepared Gif in memory
// and clear it from RAM after Timeout.
unawaited(
        GifCacheManager().addGifToCache(
          asset,
          clearTimeout: const Duration(minutes: 4),
        ),
      );

GifController _controller = GifController(vsync: this);

Gif(
     image: asset,
     controller: _controller, // if duration and fps is null,
     // original gif fps will be used.
     //fps: 30,               
     //duration: const Duration(seconds: 3),
     autostart: Autostart.no,
     placeholder: (context) => const Text('Loading...'),
     onFetchCompleted: () {
          _controller.reset();
          _controller.forward();
     },
),
 ```

# Thanks
* [flutter_gifimage](https://github.com/peng8350/flutter_gifimage)  
* [gif](https://pub.dev/packages/gif)  


Powered By Requiem

# License

```
MIT License

Copyright (c) 2019 Jpeng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```