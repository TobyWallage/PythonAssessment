from PIL import Image
import os

path = r'C:\Users\Toby\Documents\University\JRA\PythonAssessment\IDL code'
os.chdir(path)

ps_files = list(filter(lambda file: file[-4:] == '.eps', os.listdir()))

for file in ps_files:
    img = Image.open(file)
    img.save(file[:-4] + '.png')