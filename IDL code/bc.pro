;copied from a.pro
image = dblarr(100,100)
background = (randomn(SEED, 100, 100) * 3) + 5
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

profile_oned = image(*, 50)

;weights = 1
A=[100.0,10.0]
;fit = curvefit(findgen(100), profile_oned, weights, A ,function_name=double_gauss)

yfit = gaussfit(findgen(100), profile_oned, coef, nterms=3)

print, coef
set_plot, 'PS'
device, file = '/mnt/lustre/users/astro/tlw31/profile_image.eps', bits_per_pixel = 8, /color
plot, profile_oned
oplot, yfit
device, /close
print, 'done'

end