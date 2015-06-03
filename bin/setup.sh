#!/bin/bash

if ! command -v brew ; then
  echo 'homebrew not installed! Installing . . .'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo 'brew installed'
fi

if ! command -v nginx; then
  echo 'nginx not installed! Installing. . . '
  brew tap homebrew/nginx
  brew install nginx-full
fi

curl -C - -O https://s3.amazonaws.com/vid-streaming-test/ecm-presentation.mp4
curl -C - -O https://s3.amazonaws.com/vid-streaming-test/ecm-presenter.mp4
curl -C - -O https://s3.amazonaws.com/vid-streaming-test/ecm-presentation.jpg
curl -C - -O https://s3.amazonaws.com/vid-streaming-test/ecm-presenter.jpg

./bin/nginx restart

if ! command -v npm; then
  brew install npm
fi

if ! command -v grunt; then
  npm -g install grunt-cli
fi

if ! command -v jshint; then
  npm -g install jshint
fi

if ! [ -d 'paella' ]; then
  git clone https://github.com/harvard-dce/paella/ paella
fi

cd paella
git checkout dce-release
npm install
mkdir -p repository_test/repository/paella-demo/

echo  '{
    "mediapackage": {
        "media": {
            "tracks": [
                {
                    "mimetype": "video/mp4",
                    "tags": [],
                    "url": "http://localhost:8001/ecm-presenter.mp4",
                    "mediainfo": {
                        "video": {
                            "scantype": {
                                "type": "Progressive"
                            },
                            "bitrate": 200000,
                            "framerate": 30,
                            "encoder": {
                                "type": "AVC"
                            },
                            "device": "",
                            "resolution": "1920x1080",
                            "id": "video-1"
                        }
                    },
                    "preview": "http://localhost:8001/ecm-presenter.jpg",
                    "type": "presenter/delivery",
                    "id": "22b89582-5baf-449c-a92e-71ef5fb437a4"
                },
                {
                    "mimetype": "video/mp4",
                    "tags": [],
                    "url": "http://localhost:8001/ecm-presentation.mp4",
                    "mediainfo": {
                        "video": {
                            "scantype": {
                                "type": "Progressive"
                            },
                            "bitrate": 200000,
                            "framerate": 30,
                            "encoder": {
                                "type": "AVC"
                            },
                            "device": "",
                            "resolution": "1920x1080",
                            "id": "video-1"
                        }
                    },
                    "preview": "http://localhost:8001/ecm-presentation.jpg",
                    "type": "presentation/delivery",
                    "id": "500f6b74-1557-4c87-8613-0ce5194b84ba"
                }
            ]
        }
    },
    "version": "1.0.0"
}' > repository_test/repository/paella-demo/episode.json

echo 'open your web browser to http://localhost:8000/player/index.html?paella-demo'

grunt server.debug



