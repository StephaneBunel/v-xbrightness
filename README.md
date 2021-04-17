# xbrightness

`xbrightness` is a tool to adjust the brightness of all connected monitors in one command.
xbrightness use `xrandr` to handle monitors, so it must be installed.

I wrote this tool:
  * to solve a problem I had with my new laptop (`xbacklight` doesn't work)
  * play with V lang (http://vlang.io).
  
## Usage

Adjust brightness 10% higher:
```shell
xbrightness +10
```

Adjust brightness 20% lower:
```shell
xbrightness -20
```

Set brightness to 80%:
```shell
xbrightness =80
```

Show status of connected monitors:
```shell
xbrightness status
```

## Configuration

By default xbrightness try to find xranrd in PATH.
You can set the path to xrandr by setting environment variable ```XBR_XRANDR```.

## How to build
 
```shell
v . -prod -o xbrightness
```
