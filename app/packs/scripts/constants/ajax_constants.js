const csrfMetaTag = document.querySelector('meta[name="csrf-token"]');

const CSRF_TOKEN = csrfMetaTag && csrfMetaTag.content;

export default CSRF_TOKEN;
