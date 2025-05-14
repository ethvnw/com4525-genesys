/* eslint-disable import/no-unresolved */
import Swiper from 'swiper/bundle';
import ColorThief from 'colorthief';

const colourThief = new ColorThief();

/**
 * Adjusts the brightness of an RGB colour by a percentage
 * A positive percentage lightens the colour, while a negative percentage darkens it
 * Based on Pablo's answer [https://stackoverflow.com/a/13532993], CC BY-SA 4.0
 *
 * @param {number} r - The red component of the colour (0-255)
 * @param {number} g - The green component of the colour (0-255)
 * @param {number} b - The blue component of the colour (0-255)
 * @param {number} percent - The percentage to adjust the brightness
 * @returns {string} The adjusted RGB colour as an rgb() string
 */
function shadeColourRGB(r, g, b, percent) {
  const newR = Math.min(255, Math.max(0, Math.round((r * (100 + percent)) / 100)));
  const newG = Math.min(255, Math.max(0, Math.round((g * (100 + percent)) / 100)));
  const newB = Math.min(255, Math.max(0, Math.round((b * (100 + percent)) / 100)));

  return `rgb(${newR}, ${newG}, ${newB})`;
}

/**
 * Calculates the luminance of a colour using its RGB components
 * The luminance is a measure of the perceived brightness of the colour
 * See [https://en.wikipedia.org/wiki/Relative_luminance]
 *
 * @param {number} r - The red component of the colour (0-255)
 * @param {number} g - The green component of the colour (0-255)
 * @param {number} b - The blue component of the colour (0-255).
 * @returns {number} The luminance of the colour (between 0 and 1)
 */
function calculateLuminance(r, g, b) {
  return (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255;
}

/**
 * Applies a background gradient to the trips carousel
 * @param {HTMLDivElement} currentSlide - The currently selected slide in the carousel
 */
async function applyBackgroundGradient(currentSlide) {
  const currentImage = currentSlide?.querySelector('img');
  const background = document.getElementById('home-bg');
  if (!currentImage || !background) return;

  // Apply a gradient to the background based on the colour of the current slide image
  const applyGradientFromColour = () => {
    if (!currentImage.complete) return;

    // Initialise the colour values
    let r; 
    let g; 
    let b;

    try {
      [r, g, b] = colourThief.getColor(currentImage);
    } catch (error) {
      [r, g, b] = [255, 255, 255];
    }
    const luminance = calculateLuminance(r, g, b);

    // For lighter colours, darken it so text remains legible
    if (luminance > 0.8) {
      r = Math.round(r * 0.5);
      g = Math.round(g * 0.5);
      b = Math.round(b * 0.5);
    } else if (luminance > 0.65) {
      r = Math.round(r * 0.6);
      g = Math.round(g * 0.6);
      b = Math.round(b * 0.6);
    } else if (luminance > 0.55) {
      r = Math.round(r * 0.7);
      g = Math.round(g * 0.7);
      b = Math.round(b * 0.7);
    }

    const lightShade = shadeColourRGB(r, g, b, 50);
    const darkShade = shadeColourRGB(r, g, b, -30);
    background.style.setProperty('--top-shade', lightShade);
    background.style.setProperty('--bottom-shade', darkShade);
  };

  if (currentImage.complete) {
    applyGradientFromColour();
  } else {
    currentImage.addEventListener('load', () => {
      applyGradientFromColour();
    });
  }
}

const latestTripsConfig = {
  direction: 'horizontal',
  loop: false,
  a11y: true,
  slidesPerView: 1,
  centeredSlides: false,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  breakpoints: {
    1081: { slidesPerView: 2 },
    1466: { slidesPerView: 3 },
  },
};

const featuredLocationsConfig = {
  direction: 'horizontal',
  loop: false,
  a11y: true,
  slidesPerView: 1,
  centeredSlides: false,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  breakpoints: {
    400: { slidesPerView: 2 }, // xsm
    490: { slidesPerView: 3 }, // sm
    768: { slidesPerView: 4 }, // md
    1050: { slidesPerView: 5 }, // lg
    1200: { slidesPerView: 6 }, // xl
    1400: { slidesPerView: 7 }, // xxl
  },
};

/* eslint-disable no-unused-vars */
/* Carousels */
const latestTripsCarousel = new Swiper('.latest-trips-carousel', {
  ...latestTripsConfig,
  on: {
    init() {
      const currentSlide = this.slides[this.activeIndex];
      (async () => {
        await applyBackgroundGradient(currentSlide);
      })();
    },
    activeIndexChange() {
      const currentSlide = this.slides[this.activeIndex];
      (async () => {
        await applyBackgroundGradient(currentSlide);
      })();
    },
  },
});

const featuredLocationsCarousel = new Swiper(
  '.featured-locations-carousel',
  featuredLocationsConfig,
);

/**
 * Reverts the background gradient to the first slide in the trips carousel
 */
async function revertBackgroundGradient() {
  await applyBackgroundGradient(latestTripsCarousel.slides[latestTripsCarousel.activeIndex]);
}

document.querySelectorAll('.latest-trips-carousel .swiper-slide').forEach((slide) => {
  slide.addEventListener('mouseenter', () => {
    (async () => {
      await applyBackgroundGradient(slide);
    })();
  });
  slide.addEventListener('mouseleave', () => {
    revertBackgroundGradient();
  });
});
