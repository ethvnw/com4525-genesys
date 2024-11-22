/* eslint-disable import/no-unresolved */
import Swiper from 'swiper/bundle';

const carouselConfig = {
  direction: 'horizontal',
  loop: true,
  slidesPerView: 1,
  centeredSlides: true,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  scrollbar: {
    el: '.swiper-scrollbar',
  },
  breakpoints: {
    480: { slidesPerView: 2 }, // xsm
    576: { slidesPerView: 2 }, // sm
    768: { slidesPerView: 3 }, // md
    992: { slidesPerView: 3 }, // lg
    1200: { slidesPerView: 4 }, // xl
    1400: { slidesPerView: 5 }, // xxl
  },
};

/* eslint-disable no-unused-vars */
/* Carousels */
const featuresCarousel = new Swiper('.features-carousel', carouselConfig);
const reviewsCarousel = new Swiper('.reviews-carousel', carouselConfig);
