from PIL import Image

img_path = r'C:\Users\ASUS\OneDrive\Desktop\Sehat\image\Health.ID.png'
im = Image.open(img_path)
w, h = im.size
rgb = im.convert('RGB')
print(f'Size: {w}x{h}')

# Check corners and bands
print('\n--- Edge analysis ---')
for y in list(range(0, 30, 2)) + list(range(44, 75, 2)) + [100, 200, 300, 400, 500, 600, 700, 800] + list(range(max(0, h-30), h, 2)):
    if y < h:
        center = rgb.getpixel((w//2, y))
        left = rgb.getpixel((10, y))
        print(f'y={y:2d}: center={center} left={left}')
