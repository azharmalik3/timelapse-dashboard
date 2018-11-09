// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import Vue from 'vue'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import Notifications from 'vue-notification'
import VueVideoPlayer from 'vue-video-player'
import "jquery/dist/jquery"
import "popper.js"
import "bootstrap/dist/js/bootstrap"
import css from "../css/app.scss"
import "@coreui/coreui/dist/js/coreui"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"


// Import Vue components
import App from "../components/App"
import timelapse from "../components/timelapse"
import gallery from "../components/gallery"
import watch from "../components/watch"

Vue.config.productionTip = false
Vue.use(VueResource)
Vue.use(VueRouter)
Vue.use(Notifications)
Vue.use(VueVideoPlayer)

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/gallery',
      name: 'gallery',
      component: gallery,
    },
    {
      path: '/timelapse',
      name: 'timelapse',
      component: timelapse,
    },
    {
      path: '/watch/:id',
      name: 'watch',
      component: watch,
    }
  ],
});

new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
}).$mount('#app');
