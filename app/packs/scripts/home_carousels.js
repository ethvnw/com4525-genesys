/* eslint-disable import/no-unresolved */
import Swiper from 'swiper/bundle';

const latestTripsConfig = {
  direction: 'horizontal',
  loop: true,
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
  loop: true,
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
    activeIndexChange() {
      const currentSlide = this.slides[this.activeIndex];
      const currentImg = currentSlide.querySelector('img');

      if (currentImg) {
        document.getElementById('home-bg').style.backgroundImage = `
        linear-gradient(to bottom, rgba(0, 0, 0, 1) 0%, rgba(0, 0, 0, 0) 60%),
        url('${currentImg.src}')`;
      }
    },
  },
});

const featuredLocationsCarousel = new Swiper(
  '.featured-locations-carousel',
  featuredLocationsConfig,
);
