
X_FILES ?= $(wildcard cache/*.m4a)

X_FILES1 := ${X_FILES:.m4a=.wav}
X_FILES2 := ${X_FILES:.m4a=.play}
X_FILES3 := ${X_FILES:.m4a=.mp3}


all-local: ${X_FILES1}

all-local-mp3: ${X_FILES3}

play-local: ${X_FILES2}


cache/%.wav: cache/%.m4a
	ffmpeg -i $< $@

cache/%.mp3: cache/%.m4a
	ffmpeg -i $< $@

cache/%.play: cache/%.wav
	mpv $<


view-local:
	echo ${X_FILES1}
