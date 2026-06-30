#!/usr/bin/env python3
from pathlib import Path
import math
import subprocess

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = ROOT / "Assets"
ICONSET_DIR = ASSET_DIR / "Hog.iconset"
README_ICON = ASSET_DIR / "HogIcon.png"
ICNS_PATH = ASSET_DIR / "Hog.icns"


def rounded_rect_mask(size: int, radius: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size, size), radius=radius, fill=255)
    return mask


def draw_icon(size: int) -> Image.Image:
    scale = size / 1024
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))

    base = Image.new("RGBA", (size, size), (21, 23, 26, 255))
    bg = ImageDraw.Draw(base)

    for y in range(size):
        t = y / max(size - 1, 1)
        r = int(31 - 10 * t)
        g = int(34 - 11 * t)
        b = int(38 - 12 * t)
        bg.line([(0, y), (size, y)], fill=(r, g, b, 255))

    mask = rounded_rect_mask(size, int(220 * scale))
    image.alpha_composite(Image.composite(base, Image.new("RGBA", (size, size), (0, 0, 0, 0)), mask))

    shine = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    shine_draw = ImageDraw.Draw(shine)
    shine_draw.ellipse(
        (
            int(-120 * scale),
            int(-300 * scale),
            int(1140 * scale),
            int(650 * scale),
        ),
        fill=(255, 255, 255, 20),
    )
    image.alpha_composite(Image.composite(shine, Image.new("RGBA", (size, size), (0, 0, 0, 0)), mask))

    mark = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(mark)

    stroke = int(54 * scale)
    snout = (
        int(236 * scale),
        int(358 * scale),
        int(788 * scale),
        int(664 * scale),
    )
    radius = int(112 * scale)
    draw.rounded_rectangle(snout, radius=radius, outline=(236, 238, 241, 255), width=stroke)

    nostril_radius = int(42 * scale)
    for cx in (int(424 * scale), int(600 * scale)):
        cy = int(512 * scale)
        draw.ellipse(
            (
                cx - nostril_radius,
                cy - nostril_radius,
                cx + nostril_radius,
                cy + nostril_radius,
            ),
            fill=(236, 238, 241, 255),
        )

    shadow = mark.filter(ImageFilter.GaussianBlur(radius=max(1, int(12 * scale))))
    shadow_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    shadow_layer.alpha_composite(shadow, (0, int(12 * scale)))
    image.alpha_composite(Image.new("RGBA", (size, size), (0, 0, 0, 0)))
    image.alpha_composite(shadow_layer)
    image.alpha_composite(mark)

    return image


def main() -> None:
    ASSET_DIR.mkdir(exist_ok=True)
    ICONSET_DIR.mkdir(exist_ok=True)

    icon = draw_icon(1024)
    icon.save(README_ICON)

    sizes = [
        ("icon_16x16.png", 16),
        ("icon_16x16@2x.png", 32),
        ("icon_32x32.png", 32),
        ("icon_32x32@2x.png", 64),
        ("icon_128x128.png", 128),
        ("icon_128x128@2x.png", 256),
        ("icon_256x256.png", 256),
        ("icon_256x256@2x.png", 512),
        ("icon_512x512.png", 512),
        ("icon_512x512@2x.png", 1024),
    ]

    for filename, pixel_size in sizes:
        resized = icon.resize((pixel_size, pixel_size), Image.Resampling.LANCZOS)
        resized.save(ICONSET_DIR / filename)

    if ICNS_PATH.exists():
        ICNS_PATH.unlink()
    subprocess.run(["iconutil", "-c", "icns", str(ICONSET_DIR), "-o", str(ICNS_PATH)], check=True)


if __name__ == "__main__":
    main()
