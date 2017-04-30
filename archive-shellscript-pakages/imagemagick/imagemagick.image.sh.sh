#! /bin/bash

vector_head="path 'M 0,0  l -15,-5  +5,+5  -5,+5  +15,-5 z'"
  indicator="path 'M 10,0  l +15,+5  -5,-5  +5,-5  -15,+5  m +10,0 +20,0 '"

declare -A  cC # centerCircle
cC[x]=10
cC[y]=10
r=1 

convert -size 200x150 xc: \
        -draw "stroke black fill none  circle ${cC[x]},${cC[y]} ${cC[x]}+r,${cC[y]}+r
                 push graphic-context
                   stroke blue fill skyblue
                   translate 10,10 rotate 90
                   line 0,0  100,0
                   translate 200,0
                   $vector_head
                 pop graphic-context
                 push graphic-context
                   stroke firebrick fill tomato
                   translate 20,50 rotate 40
                   $indicator
                   translate 40,0 rotate -40
                   stroke none fill firebrick
                   text 3,6 'Center'
                 pop graphic-context
                " \
          a.png

eog a.png
