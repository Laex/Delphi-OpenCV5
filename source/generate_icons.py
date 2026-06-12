import os
import subprocess

def save_bmp(filename, pixels):
    # pixels: 32 rows, each row has 32 (B, G, R) tuples
    header = bytearray(14)
    header[0:2] = b'BM'
    file_size = 54 + 32 * 32 * 3
    header[2:6] = file_size.to_bytes(4, 'little')
    header[10:14] = int(54).to_bytes(4, 'little')
    
    info = bytearray(40)
    info[0:4] = int(40).to_bytes(4, 'little')
    info[4:8] = int(32).to_bytes(4, 'little')
    info[8:12] = int(32).to_bytes(4, 'little')
    info[12:14] = int(1).to_bytes(2, 'little')
    info[14:16] = int(24).to_bytes(2, 'little')
    
    pixel_data = bytearray()
    # BMP stores lines bottom-to-top
    for y in reversed(range(32)):
        for x in range(32):
            b, g, r = pixels[y][x]
            pixel_data.append(b)
            pixel_data.append(g)
            pixel_data.append(r)
            
    with open(filename, 'wb') as f:
        f.write(header)
        f.write(info)
        f.write(pixel_data)

def make_icon(bg_color, draw_func):
    pixels = []
    r_sq = 5 * 5
    for y in range(32):
        row = []
        for x in range(32):
            in_square = True
            if x < 2 or x > 29 or y < 2 or y > 29:
                in_square = False
            else:
                if x < 7 and y < 7: # top-left
                    if (x - 7)**2 + (y - 7)**2 > r_sq: in_square = False
                elif x > 24 and y < 7: # top-right
                    if (x - 24)**2 + (y - 7)**2 > r_sq: in_square = False
                elif x < 7 and y > 24: # bottom-left
                    if (x - 7)**2 + (y - 24)**2 > r_sq: in_square = False
                elif x > 24 and y > 24: # bottom-right
                    if (x - 24)**2 + (y - 24)**2 > r_sq: in_square = False
            
            if in_square:
                color = draw_func(x, y, bg_color)
                row.append(color)
            else:
                row.append((255, 0, 255)) # fuchsia transparency
        pixels.append(row)
    return pixels

# Drawing functions (BGR)
def draw_camera(x, y, bg):
    if 8 <= x <= 18 and 11 <= y <= 20:
        return (255, 255, 255)
    if 19 <= x <= 23:
        dx = x - 19
        if 12 + dx <= y <= 19 - dx:
            return (255, 255, 255)
    if (x - 11)**2 + (y - 8)**2 <= 4:
        return (255, 255, 255)
    if (x - 16)**2 + (y - 8)**2 <= 4:
        return (255, 255, 255)
    return bg

def draw_videofile(x, y, bg):
    d_sq = (x - 16)**2 + (y - 16)**2
    if 6**2 <= d_sq <= 8**2:
        return (255, 255, 255)
    if 13 <= x <= 20:
        dy = int((x - 13) * 4 // 7)
        if 12 + dy <= y <= 20 - dy:
            return (255, 255, 255)
    if (x == 4 or x == 27) and (y % 4 < 2):
        return (255, 255, 255)
    return bg

def draw_detector(x, y, bg):
    if ((x - 16) / 5)**2 + ((y - 16) / 7)**2 <= 1.0:
        if (x == 14 or x == 18) and y == 14:
            return bg
        if y == 19 and 14 <= x <= 18:
            return bg
        return (255, 255, 255)
    if (y == 6 and 6 <= x <= 10) or (x == 6 and 6 <= y <= 10):
        return (255, 255, 255)
    if (y == 6 and 21 <= x <= 25) or (x == 25 and 6 <= y <= 10):
        return (255, 255, 255)
    if (y == 25 and 6 <= x <= 10) or (x == 6 and 21 <= y <= 25):
        return (255, 255, 255)
    if (y == 25 and 21 <= x <= 25) or (x == 25 and 21 <= y <= 25):
        return (255, 255, 255)
    return bg

def draw_recognizer(x, y, bg):
    if ((x - 16) / 5)**2 + ((y - 16) / 7)**2 <= 1.0:
        if (x == 14 or x == 18) and y == 14:
            return bg
        if y == 19 and 14 <= x <= 18:
            return bg
        return (255, 255, 255)
    if y == 16 and 5 <= x <= 26:
        return (0, 255, 0)
    if (y == 7 and 8 <= x <= 11) or (x == 8 and 7 <= y <= 10):
        return (255, 255, 255)
    if (y == 7 and 20 <= x <= 23) or (x == 23 and 7 <= y <= 10):
        return (255, 255, 255)
    if (y == 24 and 8 <= x <= 11) or (x == 8 and 21 <= y <= 24):
        return (255, 255, 255)
    if (y == 24 and 20 <= x <= 23) or (x == 23 and 21 <= y <= 24):
        return (255, 255, 255)
    return bg

def draw_pipeline(x, y, bg):
    if (x - 9)**2 + (y - 16)**2 <= 16:
        return (255, 255, 255)
    if (x - 22)**2 + (y - 9)**2 <= 16:
        return (255, 255, 255)
    if (x - 22)**2 + (y - 23)**2 <= 16:
        return (255, 255, 255)
    if 11 <= x <= 19 and abs(y - (-0.6 * x + 22)) < 1:
        return (255, 255, 255)
    if 11 <= x <= 19 and abs(y - (0.6 * x + 10)) < 1:
        return (255, 255, 255)
    return bg

def draw_view_vcl(x, y, bg):
    if (y == 7 or y == 20) and 5 <= x <= 26:
        return (255, 255, 255)
    if (x == 5 or x == 26) and 7 <= y <= 20:
        return (255, 255, 255)
    if y == 21 and 14 <= x <= 17:
        return (255, 255, 255)
    if y == 22 and 12 <= x <= 19:
        return (255, 255, 255)
    if 10 <= y <= 17:
        if abs(x - (y - 1)) <= 1 or abs(x - (30 - y)) <= 1:
            if y <= 16:
                return (255, 255, 255)
    return bg

def draw_view_fmx(x, y, bg):
    if (y == 7 or y == 20) and 5 <= x <= 26:
        return (255, 255, 255)
    if (x == 5 or x == 26) and 7 <= y <= 20:
        return (255, 255, 255)
    if y == 21 and 14 <= x <= 17:
        return (255, 255, 255)
    if y == 22 and 12 <= x <= 19:
        return (255, 255, 255)
    if x == 11 and 10 <= y <= 17:
        return (255, 255, 255)
    if y == 10 and 11 <= x <= 19:
        return (255, 255, 255)
    if y == 13 and 11 <= x <= 16:
        return (255, 255, 255)
    return bg

def main():
    source_dir = os.path.dirname(os.path.abspath(__file__))
    icons_dir = os.path.join(source_dir, 'icons')
    if not os.path.exists(icons_dir):
        os.makedirs(icons_dir)
        
    icons = {
        'TcvCamera': ((220, 150, 50), draw_camera),
        'TcvVideoFile': ((180, 50, 150), draw_videofile),
        'TcvFaceDetector': ((80, 180, 50), draw_detector),
        'TcvFaceRecognizer': ((50, 100, 220), draw_recognizer),
        'TcvPipeline': ((150, 150, 50), draw_pipeline),
        'TcvViewVcl': ((180, 80, 30), draw_view_vcl),
        'TcvViewFmx': ((80, 30, 200), draw_view_fmx)
    }
    
    for name, (bg, draw_func) in icons.items():
        pixels = make_icon(bg, draw_func)
        filepath = os.path.join(icons_dir, f'{name}.bmp')
        save_bmp(filepath, pixels)
        print(f'Generated {filepath}')
        
    # Write RC files
    # 1. OpenCV5Icons.rc
    with open(os.path.join(source_dir, 'OpenCV5Icons.rc'), 'w') as f:
        f.write('TCVCAMERA BITMAP "icons\\\\TcvCamera.bmp"\n')
        f.write('TCVVIDEOFILE BITMAP "icons\\\\TcvVideoFile.bmp"\n')
        f.write('TCVFACEDETECTOR BITMAP "icons\\\\TcvFaceDetector.bmp"\n')
        f.write('TCVFACERECOGNIZER BITMAP "icons\\\\TcvFaceRecognizer.bmp"\n')
        f.write('TCVPIPELINE BITMAP "icons\\\\TcvPipeline.bmp"\n')
        
    # 2. OpenCV5VclIcons.rc
    with open(os.path.join(source_dir, 'OpenCV5VclIcons.rc'), 'w') as f:
        f.write('TCVVIEWVCL BITMAP "icons\\\\TcvViewVcl.bmp"\n')
        
    # 3. OpenCV5FmxIcons.rc
    with open(os.path.join(source_dir, 'OpenCV5FmxIcons.rc'), 'w') as f:
        f.write('TCVVIEWFMX BITMAP "icons\\\\TcvViewFmx.bmp"\n')
        
    print('Generated RC files.')
    
    # Compile RC to RES using brcc32
    brcc32 = r"C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\brcc32.exe"
    rc_files = ['OpenCV5Icons.rc', 'OpenCV5VclIcons.rc', 'OpenCV5FmxIcons.rc']
    
    for rc in rc_files:
        rc_path = os.path.join(source_dir, rc)
        cmd = [brcc32, rc_path]
        print(f'Running: {" ".join(cmd)}')
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode == 0:
            print(f'Successfully compiled {rc} to .res')
        else:
            print(f'Failed to compile {rc}:')
            print(res.stdout)
            print(res.stderr)

if __name__ == '__main__':
    main()
