#!/usr/bin/env python3
"""Generate the website icons from the portrait (needs Pillow: pip install pillow).

    python3 scripts/make_icons.py

Writes favicon.ico (16, 32 and 48 px), images/icon-192.png and images/apple-touch-icon.png.
The icon is a tight crop of images/portrait.jpeg in a circle with a thin navy ring (the site's
--ink colour). Adjust FACE_CENTRE and FACE_SIZE to change the crop. Rendering happens at a
high resolution and is scaled down, so the small sizes stay smooth.
"""
from PIL import Image, ImageDraw

FACE_CENTRE = (380, 315)   # x, y in the 750 x 750 portrait
FACE_SIZE = 430            # side of the square that is cropped, in portrait pixels
NAVY = (20, 33, 61, 255)
MASTER = 2048              # supersampling size

portrait = Image.open("images/portrait.jpeg").convert("RGB")
x0, y0 = FACE_CENTRE[0] - FACE_SIZE // 2, FACE_CENTRE[1] - FACE_SIZE // 2
face = portrait.crop((x0, y0, x0 + FACE_SIZE, y0 + FACE_SIZE)).resize((MASTER, MASTER), Image.LANCZOS)

# circular icon with a thin ring (transparent corners)
mask = Image.new("L", (MASTER, MASTER), 0)
ImageDraw.Draw(mask).ellipse((0, 0, MASTER - 1, MASTER - 1), fill=255)
circle = Image.new("RGBA", (MASTER, MASTER), (0, 0, 0, 0))
circle.paste(face, (0, 0), mask)
ImageDraw.Draw(circle).ellipse((0, 0, MASTER - 1, MASTER - 1), outline=NAVY, width=int(MASTER * 0.035))

circle.resize((256, 256), Image.LANCZOS).save("favicon.ico", sizes=[(16, 16), (32, 32), (48, 48)])
circle.resize((192, 192), Image.LANCZOS).save("images/icon-192.png", optimize=True)

# iPhone/iPad home screen icons must be opaque and square (the system rounds the corners)
face.resize((180, 180), Image.LANCZOS).save("images/apple-touch-icon.png", optimize=True)
print("wrote favicon.ico, images/icon-192.png, images/apple-touch-icon.png")
