# RecursiveVideoConverter
This script allows you to convert a number of files using *__ffmpeg__*

## __USAGE__

```
cd RecursiveVideoConverter

sudo chmod +x recursive_video_converter.sh

# Example without GPU
./recursive_video_converter.sh -p /video/folder/path/ -i mkv -o mp4

# Example without GPU
./recursive_video_converter.sh -p /video/folder/path/ -i mkv -o mp4 -g
```

## __PARAMETERS__

| Param | Description                                        | Example            | Default         |
| :---: | -------------------------------------------------- | :----------------- | :-------------: |
| -p    | Indicates the location of the video folder         | /folder/path/      |
| -i    | Indicates the extension of the video to convert    | mkv, mp4, avi, ... |
| -o    | Indicates the extension of the files to convert to | mkv, mp4, avi, ... |
| -l    | Indicates where to place the log file              | /folder/path/      | Script location |
| -g    | Indicates whether to use the GPU*                  | *No parameters*    | False           |
| -h    | Help command                                       |

### *__GPU Usage__

*__ffmpeg__* can use the *__Cuda cores__* of Nvidia video cards, however, before using it you need to install the necessary drivers for your GPU

