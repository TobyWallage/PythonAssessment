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

;foreach loop did not work, index is unraveled index
;foreach element, source_image, index do begin
;    source_index = [50,50] - source_one + index
;    if ((source_index(0) gt 100) or (source_index(0) lt 0)) then begin
;        print, source_index
;        source_image(index) = 0 
;    endif else begin
;    if ((source_index(1) gt 100) or (source_index(1) lt 0)) then begin 
;        source_image(index) = 0
;    endif else begin 
;        source_image(index) = source_image(index) + base_gaussian_image(source_index) 
;    endelse
;    endelse
;             
;endforeach

image = dblarr(100,100)
;background image
background = (randomn(SEED, 100, 100) * 1) + 3
;set negative in background to zero
foreach element, background, index do begin
    if element lt 0.0 then begin
      background(index) = 0.0
    endif
    
endforeach


source_image_background = (background + source_image); * 10
mask_image = source_image_background * mask
;source_image = source_image
set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/source_image_bckg.eps', bits_per_pixel = 8, /color
tv, source_image_background*20
device, /close

set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/source_image.eps', bits_per_pixel = 8, /color
tv, source_image*20
device, /close

set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/source_image_mask.eps', bits_per_pixel = 8, /color
tv, mask_image*20
device, /close

print, 'done'

end