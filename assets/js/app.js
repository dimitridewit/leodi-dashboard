// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

(() => {
  const $navbarBurger = document.querySelector('.navbar-burger');

  if ($navbarBurger) {
    const $target = document.getElementById($navbarBurger.dataset.target);

    const open = () => {
      $navbarBurger.classList.add('is-active');
      $target.classList.add('is-active');
    };

    const close = () => {
      $navbarBurger.classList.remove('is-active');
      $target.classList.remove('is-active');
    };

    const toggle = () => {
      $navbarBurger.classList.contains('is-active') ? close() : open();
    };

    $navbarBurger.addEventListener('click', toggle);

    window.addEventListener('resize', () => {
      window.innerWidth >= 1440 ? open() : close();
    });
  }

})();
