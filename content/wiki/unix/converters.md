+++
title = "converters"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "unix",
    "converters"
]
date = "2013-10-19"
+++
# Converters 

## Video converting/concatenating etc 

Met behulp van `ffmpeg` (https://trac.ffmpeg.org/wiki/How%20to%20concatenate%20(join,%20merge)%20media%20files):

#### Concatting 

Alle files die eindigen op mp4:

```
ffmpeg -f concat -i <(printf "file '%s'<br/>n" ./*.mp4) -c copy output.mp4
```

Gaat ook met `mplayer` en de tool `mencoder`:

```
mencoder -oac pcm -ovc copy -idx -o all.mp4 1.mp4 2.mp4 3.mp4 4.mp4 5.mp4
```

#### Resizing (compressing) 

Ook met `ffmpeg` - bijvoorbeeld reduceren naar "medium" quality. Neem alle mp4s in folder:

```
for i in *.mp4 ; do ffmpeg -i "$i" -c:a copy -preset medium "${i%.*}_medium.${i##*.}"; done
```

Voor meer presets zoals "medium", zie http://trac.ffmpeg.org/wiki/x264EncodingGuide