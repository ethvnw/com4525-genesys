const images = document.getElementById('login-slideshow').children;
const SLIDESHOW_INTERVAL = 3000;

// Initialising the index to track the currently displayed image
let currentImage = 0;

setInterval(() => {
  images[currentImage].classList.remove('show');
  // Calculate the index of the next image so it creates a loop
  currentImage = (currentImage + 1) % images.length;
  images[currentImage].classList.add('show');
}, SLIDESHOW_INTERVAL);
