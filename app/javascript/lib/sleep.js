/*
 Copyright (C) 2015 Ivan Maeder
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 -
 Prevent computer or display sleep with HTML5/JavaScript. Include this
 file then use the following:
     sleep.prevent()
     sleep.allow()
 */

let video;

export function prevent() {
  if (!video) {
    init();
  }

  video.setAttribute("loop", "loop");
  video.play();
}

export function allow() {
  if (!video) {
    return;
  }

  video.removeAttribute("loop");
  video.pause();
}

function init() {
  video = document.createElement("video");
  video.setAttribute("width", "10");
  video.setAttribute("height", "10");
  video.style.position = "absolute";
  video.style.top = "-10px";
  video.style.left = "-10px";

  const source_mp4 = document.createElement("source");
  source_mp4.setAttribute(
    "src",
    "https://github.com/ivanmaeder/computer-sleep/raw/master/resources/muted-blank.mp4"
  );
  source_mp4.setAttribute("type", "video/mp4");
  video.appendChild(source_mp4);

  const source_ogg = document.createElement("source");
  source_ogg.setAttribute(
    "src",
    "https://github.com/ivanmaeder/computer-sleep/raw/master/resources/muted-blank.ogv"
  );
  source_ogg.setAttribute("type", "video/ogg");
  video.appendChild(source_ogg);

  document.body.appendChild(video);
}
