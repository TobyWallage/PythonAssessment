;skipping d-f
;(g)
;Generate a 101 by 101 array, then:
;
;add 3 synthetic “sources” by taking random locations and generating 2-D Gaussians around each one. Start with a peak value of 10 and a sigma of 3 (below left).
;Then add a noisy background that has a mean value of 3 and a sigma of 1 (below middle).
;Then set all values (sources and background) to zero outside a circle of radius 40 pixels (below right).
;Repeat 2 times (to make 6 images in total). Display all the images to the screen.

;generate locations of three sources
source_one = fix(100*randomu(SEED, 2))
source_two = fix(100*randomu(SEED, 2))
source_three = fix(100*randomu(SEED, 2))

;base signal that is essentialy copied and pasted to the location of each source
base_gaussian_image = gaussian_function([3,3], width = 100, maximum = 10)

print, source_one
print, source_two
print, source_three

source_image = dblarr(100,100)

mask = dblarr(100,100)
;source_one = [30,30]

for x=0, 99 do begin
    for y=0, 99 do begin

        ;add source one
        source_index = [50,50] - source_one + [x,y]
        if ((source_index(0) gt 99) or (source_index(0) lt 0)) or ((source_index(1) gt 99) or (source_index(1) lt 0)) then begin
            source_image[x,y] = source_image[x,y] + 0
        endif else begin
            value = base_gaussian_image(source_index[0], source_index[1])
            source_image[x,y] = source_image[x,y] + value
        endelse

        ;add source two
        source_index = [50,50] - source_two + [x,y]
        if ((source_index(0) gt 99) or (source_index(0) lt 0)) or ((source_index(1) gt 99) or (source_index(1) lt 0)) then begin
            source_image[x,y] = source_image[x,y] + 0
        endif else begin
            value = base_gaussian_image(source_index[0], source_index[1])
            source_image[x,y] = source_image[x,y] + value
        endelse

        ;add source three
        source_index = [50,50] - source_three + [x,y]
        if ((source_index(0) gt 99) or (source_index(0) lt 0)) or ((source_index(1) gt 99) or (source_index(1) lt 0)) then begin
            source_image[x,y] = source_image[x,y] + 0
        endif else begin
            value = base_gaussian_image(source_index[0], source_index[1])
            source_image[x,y] = source_image[x,y] + value
        endelse
        
        if ((x-50)^2 + (y-50)^2) le 40^2 then mask[x,y] = 1 else mask[x,y] = 0

    endfor
endfor



image = dblarr(100,100)

;background image
background = (randomn(SEED, 100, 100) * 1) + 3
;set negatives in background to zero
foreach element, background, index do begin
    if element lt 0.0 then begin
      background(index) = 0.0
    endif
    
endforeach

;(h)
;Run through each of your six images and alert the user if any of the sources therein falls within 10 pixels of the inside edge of your 40 pixel circle or in the “zero’d” region outside.
;
;im only doing one image since it is basically the same thing that can just be repeated.

radius = (source_one[0] - 50)^2 + (source_one[1] - 50)^2
print, 'source_one'
if radius gt (40)^2 then print,'source detected outside' else $
if radius gt (40-10)^2 then print, 'source detected on inner edge' else print, 'source in center'

radius = (source_two[0] - 50)^2 + (source_two[1] - 50)^2
print, 'source_two'
if radius gt (40)^2 then print,'source detected outside' else $
if radius gt (40-10)^2 then print, 'source detected on inner edge' else print, 'source in center'

radius = (source_three[0] - 50)^2 + (source_three[1] - 50)^2
print, 'source_three'
if radius gt (40)^2 then print,'source detected outside' else $
if radius gt (40-10)^2 then print, 'source detected on inner edge' else print, 'source in center'


source_image_background = (background + source_image); * 10
mask_image = source_image_background * mask
;source_image = source_image
set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/source_image_bckg.eps', bits_per_pixel = 8, /color
tv, source_image_background*15
device, /close

set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/source_image.eps', bits_per_pixel = 8, /color
tv, source_image*15
device, /close

set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/source_image_mask.eps', bits_per_pixel = 8, /color
tv, mask_image*15
device, /close

print, 'done' 

end