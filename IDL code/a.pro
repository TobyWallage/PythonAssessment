;this is a comment
image = dblarr(100,100)
background = (randomn(SEED, 101, 101) * 3) + 5
image = image + background
gaussian_image = gaussian_function([10,10], width = 100, maximum = 100)

foreach element, gaussian_image, index do begin
    noise = (randomn(SEED, 1) * sqrt(element)) + element
    gaussian_image(index) = gaussian_image(index) + noise
endforeach

image = image + gaussian_image

gaussian_image = gaussian_function([3,3], width = 100, maximum = 20)

foreach element, gaussian_image, index do begin
    noise = (randomn(SEED, 1) * sqrt(element)) + element
    gaussian_image(index) = gaussian_image(index) + noise
endforeach

image = image + gaussian_image

print, size(image)
print, image(*,50)
set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/image.eps', /land, bits_per_pixel = 8, /color
tv, image
loadct,3
device, /close
print, 'done'
end